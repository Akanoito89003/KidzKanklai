package handlers

import (
	config "backend/configs"
	"context"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

// Response Structs
type InventoryResponse struct {
	ID          int64   `json:"id"`
	Name        string  `json:"name"`
	Description *string `json:"description"`
	Image       *string `json:"image"`
	Rarity      *string `json:"rarity"`
	Category    *string `json:"category"`
}

type EquipItemInput struct {
	ItemID int64 `json:"item_id" binding:"required"`
}

// GET /inventory
func GetInventory(c *gin.Context) {
	userId, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	query := `
		SELECT i.id, i.name, i.description, i.image, i.rarity, c.name
		FROM public.collect col
		JOIN public.items i ON col.item_id = i.id
		LEFT JOIN public.categories c ON i.category_id = c.id
		WHERE col.user_id = $1
	`

	rows, err := config.DB.Query(context.Background(), query, userId)
	if err != nil {
		fmt.Println("❌ GetInventory Query Error:", err) // Add Log here
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch inventory: " + err.Error()})
		return
	}
	defer rows.Close()

	var inventory []InventoryResponse
	for rows.Next() {
		var item InventoryResponse
		if err := rows.Scan(&item.ID, &item.Name, &item.Description, &item.Image, &item.Rarity, &item.Category); err != nil {
			continue
		}
		inventory = append(inventory, item)
	}

	c.JSON(http.StatusOK, gin.H{"inventory": inventory})
}

// POST /equip
func EquipItem(c *gin.Context) {
	userId, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	var input EquipItemInput
	if err := c.ShouldBindJSON(&input); err != nil {
		fmt.Println("❌ EquipItem Parsing Error:", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}
	fmt.Printf("🔧 Equip Request: ItemID=%d, UserID=%v\n", input.ItemID, userId)

	ctx := context.Background()

	// 1. ตรวจสอบว่ามีของชิ้นนี้จริงไหมและเป็นของ User คนนี้มั้ย
	var categoryName string
	checkQuery := `
		SELECT c.name 
		FROM public.collect col
		JOIN public.items i ON col.item_id = i.id
		JOIN public.categories c ON i.category_id = c.id
		WHERE col.user_id = $1 AND col.item_id = $2
	`
	err := config.DB.QueryRow(ctx, checkQuery, userId, input.ItemID).Scan(&categoryName)
	if err != nil {
		fmt.Println("❌ EquipItem Ownership Check Failed:", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": "You do not own this item"})
		return
	}

	// 2. หา Character ID ของ User
	var charID int64
	err = config.DB.QueryRow(ctx, "SELECT id FROM public.characters WHERE user_id = $1", userId).Scan(&charID)
	if err != nil {
		// ⚠️ ถ้าไม่มี Character ให้สร้างใหม่เลย (Self-Healing)
		fmt.Println("⚠️ Character not found, creating new one for user:", userId)
		err = config.DB.QueryRow(ctx, "INSERT INTO public.characters (user_id) VALUES ($1) RETURNING id", userId).Scan(&charID)
		if err != nil {
			fmt.Println("❌ Failed to create character:", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create character record"})
			return
		}
	}

	// 3. สวมใส่ (Upsert into wear)
	// Logic: ลบของเก่าประเภทเดียวกันออก -> ใส่ของใหม่
	// หมายเหตุ: Table 'wear' ออกแบบมาให้เก็บ character_id, item_id, type
	// เราจะลบ item ที่มี type เดียวกันของ character นี้ออกก่อน

	tx, err := config.DB.Begin(ctx)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Transaction failed"})
		return
	}
	defer tx.Rollback(ctx)

	// ลบของเก่าประเภทเดียวกัน (เช่น ใส่เสื้อใหม่ ถอดเสื้อเก่า)
	_, err = tx.Exec(ctx, `
		DELETE FROM public.wear 
		WHERE character_id = $1 AND type = $2
	`, charID, categoryName)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to unequip old item"})
		return
	}

	// ใส่ของใหม่
	_, err = tx.Exec(ctx, `
		INSERT INTO public.wear (character_id, item_id, type)
		VALUES ($1, $2, $3)
	`, charID, input.ItemID, categoryName)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to equip item"})
		return
	}

	if err := tx.Commit(ctx); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Commit failed"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Equipped successfully", "item_id": input.ItemID, "type": categoryName})
}

// GET /equipped
func GetEquippedItems(c *gin.Context) {
	userId, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	query := `
		SELECT i.id, i.name, i.image, w.type
		FROM public.wear w
		JOIN public.items i ON w.item_id = i.id
		JOIN public.characters ch ON w.character_id = ch.id
		WHERE ch.user_id = $1
	`

	rows, err := config.DB.Query(context.Background(), query, userId)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch equipped items"})
		return
	}
	defer rows.Close()

	var equipped []gin.H
	for rows.Next() {
		var id int64
		var name, image, itemType string
		if err := rows.Scan(&id, &name, &image, &itemType); err == nil {
			equipped = append(equipped, gin.H{
				"id": id, "name": name, "image": image, "type": itemType,
			})
		}
	}

	c.JSON(http.StatusOK, gin.H{"equipped": equipped})
}
