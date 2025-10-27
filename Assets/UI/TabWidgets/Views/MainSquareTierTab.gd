@tool

extends VBoxContainer

@export var tab_tier: StringName # WorldTiers.Tiers
var tab_tier_val: WorldTiers.TierEnum:
  get():
    return WorldTiers.TierEnum.get(self.tab_tier, WorldTiers.TierEnum.SAILORS)

@onready var caption_block: CaptionBlock = $CaptionBlock

@onready var taxes_control: TaxesControl = %TaxesControl

@onready var sad_houses_count_label = %SadHousesCount
@onready var satisfied_houses_count_label = %SatisfiedHousesCount
@onready var happy_houses_count_label = %HappyHousesCount

@onready var houses_count_label = %HousesCount
@onready var residents_count_label = %ResidentsCount

func _ready():
  self.caption_block.caption_text = str(self.tab_tier)

  self.taxes_control.tax_rate_changed.connect(func (tax_rate: float): GameStats.treasury.tax_rate_per_tier[self.tab_tier_val] = tax_rate)
  # self.visibility_changed.connect(func(): print("MainSquareTierTab Visibility changed %s" % [self.visible]))

var selected_node: WorldThing2D = null

func refresh_tab(): # called by AllTabs.gd
  # print("MainSquareTierTab.refresh_tab (%s)" % [self.tab_tier])
  var residence_nodes = self.get_tree().get_nodes_in_group("Residence")

  var houses_count = 0
  var residents_count = 0

  var sad_count = 0
  var satisfied_count = 0
  var happy_count = 0

  for residential_node in residence_nodes:
    var residence: Residential = residential_node as Residential
    if residence == null:
      continue
    if residence.current_tier != self.tab_tier: # filter by tier to account for
      continue
      
    houses_count += 1
    residents_count += residence.residence
    var happiness = 0
    for storage in residence.get_all_nodes_of_type(StorageComponent):
      happiness += storage.get_storage_item_amount(ResourceConfig.Resources.HAPPINESS)
    if happiness < 30:
      sad_count += 1
    elif happiness < 70:
      satisfied_count += 1
    else:
      happy_count += 1

  self.taxes_control.paid_taxes = 12345
  self.taxes_control.tax_rate = GameStats.treasury.tax_rate_per_tier.get(self.tab_tier_val, 1.0)

  self.sad_houses_count_label.text = str(sad_count)
  self.satisfied_houses_count_label.text = str(satisfied_count)
  self.happy_houses_count_label.text = str(happy_count)  

  self.houses_count_label.text = str(houses_count)
  self.residents_count_label.text = str(residents_count)
