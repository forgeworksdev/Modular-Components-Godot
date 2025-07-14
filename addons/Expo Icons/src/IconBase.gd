# Made by Xavier Alvarez. A part of the "Expo Icons" Godot addon. @2025
@tool
class_name IconBase extends Control
## The base abstract class for all icon nodes

#region Constants
const FONT_FOLDER := "res://addons/Expo Icons/assets/fonts/"
const GLYPHMAPS_FOLDER := "res://addons/Expo Icons/assets/glyphmaps/"

const DEFAULT_COLOR := Color.WHITE ## Default Color for Icons
const DEFAULT_ICON_SIZE := 16 ## Default font size for Icons
#endregion


#region External Variables
## Font size of the Icon's Glyphs
var icon_size : int:
	get:
		return _icon_size
	set(val):
		_icon_size = max(1, val)
		queue_redraw()
## Color of the Icon
var icon_color : Color = DEFAULT_COLOR:
	set(val):
		icon_color = val
		queue_redraw()

## String of the icon
var icon_name : String:
	get: return _icon_name
	set(val):
		var glyphs := _get_glyphs()
		if glyphs.keys().has(val):
			_current_icon = val
			_icon_glyph = glyphs.keys().find(val)
		_icon_name = val
		queue_redraw()

## Glyph Index of the icon
var icon_glyph : int:
	get: return _icon_glyph
	set(val):
		var glyphs := _get_glyphs()
		if glyphs.size() > val:
			_icon_glyph = val
			_icon_name = glyphs.keys()[val]
			_current_icon = _icon_name
			queue_redraw()

## Horizontally centers the icon, within the [member size], proportional to this value
var icon_align_horizontal : float = 0.5:
	set(val):
		icon_align_horizontal = val
		queue_redraw()
## Vertically centers the icon, within the [member size], proportional to this value
var icon_align_vertical : float = 0.5:
	set(val):
		icon_align_vertical = val
		queue_redraw()

## Horizontal padding for the Icon
var icon_padding_horizontal : float = 0:
	set(val):
		icon_padding_horizontal = val
		queue_redraw()
## Vertical padding for the Icon
var icon_padding_vertical : float = 0:
	set(val):
		icon_padding_vertical = val
		queue_redraw()
#endregion


#region Private Variables
var _icon_size : int = DEFAULT_ICON_SIZE

var _current_icon : String
var _icon_name : String

var _icon_glyph : int

var _min_size : Vector2
#endregion


