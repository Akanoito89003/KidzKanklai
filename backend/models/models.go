package models

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
	EquippedPose   int    `json:"equipped_pose"`
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

type InventoryItem struct {
	ID       int    `json:"id"`
	UserID   int    `json:"user_id"`
	ItemID   int    `json:"item_id"`
	Name     string `json:"name"`
	Image    string `json:"image"`
	Category string `json:"category"`
	RiveID   int    `json:"rive_id"`
}

type EquipRequest struct {
	UserID   int    `json:"user_id"`
	Category string `json:"category"` // hair, skin, face
	Name     string `json:"name"`     // Using Name to update the text field for now
}
