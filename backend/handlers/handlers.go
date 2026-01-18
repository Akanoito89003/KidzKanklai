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
		       stat_intellect, stat_strength, stat_creativity
		FROM users WHERE id = $1`, id,
	).Scan(
		&u.ID, &u.Username, &u.Email, &u.Level, &u.Exp, &u.Coins, &u.Tickets, &u.Vouchers, &u.Bio,
		&u.SoundBGM, &u.SoundSFX, &u.EquippedSkin, &u.EquippedHair, &u.EquippedFace,
		&u.StatIntellect, &u.StatStrength, &u.StatCreativity,
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
	rows, err := config.DB.Query("SELECT item_type, item_id FROM inventory WHERE user_id = $1", userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer rows.Close()

	var items []map[string]string
	for rows.Next() {
		var iType, iID string
		if err := rows.Scan(&iType, &iID); err == nil {
			items = append(items, map[string]string{
				"type": iType,
				"id":   iID,
			})
		}
	}
	c.JSON(http.StatusOK, gin.H{"items": items})
}

func EquipItem(c *gin.Context) {
	var req models.EquipRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	var field string
	switch req.Type {
	case "skin":
		field = "equipped_skin"
	case "hair":
		field = "equipped_hair"
	case "face":
		field = "equipped_face"
	default:
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid item type"})
		return
	}

	// Safe update because field is controlled
	query := "UPDATE users SET " + field + " = $1 WHERE id = $2"
	_, err := config.DB.Exec(query, req.ItemID, req.UserID)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Equipped successfully"})
}
