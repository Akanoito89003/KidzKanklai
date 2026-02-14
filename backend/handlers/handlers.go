package handlers

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func RegisterUser(c *gin.Context) {
	var u models.User
	if err := c.ShouldBindJSON(&u); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	// Simple insert
	err := config.DB.QueryRow(
		"INSERT INTO users (username, email, password) VALUES ($1, $2, $3) RETURNING id",
		u.Username, u.Email, u.Password,
	).Scan(&u.ID)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Registration failed: " + err.Error()})
		return
	}

	c.JSON(http.StatusCreated, u)
}

func LoginUser(c *gin.Context) {
	var req models.LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	var u models.User
	err := config.DB.QueryRow(
		"SELECT id, username, email, level, coins FROM users WHERE email = $1 AND password = $2",
		req.Email, req.Password,
	).Scan(&u.ID, &u.Username, &u.Email, &u.Level, &u.Coins)

	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	c.JSON(http.StatusOK, u)
}

func GetUserProfile(c *gin.Context) {
	id := c.Param("id")
	var u models.User
	err := config.DB.QueryRow(`
		SELECT id, username, email, level, exp, coins, tickets, vouchers, bio, 
		       sound_bgm, sound_sfx, equipped_skin, equipped_hair, equipped_face,
		       stat_intellect, stat_strength, stat_creativity, equipped_pose
		FROM users WHERE id = $1`, id,
	).Scan(
		&u.ID, &u.Username, &u.Email, &u.Level, &u.Exp, &u.Coins, &u.Tickets, &u.Vouchers, &u.Bio,
		&u.SoundBGM, &u.SoundSFX, &u.EquippedSkin, &u.EquippedHair, &u.EquippedFace,
		&u.StatIntellect, &u.StatStrength, &u.StatCreativity, &u.EquippedPose,
	)

	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	c.JSON(http.StatusOK, u)
}

func UpdateUserProfile(c *gin.Context) {
	var req models.UpdateProfileRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	_, err := config.DB.Exec(
		"UPDATE users SET bio=$1, sound_bgm=$2, sound_sfx=$3 WHERE id=$4",
		req.Bio, req.SoundBGM, req.SoundSFX, req.ID,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Profile updated"})
}

func GetUserInventory(c *gin.Context) {
	userID := c.Param("id")
	// Join inventory with items to get details
	rows, err := config.DB.Query(`
		SELECT i.id, i.user_id, i.item_id, t.name, t.image_path, t.category, t.rive_id 
		FROM inventory i
		JOIN items t ON i.item_id = t.id
		WHERE i.user_id = $1
	`, userID)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer rows.Close()

	var inventory []models.InventoryItem
	for rows.Next() {
		var item models.InventoryItem
		if err := rows.Scan(&item.ID, &item.UserID, &item.ItemID, &item.Name, &item.Image, &item.Category, &item.RiveID); err != nil {
			continue
		}
		inventory = append(inventory, item)
	}

	c.JSON(http.StatusOK, inventory)
}

func EquipItem(c *gin.Context) {
	var req models.EquipRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	// Dynamic column update based on Category
	var column string
	switch req.Category {
	case "hair":
		column = "equipped_hair"
	case "skin":
		column = "equipped_skin"
	case "face":
		column = "equipped_face"
	default:
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid category"})
		return
	}

	// Update the user's equipped item
	// Note: We are storing the Item Name (e.g. "Hair Style 1") in the users table for specific compatibility with Flutter parsing
	query := "UPDATE users SET " + column + " = $1 WHERE id = $2"
	_, err := config.DB.Exec(query, req.Name, req.UserID)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to equip: " + err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Equipped successfully", "equipped": req.Name})
}
