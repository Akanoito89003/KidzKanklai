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
