tool
extends Label
class_name LabelEx
# Label supporting various font styles

const FONT_STYLES = [
	"font_title_capitalize",
	"font_title_capitalize_inline",
	"font_small", # "font" in Label theme settings
	"font_medium",
	"font_large",
	"font_small_bold",
	"font_medium_bold",
	"font_large_bold",
	"font_small_italic",
	"font_medium_italic",
	"font_large_italic",
	"font_small_bold_italic",
	"font_medium_bold_italic",
	"font_large_bold_italic",
]

enum FontStyle {
	TITLE_CAPITALIZE,
	TITLE_CAPITALIZE_INLINE,
	SMALL,
	MEDIUM,
	LARGE,
	SMALL_BOLD,
	MEDIUM_BOLD,
	LARGE_BOLD,
	SMALL_ITALIC,
	MEDIUM_ITALIC,
	LARGE_ITALIC,
	SMALL_BOLD_ITALIC,
	MEDIUM_BOLD_ITALIC,
	LARGE_BOLD_ITALIC
}

export(FontStyle) var font_style := FontStyle.SMALL setget set_font_style

func set_font_style(new_font_style: int) -> void:
	font_style = new_font_style

	add_font_override("font", theme.get_font(FONT_STYLES[font_style], "Label"))

	property_list_changed_notify()
