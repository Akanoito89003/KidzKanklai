package config

import (
	"database/sql"
	"log"
	"os"

	_ "github.com/lib/pq"
)

var DB *sql.DB

func InitDB() {
	var err error
	connStr := os.Getenv("DATABASE_URL")
	if connStr == "" {
		// Default to the previous Supabase URL for convenience (User can change this)
		connStr = "postgresql://postgres:242526@localhost:5432/kidzkanklai?sslmode=disable"
		log.Println("[WARN] Warning: Using default connection string.")
	}

	DB, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal("[ERROR] Database connection failed:", err)
	}

	if err = DB.Ping(); err != nil {
		log.Println("[WARN] Could not ping database:", err)
	} else {
		log.Println("[INFO] Connected to Database!")
	}
}

func CreateTables() {
	// Drop for development schema fix
	DB.Exec("DROP TABLE IF EXISTS inventory CASCADE")
	DB.Exec("DROP TABLE IF EXISTS items CASCADE")

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
		stat_creativity INT DEFAULT 0,
		equipped_pose INT DEFAULT 0
	);
	
	CREATE TABLE IF NOT EXISTS items (
		id SERIAL PRIMARY KEY,
		name TEXT NOT NULL,
		image_path TEXT NOT NULL,
		category TEXT NOT NULL,
		rive_id INT DEFAULT 0
	);

	CREATE TABLE IF NOT EXISTS inventory (
		id SERIAL PRIMARY KEY,
		user_id INT NOT NULL,
		item_id INT NOT NULL,  -- Foreign Key to items.id
		obtained_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	);
	`
	_, err := DB.Exec(query)
	if err != nil {
		log.Println("[WARN] Migration failed:", err)
	} else {
		log.Println("[INFO] Database tables checked/created.")
	}
}

func SeedDatabase() {
	var count int
	err := DB.QueryRow("SELECT COUNT(*) FROM users").Scan(&count)
	if err != nil {
		log.Println("[WARN] Error checking users:", err)
		return
	}

	if count == 0 {
		log.Println("[INFO] Seeding database with default user...")
		_, err = DB.Exec(`
			INSERT INTO users (username, email, password, level, coins, exp, tickets, vouchers, equipped_skin, equipped_hair, equipped_face) 
			VALUES ('Tester', 'test@example.com', 'password123', 5, 1000, 500, 10, 5, 'basic_uniform', 'Hair Style 0', 'happy')
		`)
		if err != nil {
			log.Println("[ERROR] Failed to seed user:", err)
		} else {
			log.Println("[INFO] Default user created: test@example.com / password123")
		}
	} else {
		// Force update for existing user (during development debugging)
		log.Println("[INFO] ensuring Tester has Hair Style 0...")
		DB.Exec("UPDATE users SET equipped_hair = 'Hair Style 0' WHERE email = 'test@example.com'")
	}
}

func SeedInventory() {
	// 1. Seed Items Table First
	var itemCount int
	err := DB.QueryRow("SELECT COUNT(*) FROM items").Scan(&itemCount)
	if err == nil && itemCount == 0 {
		log.Println("[INFO] Seeding Items table...")
		items := []struct {
			Name, Image, Category string
			RiveID                int
		}{
			{"Hair Style 0", "assets/images/Fashion/HairStyle/hair00.PNG", "hair", 0},
			{"Hair Style 1", "assets/images/Fashion/HairStyle/hair01.PNG", "hair", 1},
			{"Hair Style 2", "assets/images/Fashion/HairStyle/hair02.PNG", "hair", 2},
			{"Default Skin", "skin_default.png", "skin", 0},
			{"Happy Face", "face_happy.png", "face", 0},
		}
		for _, item := range items {
			_, err := DB.Exec("INSERT INTO items (name, image_path, category, rive_id) VALUES ($1, $2, $3, $4)", item.Name, item.Image, item.Category, item.RiveID)
			if err != nil {
				log.Println("[ERROR] Failed to insert item:", item.Name, err)
			}
		}
	} else {
		// Force Update RiveIDs to ensure they match Rive Model (Fixing mismatch issues)
		log.Println("[INFO] Ensuring Hair Models have correct RiveIDs...")
		DB.Exec("UPDATE items SET rive_id = 0 WHERE name = 'Hair Style 0'")
		DB.Exec("UPDATE items SET rive_id = 1 WHERE name = 'Hair Style 1'")
		DB.Exec("UPDATE items SET rive_id = 2 WHERE name = 'Hair Style 2'")
	}

	// 2. Seed Inventory (Connect User to Items)
	var userID int
	err = DB.QueryRow("SELECT id FROM users WHERE email = 'test@example.com'").Scan(&userID)
	if err != nil {
		return
	}

	var localInvCount int
	DB.QueryRow("SELECT COUNT(*) FROM inventory WHERE user_id = $1", userID).Scan(&localInvCount)
	if localInvCount == 0 {
		log.Println("[INFO] Seeding Inventory for Tester...")
		// Give all items to tester
		rows, _ := DB.Query("SELECT id FROM items")
		defer rows.Close()
		var itemID int
		for rows.Next() {
			rows.Scan(&itemID)
			DB.Exec("INSERT INTO inventory (user_id, item_id) VALUES ($1, $2)", userID, itemID)
		}
		log.Println("[INFO] Inventory populated!")
	}
}
