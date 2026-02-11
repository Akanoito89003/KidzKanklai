package main

import (
	"backend/config"
	"backend/handlers" // import handlers เข้ามา
	"github.com/gin-gonic/gin"
)

func main() {
	config.ConnectDB()

	// ✅ [เพิ่มบรรทัดนี้] เริ่มระบบ Auth โหลด Key จาก Supabase
	handlers.InitAuth() 

	r := gin.Default()

	auth := r.Group("/")
	auth.Use(handlers.AuthMiddleware)
	auth.GET("/me", handlers.Me)

	r.Run(":8080")
}