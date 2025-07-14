@tool
extends EditorPlugin

const ICON_SCRIPT_FOLDER := "res://addons/Expo Icons/src/"
const ICON_ICON_FOLDER := "res://addons/Expo Icons/assets/icons/"

func _enter_tree() -> void:
	add_custom_type(
		"IconBase",
		"Control",
		load(ICON_SCRIPT_FOLDER + "IconBase.gd"),
		load(ICON_ICON_FOLDER + "IconBase.svg")
	)

	add_custom_type(
		"AntDesign",
		"Control",
		load(ICON_SCRIPT_FOLDER + "IconNodes/AntDesign.gd"),
		load(ICON_ICON_FOLDER + "AntDesign.svg")
	)
	add_custom_type(
		"Entypo",
		"Control",
		load(ICON_SCRIPT_FOLDER + "IconNodes/Entypo.gd"),
		load(ICON_ICON_FOLDER + "Entypo.svg")
	)
	add_custom_type(
		"EvilIcons",
		"Control",
		load(ICON_SCRIPT_FOLDER + "IconNodes/EvilIcons.gd"),
		load(ICON_ICON_FOLDER + "EvilIcons.svg")
	)
	add_custom_type(
		"Feather",
		"Control",
		load(ICON_SCRIPT_FOLDER + "IconNodes/Feather.gd"),
		load(ICON_ICON_FOLDER + "Feather.svg")
	)
	add_custom_type(
		"FontAwesome5",
		"Control",
		load(ICON_SCRIPT_FOLDER + "IconNodes/ProFreeIcons/FontAwesome5.gd"),
		load(ICON_ICON_FOLDER + "FontAwesome5.svg")
	)
	add_custom_type(
		"FontAwesome6",
		"Control",
		load(ICON_SCRIPT_FOLDER + "IconNodes/ProFreeIcons/FontAwesome6.gd"),
		load(ICON_ICON_FOLDER + "FontAwesome6.svg")
	)
	add_custom_type(
		"FontAwesome",
		"Control",
		load(ICON_SCRIPT_FOLDER + "IconNodes/FontAwesome.gd"),
		load(ICON_ICON_FOLDER + "FontAwesome.svg")
	)
	add_custom_type(
		"Fontisto",
		"Control",
		load(ICON_SCRIPT_FOLDER + "IconNodes/Fontisto.gd"),
		load(ICON_ICON_FOLDER + "Fontisto.svg")
	)
	add_custom_type(
		"Foundation",
		"Control",
		load(ICON_SCRIPT_FOLDER + "IconNodes/Foundation.gd"),
		load(ICON_ICON_FOLDER + "Foundation.svg")
	)
	add_custom_type(
		"Ionicons",
		"Control",
		load(ICON_SCRIPT_FOLDER + "IconNodes/Ionicons.gd"),
		load(ICON_ICON_FOLDER + "Ionicons.svg")
	)
	add_custom_type(
		"MaterialCommunityIcons",
		"Control",
		load(ICON_SCRIPT_FOLDER + "IconNodes/MaterialCommunityIcons.gd"),
		load(ICON_ICON_FOLDER + "MaterialCommunityIcons.svg")
	)
	add_custom_type(
		"MaterialIcons",
		"Control",
		load(ICON_SCRIPT_FOLDER + "IconNodes/MaterialIcons.gd"),
		load(ICON_ICON_FOLDER + "MaterialIcons.svg")
	)
	add_custom_type(
		"Octicons",
		"Control",
		load(ICON_SCRIPT_FOLDER + "IconNodes/Octicons.gd"),
		load(ICON_ICON_FOLDER + "Octicons.svg")
	)
	add_custom_type(
		"SimpleLineIcons",
		"Control",
		load(ICON_SCRIPT_FOLDER + "IconNodes/SimpleLineIcons.gd"),
		load(ICON_ICON_FOLDER + "SimpleLineIcons.svg")
	)
	add_custom_type(
		"Zocial",
		"Control",
		load(ICON_SCRIPT_FOLDER + "IconNodes/Zocial.gd"),
		load(ICON_ICON_FOLDER + "Zocial.svg")
	)

func _exit_tree() -> void:
	remove_custom_type("Zocial")
	remove_custom_type("SimpleLineIcons")
	remove_custom_type("Octicons")
	remove_custom_type("MaterialIcons")
	remove_custom_type("MaterialCommunityIcons")
	remove_custom_type("Foundation")
	remove_custom_type("Fontisto")
	remove_custom_type("FontAwesome")
	remove_custom_type("FontAwesome6")
	remove_custom_type("FontAwesome5")
	remove_custom_type("Feather")
	remove_custom_type("EvilIcons")
	remove_custom_type("Entypo")
	remove_custom_type("AntDesign")

	remove_custom_type("IconBase")
