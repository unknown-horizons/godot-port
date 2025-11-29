extends VBoxContainer

class_name TaxesControl

@onready var paid_taxes_label:Label = $HBoxContainer/PaidTaxesLabel
@onready var tax_rate_label:Label = $HBoxContainer/TaxRateLabel
@onready var tax_rate_slider: HSlider = $TaxRateSlider

var paid_taxes: float = 0.0:
  set(value):
    paid_taxes = value
    self.paid_taxes_label.text = str(paid_taxes)
    
var tax_rate: float = 0.0:
  set(value):
    tax_rate = value
    var tax_rate_str = str(tax_rate)
    self.tax_rate_label.text = tax_rate_str
    tax_rate_slider.value = tax_rate

signal tax_rate_changed(tax_rate: float)

func _on_TaxRateSlider_value_changed(value: float) -> void:
  tax_rate = value
  self.tax_rate_changed.emit(tax_rate)
