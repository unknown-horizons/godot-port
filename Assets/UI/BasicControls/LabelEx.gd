@tool
extends Label
class_name LabelEx

## Label supporting various font styles.

const FONT_STYLES = [
	"font_small_capitalized",
	"font_medium_capitalized",
	"font_large_capitalized",
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
	TITLE_SMALL_CAPITALIZED,
	TITLE_MEDIUM_CAPITALIZED,
	TITLE_LARGE_CAPITALIZED,
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

@export var font_style: FontStyle = FontStyle.SMALL:
	set(new_font_style):
		font_style = new_font_style

		if FONT_STYLES[font_style] != "font_small":
			var selected_style := FONT_STYLES[font_style] as String

			var font := "font"
			if selected_style.contains("bold"):
				font += "_bold"
			if selected_style.contains("italic"):
				font += "_italic"
			if selected_style.contains("capitalized"):
				font += "_capitalized"
			add_theme_font_override("font", load(ProjectSettings.get("gui/theme/custom")).get_font(font, "Label"))

			var font_size := "font_size"
			if selected_style.contains("medium"):
				font_size += "_medium"
			elif selected_style.contains("large"):
				font_size += "_large"
			add_theme_font_size_override("font_size", load(ProjectSettings.get("gui/theme/custom")).get_font_size(font_size, "Label"))
		else:
			remove_theme_font_override("font")
			remove_theme_font_size_override("font_size")

		notify_property_list_changed()
