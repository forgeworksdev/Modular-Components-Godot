# Made by Xavier Alvarez. A part of the "Expo Icons" Godot addon. @2025
@tool
class_name Fontisto extends IconBase
## The node for all icons located in the Fontisto [FontFile]

#region Constants
const DEFAULT_ICON : String = "person" ## Default Icon
const FONT_FILE : FontFile = preload(FONT_FOLDER + "Fontisto.ttf") ## Used [FontFile]
const GLYPHS : Dictionary = preload(GLYPHMAPS_FOLDER + "Fontisto.json").data ## Used glyphs
#endregion


#region Static Methods
## When given an string [member icon_name], return the corresponding glyph index.
## Returns -1 if icon cannot be found within the curren glyphs
static func get_default_icon() -> String:
	return DEFAULT_ICON
#endregion


#region Public Methods
## Returns the current FontFile in use.
## [br][br]
## See [constant FONT_FILE]
func get_fontFile() -> FontFile:
	return FONT_FILE
func _get_glyphs() -> Dictionary:
	return GLYPHS
#endregion

# Made by Xavier Alvarez. A part of the "Expo Icons" Godot addon. @2025
