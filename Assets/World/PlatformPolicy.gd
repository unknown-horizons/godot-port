class_name PlatformPolicy
extends RefCounted

## App Store and Google Play commonly reject builds that expose an in-game control to
## terminate the process (even without a confirmation). Do not ship Quit UI on phone OS.
static func should_hide_application_quit_controls() -> bool:
	var os_name: String = OS.get_name()
	if os_name == "iOS" or os_name == "Android":
		return true
	return OS.has_feature("mobile")