#region Static Methods
static func _load_json_file(filePath: String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("Error reading file")
	else:
		print("File doesn't exist")
#endregion


#region Private Virtual Methods
func _init() -> void:
	var glyphs := _get_glyphs()
	if _icon_name == "":
		var defaultIcon := get_default_icon()
		
		_current_icon = defaultIcon
		_icon_name = defaultIcon
		_icon_glyph = glyphs.keys().find(defaultIcon)
	else:
		_current_icon = _icon_name
		_icon_glyph = glyphs.keys().find(_icon_name)
func _get_minimum_size() -> Vector2:
	return _min_size

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	
	properties.append({
		"name" = "icon_name",
		"type" = TYPE_STRING,
		"usage" = PROPERTY_USAGE_DEFAULT
	})
	properties.append({
		"name": "icon_glyph",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": " ,".join(_get_glyphs().keys())
	})
	properties.push_back({
		"name": "icon_color",
		"type": TYPE_COLOR,
		"usage": PROPERTY_USAGE_DEFAULT
	})
	properties.push_back({
		"name": "icon_size",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT
	})
	
	properties.append({
		"name" = "Icon Center",
		"type" = TYPE_NIL,
		"usage" = PROPERTY_USAGE_GROUP,
		"hint_string" = "icon_align_"
	})
	properties.append({
		"name": "icon_align_horizontal",
		"type": TYPE_FLOAT,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,1,0.01,or_greater,or_less"
	})
	properties.append({
		"name": "icon_align_vertical",
		"type": TYPE_FLOAT,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,1,0.01,or_greater,or_less"
	})
	
	properties.append({
		"name" = "Icon Padding",
		"type" = TYPE_NIL,
		"usage" = PROPERTY_USAGE_GROUP,
		"hint_string" = "icon_padding_"
	})
	properties.append({
		"name": "icon_padding_horizontal",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT,
	})
	properties.append({
		"name": "icon_padding_vertical",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT,
	})
	
	return properties
func _property_can_revert(property: StringName) -> bool:
	if property in [
		&"icon_name",
		&"icon_size",
		&"icon_color",
		&"icon_align_horizontal",
		&"icon_align_vertical"
		]:
			return true
	
	match property:
		&"icon_padding_horizontal":
			return icon_padding_horizontal != 0
		&"icon_padding_vertical":
			return icon_padding_vertical != 0
	
	return false
func _property_get_revert(property: StringName) -> Variant:
	match property:
		&"icon_name":
			return get_default_icon()
		&"icon_size":
			return DEFAULT_ICON_SIZE
		&"icon_color":
			return DEFAULT_COLOR
		&"icon_align_horizontal", &"icon_align_vertical":
			return 0.5
		&"icon_padding_horizontal", &"icon_padding_vertical":
			return 0
	return null
func _draw() -> void:
	_draw_icon(get_fontFile(), get_glyph_by_name(_icon_name))
#endregion


#region Custom Abstract Methods
## An abstract method meant to be overridden.
##
## Should be used to load all the needed data for the icon. [FontFile]s, Glyphmaps, etc.
## It is reacomended to use threaded loading.
##
## [b]NOTE[/b]: This will only be called once, when needed, throughout the whole game.
static func _load_data() -> void:
	push_warning("Method 'load_data()' not implemented in abstract class")

## An abstract method meant to be overridden.
##
## Should return the string name of the icon this node should have upon creation
static func get_default_icon() -> String:
	push_warning("Method 'get_default_icon()' not implemented in abstract class")
	return ""

## An abstract method meant to be overridden.
##
## Returns the current FontFile in use.
##
## See [constant fontFile]
func _get_glyphs() -> Dictionary:
	push_warning("Method '_get_glyphs()' not implemented in abstract class")
	return {}

## An abstract method meant to be overridden.
##
## Returns the current FontFile in use.
##
## See [constant fontFile]
func get_fontFile() -> FontFile:
	push_warning("Method 'get_fontFile()' not implemented in abstract class")
	return null
#endregion


#region Private Methods
func _get_icon_pos(glyph_size : Vector2) -> Vector2:
	return (size - glyph_size) * Vector2(icon_align_horizontal, icon_align_vertical)
func _get_glyph_info(icon_size : int, fontFile: Font, glyph_selected: int) -> Dictionary:
	var textline : TextLine = TextLine.new()
	textline.add_string(char(glyph_selected), fontFile, icon_size)
	var rid : RID = textline.get_rid()
	var text_server : TextServer = TextServerManager.get_primary_interface()
	var glyph : Dictionary = text_server.shaped_text_get_glyphs(rid)[0]
	
	var font_rid : RID = glyph.get('font_rid', RID())
	var glyph_font_size : Vector2i = Vector2i(glyph.get('font_size', 8), 0)
	var glyph_index : int = glyph.get('index', -1)
	
	var ret : Dictionary
	ret["font_size"] = glyph_font_size
	ret["glyph_offset"] = text_server.font_get_glyph_offset(font_rid, glyph_font_size, glyph_index)
	ret["glyph_size"] = text_server.font_get_glyph_size(font_rid, glyph_font_size, glyph_index)
	
	return ret
func _update_min_size(glyph_size : Vector2) -> Vector2:
	var min_temp : Vector2 = glyph_size + Vector2(icon_padding_horizontal, icon_padding_vertical)
	if min_temp == _min_size: return min_temp
	_min_size = min_temp
	
	update_minimum_size()
	return min_temp


## Draws the Icon repersented by the [param fontFile] and [param glyphIndex].
## This will automatically handle the resizing, recoloing, and font size provided.
##
## If you wish to make your own icon, call this in a method overload of [method CanvasItem._draw]
func _draw_icon(fontFile : FontFile, glyphIndex : int) -> void:
	if fontFile == null:
		return
	
	var ci = get_canvas_item()
	if glyphIndex == -1 || !fontFile.has_char(glyphIndex):
		_update_min_size(_get_glyph_info(_icon_size, fontFile, 65).glyph_size)
		draw_rect(Rect2(Vector2.ZERO, _min_size), Color.WHITE, false)
		return
	
	var glyph_info := _get_glyph_info(_icon_size, fontFile, glyphIndex)
	_update_min_size(glyph_info.glyph_size)
	fontFile.draw_char(ci, _get_icon_pos(glyph_info.glyph_size) - glyph_info.glyph_offset, glyphIndex, _icon_size, modulate * icon_color)
#endregion


#region Public Methods
## When given an string [param icon_name], return the corresponding glyph index.
## Returns -1 if icon cannot be found within the curren glyphs.
func get_glyph_by_name(icon_name: String) -> int:
	var glyphs := _get_glyphs()
	if glyphs.has(icon_name):
		return glyphs[icon_name]
	return -1
#endregion

# Made by Xavier Alvarez. A part of the "Expo Icons" Godot addon. @2025
