extends Object

class_name WorldTiers

enum TierEnum {
	MIN       = -2,
	NATURE    = -1,
	SAILORS   = 0,
	PIONEERS  = 1,
	SETTLERS  = 2,
	CITIZENS  = 3,
	MERCHANTS = 4,
	MAX       = 5
}

const Tiers: Dictionary [StringName, StringName] = {
	MIN       = &"MIN",
	NATURE    = &"NATURE",
	SAILORS   = &"SAILORS",
	PIONEERS  = &"PIONEERS",
	SETTLERS  = &"SETTLERS",
	CITIZENS  = &"CITIZENS",
	MERCHANTS = &"MERCHANTS",
	MAX       = &"MAX"
}
