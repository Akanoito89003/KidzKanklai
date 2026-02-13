package handlers

import (
	"fmt"
	"log"
	"net/http"
	"strings"
	"time"
	"backend/config"

	"github.com/MicahParks/keyfunc/v2"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

// ตัวแปรเก็บ Keyfunc (แม่กุญแจ) ไว้ใน Memory
var jwks *keyfunc.JWKS

// ฟังก์ชันนี้ต้องถูกเรียก 1 ครั้งตอนเริ่มโปรแกรม (ใน main.go)
func InitAuth() {

	// ดึงจาก config ที่เราโหลดไว้แล้ว
    projectRef := config.SupabaseProjectRef

	if projectRef == "" {
		// ถ้าขี้เกียจแก้ .env บ่อยๆ ใส่รหัส Project ตรงนี้ได้เลย (เช่น "abcdefghijklm")
		log.Fatal("❌ Error: SUPABASE_PROJECT_REF is missing in .env") 
	}

	// 2. สร้าง URL ของ JWKS (กุญแจสาธารณะของ Supabase)
	jwksURL := fmt.Sprintf("https://%s.supabase.co/auth/v1/.well-known/jwks.json", projectRef)

	// 3. โหลด Key มาเก็บไว้ (พร้อมระบบ Refresh อัตโนมัติ)
	var err error
	options := keyfunc.Options{
		RefreshErrorHandler: func(err error) {
			log.Printf("⚠️ Error refreshing JWKS: %v", err)
		},
		RefreshInterval:   time.Hour, // เช็ค Key ใหม่ทุก 1 ชั่วโมง
		RefreshRateLimit:  time.Minute * 5,
		RefreshTimeout:    time.Second * 10,
	}

	jwks, err = keyfunc.Get(jwksURL, options)
	if err != nil {
		log.Fatalf("❌ Failed to create JWKS from resource at '%s': %v", jwksURL, err)
	}
	
	log.Println("✅ Auth System Initialized (JWKS Loaded)")
}

// Middleware สำหรับดักจับ Request
func AuthMiddleware(c *gin.Context) {
	// 1. ดึง Header
	authHeader := c.GetHeader("Authorization")
	if authHeader == "" {
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Authorization header is required"})
		return
	}

	// 2. ตัดคำว่า Bearer
	tokenStr := strings.Replace(authHeader, "Bearer ", "", 1)

	// 3. ตรวจสอบ Token (พระเอกของเราคือ jwks.Keyfunc)
	token, err := jwt.Parse(tokenStr, jwks.Keyfunc)

	// 4. เช็คผลลัพธ์
	if err != nil || !token.Valid {
		// ปริ้นท์ Error ให้เห็นชัดๆ (ช่วย Debug)
		fmt.Printf("❌ Token Error: %v\n", err)
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Invalid or expired token"})
		return
	}

	// 5. ดึงข้อมูล User (Claims)
	if claims, ok := token.Claims.(jwt.MapClaims); ok {
		// ดึง User ID
		if sub, ok := claims["sub"].(string); ok {
			c.Set("user_id", sub)
		}
		
		// ดึง Email
		if email, ok := claims["email"].(string); ok {
			c.Set("email", email)
		}
		
		c.Next() // ผ่าน!
	} else {
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Invalid token claims"})
	}
}

// API Test (เหมือนเดิม)
func Me(c *gin.Context) {
	uid, _ := c.Get("user_id")
	email, _ := c.Get("email")
	c.JSON(http.StatusOK, gin.H{
		"id":    uid,
		"email": email,
		"status": "Authenticated via JWKS 🚀",
	})
}