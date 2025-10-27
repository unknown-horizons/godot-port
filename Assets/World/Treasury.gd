extends Resource

class_name Treasury

var tax_rate_per_tier: Dictionary[WorldTiers.TierEnum, float] = {
  WorldTiers.TierEnum.SAILORS: 1.0,
  WorldTiers.TierEnum.PIONEERS: 1.0,
  WorldTiers.TierEnum.SETTLERS: 1.0,
  WorldTiers.TierEnum.CITIZENS: 1.0,
  WorldTiers.TierEnum.MERCHANTS: 1.0,
}