# Made by Xavier Alvarez. A part of the "Expo Icons" Godot addon. @2025
@tool
class_name ProFreeIcons extends IconBase
## The base abstract class for all ProFreeIcon nodes

#region Enums
enum ICON_STATE {
	Free,
	Pro
}
#endregion


#region External Variables
## The state that determines what [FontFile] and meta the icon uses
##
## See [enum ICON_STATE].
@export var icon_state : ICON_STATE:
	get:
		return _icon_state
	set(state):
		_icon_state = state
		var glyphs := _get_glyphs()
		var glyph_index = glyphs.keys().find(_current_icon)
		if glyph_index == -1:
			var defaultIcon := get_default_icon()
			_current_icon = defaultIcon
			_icon_name = defaultIcon
			_icon_glyph = glyphs.keys().find(defaultIcon)
		else:
			_icon_glyph = glyph_index
		notify_property_list_changed()
		queue_redraw()
#endregion


#region Private Variables
var _icon_state : ICON_STATE = ICON_STATE.Free
#endregion


# Made by Xavier Alvarez. A part of the "Expo Icons" Godot addon. @2025
