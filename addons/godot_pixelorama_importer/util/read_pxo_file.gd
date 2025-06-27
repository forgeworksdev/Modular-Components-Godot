extends Node

const Result = preload("./Result.gd")


static func read_pxo_file(source_file: String, image_save_path: String) -> Result:
	var content_result := read_pxo_zip_file(source_file, image_save_path)
	if content_result.error != OK:
		content_result = read_pxo_v0_file(source_file, image_save_path)

	return content_result


static func adjust_opacity(image: Image, opacity: float):
	var size := image.get_size()
	for x in range(size.x):
		for y in range(size.y):
			var color := image.get_pixel(x, y)
			color.a *= opacity
			image.set_pixel(x, y, color)


static func read_pxo_zip_file(source_file: String, image_save_path: String) -> Result:
	var result := Result.new()
	result.error = OK

	var reader := ZIPReader.new()
	var open_err := reader.open(source_file)

	if open_err != OK:
		result.error = open_err
		return result

	var raw_data_json := reader.read_file("data.json").get_string_from_utf8()
	var json_parser := JSON.new()

	var parse_error := json_parser.parse(raw_data_json)
	if parse_error != OK:
		printerr("pixelorama_importer - JSON Parse Error")
		result.error = json_parser.get_error_message()
		return result

	var data := json_parser.get_data()

	var size = Vector2(data.size_x, data.size_y)
	var frame_count = data.frames.size()

	var spritesheet = Image.create(size.x * frame_count, size.y, false, Image.FORMAT_RGBA8)

	for frame_index in range(frame_count):
		var frame = data.frames[frame_index]
		var frame_image: Image = null

		for cel_index in range(frame.cels.size()):
			var cel = frame.cels[cel_index]
			var layer = data.layers[cel_index]
			var opacity: float = layer.opacity

			# Making sure that layer is a pixel layer
			if cel.get("type", 0) != 0:
				continue

			var is_visible: bool = layer.visible and opacity > 0.0
			if !is_visible:
				continue

			var image_path := "image_data/frames/%s/layer_%s" % [frame_index + 1, cel_index + 1]
			var layer_raw_data := reader.read_file(image_path)
			var layer_image := Image.create_from_data(
				size.x, size.y, false, Image.FORMAT_RGBA8, layer_raw_data
			)

			if opacity < 1.0:
				adjust_opacity(layer_image, opacity)

			if frame_image:
				# Overlay each Cel on top of each other
				frame_image.blend_rect(layer_image, Rect2(Vector2.ZERO, size), Vector2.ZERO)
			else:
				frame_image = layer_image

		if frame_image:
			# Add to the spritesheet
			spritesheet.blit_rect(
				frame_image, Rect2(Vector2.ZERO, size), Vector2(size.x * frame_index, 0)
			)

	save_ctex(spritesheet, image_save_path)

	result.value = data
	return result


static func read_pxo_v0_file(source_file: String, image_save_path: String) -> Result:
	var result = Result.new()
	result.error = OK

	# Open the Pixelorama project file
	var file := FileAccess.open_compressed(
		source_file, FileAccess.READ, FileAccess.COMPRESSION_ZSTD
	)
	if FileAccess.get_open_error() != OK:
		file = FileAccess.open(source_file, FileAccess.READ)

	# Parse it as JSON
	var text = file.get_line()
	var test_json_conv = JSON.new()
	var json_error = test_json_conv.parse(text)

	if json_error != OK:
		printerr("pixelorama_importer - JSON Parse Error")
		result.error = json_error
		return result

	var project = test_json_conv.get_data()

	# Make sure it's a JSON Object
	if typeof(project) != TYPE_DICTIONARY:
		printerr("pixelorama_importer - Invalid Pixelorama project file")
		result.error = ERR_FILE_UNRECOGNIZED
		return result

	# Load the cel dimensions and frame count
	var size = Vector2(project.size_x, project.size_y)
	var frame_count = project.frames.size()

	# Prepare the spritesheet image
	var spritesheet = Image.create(size.x * frame_count, size.y, false, Image.FORMAT_RGBA8)

	var cel_data_size: int = size.x * size.y * 4

	for i in range(frame_count):
		var frame = project.frames[i]

		# Prepare the frame image
		var frame_img: Image = null
		var layer := 0
		for cel in frame.cels:
			var opacity: float = cel.opacity

			if project.layers[layer].visible and opacity > 0.0:
				# Load the cel image
				var cel_img = Image.create_from_data(
					size.x, size.y, false, Image.FORMAT_RGBA8, file.get_buffer(cel_data_size)
				)

				if opacity < 1.0:
					adjust_opacity(cel_img, opacity)

				if frame_img == null:
					frame_img = cel_img
				else:
					# Overlay each Cel on top of each other
					frame_img.blend_rect(cel_img, Rect2(Vector2.ZERO, size), Vector2.ZERO)
			else:
				# Skip this cel's data
				file.seek(file.get_position() + cel_data_size)

			layer += 1

		if frame_img != null:
			# Add to the spritesheet
			spritesheet.blit_rect(frame_img, Rect2(Vector2.ZERO, size), Vector2(size.x * i, 0))

	save_ctex(spritesheet, image_save_path)
	result.value = project

	return result


# Based on CompressedTexture2D::_load_data from
# https://github.com/godotengine/godot/blob/master/scene/resources/texture.cpp
static func save_ctex(image, save_path: String):
	var tmpwebp = "%s-tmp.webp" % [save_path]
	image.save_webp(tmpwebp)  # not quite sure, but the png import that I tested was in webp

	var webpf = FileAccess.open(tmpwebp, FileAccess.READ)
	var webplen = webpf.get_length()
	var webpdata = webpf.get_buffer(webplen)
	webpf = null  # setting null will close the file

	var dir := DirAccess.open(tmpwebp.get_base_dir())
	dir.remove(tmpwebp.get_file())

	var ctexf = FileAccess.open("%s.ctex" % [save_path], FileAccess.WRITE)
	ctexf.store_8(0x47)  # G
	ctexf.store_8(0x53)  # S
	ctexf.store_8(0x54)  # T
	ctexf.store_8(0x32)  # 2
	ctexf.store_32(0x01)  # FORMAT_VERSION
	ctexf.store_32(image.get_width())
	ctexf.store_32(image.get_height())
	ctexf.store_32(0xD000000)  # data format (?)
	ctexf.store_32(0xFFFFFFFF)  # mipmap_limit
	ctexf.store_32(0x0)  # reserved
	ctexf.store_32(0x0)  # reserved
	ctexf.store_32(0x0)  # reserved
	ctexf.store_32(0x02)  # data format (WEBP, it's DataFormat enum but not available in gdscript)
	ctexf.store_16(image.get_width())  # w
	ctexf.store_16(image.get_height())  # h
	ctexf.store_32(0x00)  # mipmaps
	ctexf.store_32(Image.FORMAT_RGBA8)  # format
	ctexf.store_32(webplen)  # webp length
	ctexf.store_buffer(webpdata)
	ctexf = null  # setting null will close the file

	print("ctex saved")

	return OK
