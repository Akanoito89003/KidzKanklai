package models

// Table: items
type Item struct {
	ID          int64   `json:"id"`
	Name        string  `json:"name"`
	Description *string `json:"description"`
	Image       *string `json:"image"`
	Rarity      *string `json:"rarity"`
	CategoryID  *int64  `json:"category_id"` // FK
}

// Table: categories
type Category struct {
	ID          int64   `json:"id"`
	Name        string  `json:"name"`
	Description *string `json:"description"`
}