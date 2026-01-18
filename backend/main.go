package main

import (
	"backend/config"
	"backend/routes"
	"log"
	"os"

	_ "github.com/lib/pq"
)

func main() {
	// 1. Config Database
	config.InitDB()

	// 2. Auto-Migrate Tables
	config.CreateTables()

	// 3. Seed Database (Create default user if empty)
	config.SeedDatabase()

	// 4. Router
	r := routes.SetupRouter()

	// 5. Run
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	log.Println("🚀 Server is running on port " + port)
	r.Run(":" + port)
}
