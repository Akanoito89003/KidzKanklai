package routes

import (
	"backend/handlers"

	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
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
	r.POST("/register", handlers.RegisterUser)
	r.POST("/login", handlers.LoginUser)
	r.GET("/me/:id", handlers.GetUserProfile)
	r.POST("/me/update", handlers.UpdateUserProfile)
	r.GET("/inventory/:id", handlers.GetUserInventory)
	r.POST("/equip-item", handlers.EquipItem)

	// Task routes placeholders (Inline handlers can stay or move, let's keep inline for simplicity or move if needed.
	// The user asked to separate, let's keep them here for now as they are trivial)
	r.POST("/tasks/start", func(c *gin.Context) {
		c.JSON(200, gin.H{"message": "Task started"})
	})
	r.POST("/tasks/complete", func(c *gin.Context) {
		c.JSON(200, gin.H{"message": "Task completed", "reward": 100})
	})

	return r
}
