package config

import (
	"context"
	"log"
	"os"

	"github.com/jackc/pgx/v5"
	"github.com/joho/godotenv"
)

var DB *pgx.Conn

// [CHANGE] เปลี่ยนจาก Secret เป็น ProjectRef แทน
var SupabaseProjectRef string 

func ConnectDB() {
	// 1. โหลด .env
	err := godotenv.Load()
	if err != nil {
		log.Println("Warning: No .env file found")
	}

	// 2. โหลด Database URL
	databaseURL := os.Getenv("DATABASE_URL")
	if databaseURL == "" {
		log.Fatal("DATABASE_URL is not set")
	}

	// 3. [CHANGE] โหลด Project Ref (รหัสโปรเจกต์) แทน Secret
	SupabaseProjectRef = os.Getenv("SUPABASE_PROJECT_REF")
	if SupabaseProjectRef == "" {
		log.Fatal("SUPABASE_PROJECT_REF is not set")
	}

	// 4. เชื่อมต่อฐานข้อมูล
	DB, err = pgx.Connect(context.Background(), databaseURL)
	if err != nil {
		log.Fatal("DB connection failed:", err)
	}

	log.Println("✅ Connected to Supabase DB")
}