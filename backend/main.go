package main

import (
	"database/sql"
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
)

// --- Models ---

type User struct {
	ID             int    `json:"id"`
	Username       string `json:"username"`
	Email          string `json:"email"`
	Password       string `json:"password"` // In real app, hash this!
	Level          int    `json:"level"`
	Exp            int    `json:"exp"`
	Coins          int    `json:"coins"`
	Tickets        int    `json:"tickets"`
	Vouchers       int    `json:"vouchers"`
	Bio            string `json:"bio"`
	SoundBGM       int    `json:"sound_bgm"` // 0-100
	SoundSFX       int    `json:"sound_sfx"` // 0-100
	EquippedSkin   string `json:"equipped_skin"`
	EquippedHair   string `json:"equipped_hair"`
	EquippedFace   string `json:"equipped_face"`
	StatIntellect  int    `json:"stat_intellect"`
	StatStrength   int    `json:"stat_strength"`
	StatCreativity int    `json:"stat_creativity"`
}

type LoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type UpdateProfileRequest struct {
	ID       int    `json:"id"`
	Bio      string `json:"bio"`
	SoundBGM int    `json:"sound_bgm"`
	SoundSFX int    `json:"sound_sfx"`
}

type Item struct {
	ID       int    `json:"id"`
	Name     string `json:"name"`
	Type     string `json:"type"` // skin, hair, face
	ImageURL string `json:"image_url"`
}

type EquipRequest struct {
	UserID int    `json:"user_id"`
	Type   string `json:"type"`    // skin, hair, face
	ItemID string `json:"item_id"` // Using string for flexibility with your asset names
}

// --- Database ---
var db *sql.DB

func main() {
	// 1. Config Database
	connStr := os.Getenv("DATABASE_URL")
	if connStr == "" {
		// Default to the previous Supabase URL for convenience (User can change this)
		connStr = "postgresql://postgres.cwwksrwalgbiakvsvngj:KidzKanklai_3K@aws-1-us-east-2.pooler.supabase.com:6543/postgres"
		log.Println("⚠️ Warning: Using default connection string.")
	}

	var err error
	db, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal("❌ Database connection failed:", err)
	}
	defer db.Close()

	if err = db.Ping(); err != nil {
		log.Println("⚠️ Could not ping database:", err)
	} else {
		log.Println("✅ Connected to Database!")
	}

	// 2. Auto-Migrate Tables
	createTables()

	// 3. Seed Database (Create default user if empty)
	seedDatabase()

	// 4. Router
	r := setupRouter()

	// 5. Run
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	log.Println("🚀 Server is running on port " + port)
	r.Run(":" + port)
}

func seedDatabase() {
	var count int
	err := db.QueryRow("SELECT COUNT(*) FROM users").Scan(&count)
	if err != nil {
		log.Println("⚠️ Error checking users:", err)
		return
	}

	if count == 0 {
		log.Println("🌱 Seeding database with default user...")
		_, err = db.Exec(`
			INSERT INTO users (username, email, password, level, coins, exp, tickets, vouchers, equipped_skin, equipped_hair, equipped_face) 
			VALUES ('Tester', 'test@example.com', 'password123', 5, 1000, 500, 10, 5, 'basic_uniform', 'default_blue', 'happy')
		`)
		if err != nil {
			log.Println("❌ Failed to seed user:", err)
		} else {
			log.Println("✅ Default user created: test@example.com / password123")
		}
	}
}

func createTables() {
	query := `
	CREATE TABLE IF NOT EXISTS users (
		id SERIAL PRIMARY KEY,
		username TEXT NOT NULL,
		email TEXT UNIQUE NOT NULL,
		password TEXT NOT NULL,
		level INT DEFAULT 1,
		exp INT DEFAULT 0,
		coins INT DEFAULT 0,
		tickets INT DEFAULT 0,
		vouchers INT DEFAULT 0,
		bio TEXT DEFAULT '',
		sound_bgm INT DEFAULT 70,
		sound_sfx INT DEFAULT 70,
		equipped_skin TEXT DEFAULT 'basic_uniform',
		equipped_hair TEXT DEFAULT 'default_blue',
		equipped_face TEXT DEFAULT 'happy',
		stat_intellect INT DEFAULT 0,
		stat_strength INT DEFAULT 0,
		stat_creativity INT DEFAULT 0
	);
	
	CREATE TABLE IF NOT EXISTS inventory (
		id SERIAL PRIMARY KEY,
		user_id INT NOT NULL,
		item_type TEXT NOT NULL,
		item_id TEXT NOT NULL
	);
	`
	_, err := db.Exec(query)
	if err != nil {
		log.Println("⚠️ Migration failed:", err)
	} else {
		log.Println("✅ Database tables checked/created.")
	}
}

func setupRouter() *gin.Engine {
	r := gin.Default()

	// CORS
	r.Use(func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	})

	// Routes
	r.POST("/register", registerUser)
	r.POST("/login", loginUser)
	r.GET("/me/:id", getUserProfile)
	r.POST("/me/update", updateUserProfile)
	r.GET("/inventory/:id", getUserInventory)
	r.POST("/equip", equipItem)

	// Task routes placeholders
	r.POST("/tasks/start", func(c *gin.Context) {
		c.JSON(200, gin.H{"message": "Task started"})
	})
	r.POST("/tasks/complete", func(c *gin.Context) {
		c.JSON(200, gin.H{"message": "Task completed", "reward": 100})
	})

	return r
}

// --- Handlers ---

func registerUser(c *gin.Context) {
	var u User
	if err := c.ShouldBindJSON(&u); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	// Simple insert
	err := db.QueryRow(
		"INSERT INTO users (username, email, password) VALUES ($1, $2, $3) RETURNING id",
		u.Username, u.Email, u.Password,
	).Scan(&u.ID)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Registration failed: " + err.Error()})
		return
	}

	c.JSON(http.StatusCreated, u)
}

func loginUser(c *gin.Context) {
	var req LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	var u User
	err := db.QueryRow(
		"SELECT id, username, email, level, coins FROM users WHERE email = $1 AND password = $2",
		req.Email, req.Password,
	).Scan(&u.ID, &u.Username, &u.Email, &u.Level, &u.Coins)

	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	c.JSON(http.StatusOK, u)
}

func getUserProfile(c *gin.Context) {
	id := c.Param("id")
	var u User
	err := db.QueryRow(`
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

func updateUserProfile(c *gin.Context) {
	var req UpdateProfileRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	_, err := db.Exec(
		"UPDATE users SET bio=$1, sound_bgm=$2, sound_sfx=$3 WHERE id=$4",
		req.Bio, req.SoundBGM, req.SoundSFX, req.ID,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Profile updated"})
}

func getUserInventory(c *gin.Context) {
	userID := c.Param("id")
	rows, err := db.Query("SELECT item_type, item_id FROM inventory WHERE user_id = $1", userID)
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

func equipItem(c *gin.Context) {
	var req EquipRequest
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
	_, err := db.Exec(query, req.ItemID, req.UserID)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Equipped successfully"})
}
