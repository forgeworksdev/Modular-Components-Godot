# Made by Xavier Alvarez. A part of the "Expo Icons" Godot addon. @2025
@tool
class_name FontAwesome6 extends ProFreeIcons
## The node for all icons located in the FontAwesome6 [FontFile]s
##
## [b]NOTE[/b]: Some Icons are broken. This is due to a faulty meta file. I have no found a correct one on the internet yet.

#region Constants
const DEFAULT_ICON = "user" ## Default Icon
const FONT_FILES : Dictionary = {
			"brands": preload(FONT_FOLDER + "FontAwesome6_Brands.ttf"),
			"regular": preload(FONT_FOLDER + "FontAwesome6_Regular.ttf"),
			"solid": preload(FONT_FOLDER + "FontAwesome6_Solid.ttf"),
		} ## Used [FontFile]s
const GLYPHS : Dictionary = {
			ICON_STATE.Free: preload(
				GLYPHMAPS_FOLDER + "FontAwesome6Free.json"
			).data,
			ICON_STATE.Pro: preload(
				GLYPHMAPS_FOLDER + "FontAwesome6Pro.json"
			).data
		} ## Used glyphs
const METAS : Dictionary = {
			ICON_STATE.Free: preload(
				GLYPHMAPS_FOLDER + "FontAwesome6Free_meta.json"
			).data,
			ICON_STATE.Pro: preload(
				GLYPHMAPS_FOLDER + "FontAwesome6Pro_meta.json"
			).data
		} ## Used metadatas
#endregion


#region Static Methods
## When given an string [param icon_name], return the corresponding glyph index.
## Returns -1 if icon cannot be found within the curren glyphs
static func get_default_icon() -> String:
	return DEFAULT_ICON
#endregion


#region Private Methods
func _get_glyphs() -> Dictionary:
	if GLYPHS.has(_icon_state):
		return GLYPHS[_icon_state]
	return {}
#endregion


#region Public Methods
## Returns the current FontFile in use, based on the current [member icon_state] value.
func get_fontFile() -> FontFile:
	if METAS.has(_icon_state):
		var meta = METAS[_icon_state]
		for type : String in FONT_FILES.keys():
			if meta[type].has(_icon_name):
				return FONT_FILES[type]
	return null
#endregion

# Made by Xavier Alvarez. A part of the "Expo Icons" Godot addon. @2025
