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
		connStr = "postgresql://postgres:password123@localhost:5432/kidzkanklai?sslmode=disable"
		log.Println("⚠️ Warning: Using default connection string.")
	}

	DB, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal("❌ Database connection failed:", err)
	}

	if err = DB.Ping(); err != nil {
		log.Println("⚠️ Could not ping database:", err)
	} else {
		log.Println("✅ Connected to Database!")
	}
}

func CreateTables() {
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
	_, err := DB.Exec(query)
	if err != nil {
		log.Println("⚠️ Migration failed:", err)
	} else {
		log.Println("✅ Database tables checked/created.")
	}
}

func SeedDatabase() {
	var count int
	err := DB.QueryRow("SELECT COUNT(*) FROM users").Scan(&count)
	if err != nil {
		log.Println("⚠️ Error checking users:", err)
		return
	}

	if count == 0 {
		log.Println("🌱 Seeding database with default user...")
		_, err = DB.Exec(`
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
