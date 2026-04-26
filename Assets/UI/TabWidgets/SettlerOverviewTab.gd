extends VBoxContainer

@onready var caption_block:CaptionBlock = $CaptionBlock
@onready var taxes_control: TaxesControl = %TaxesControl
@onready var happiness_slider: HSlider = %HappinessSlider
@onready var residents_count_label: Label = %ResidentsCountLabel

var selected_node: WorldThing2D = null:
	set(value):
		selected_node = value

func _ready():
	self.taxes_control.tax_rate_changed.connect(self.on_tax_rate_changed)

func refresh_tab(): # called by AllTabs.gd
	# print("SettlerOverviewTab.refresh_tab (%s)" % [self.name])
	var residential: Residential = self.selected_node as Residential
	if residential != null:
		self.taxes_control.paid_taxes = residential.calculate_tax_revenue_per_second()
		self.taxes_control.tax_rate = GameStats.treasury.tax_rate_per_tier.get(residential.current_tier_val, 1.0)

		self.happiness_slider.value = residential.get_happiness()

		self.residents_count_label.text = str(residential.residents_count) + " / " + str(residential.max_residents_for_current_tier)

	for child in self.get_children():
		if "selected_node" in child:
			child.selected_node = self.selected_node

func on_tax_rate_changed(tax_rate: float):
	var residential: Residential = self.selected_node as Residential
	if residential != null:
		GameStats.treasury.tax_rate_per_tier[residential.current_tier_val] = tax_rate
