extends SceneTree

var log_file = "exports/logs/export_log.txt"

func _init():
	var config = load_config("res://export_config.json")
	var output = config["output_dir"]
	var formats = config["formats"]

	log("🔮 Iniciando exportación de escenas...")
	var start_total = Time.get_unix_time_from_system()

	for scene_path in config["scenes"]:
		var start_time = Time.get_unix_time_from_system()
		log("🌀 Exportando escena: %s" % scene_path)
		var scene = load("res://" + scene_path).instantiate()
		get_root().add_child(scene)
		await get_tree().process_frame

		var base_name = scene_path.get_file().get_basename()

		if "png" in formats:
			export_png(scene, output + "png/" + base_name + ".png")
		if "glb" in formats:
			export_glb(scene, output + "glb/" + base_name + ".glb")

		var elapsed = Time.get_unix_time_from_system() - start_time
		log("✅ Escena %s exportada en %.2f s" % [base_name, elapsed])
		scene.queue_free()

	var total_elapsed = Time.get_unix_time_from_system() - start_total
	log("🎨 Exportación visual completa en %.2f s" % total_elapsed)
	convert_formats()
	quit()

func export_png(scene: Node, path: String):
	var image = get_viewport().get_texture().get_image()
	image.save_png(path)

func export_glb(scene: Node, path: String):
	var packed_scene = PackedScene.new()
	packed_scene.pack(scene)
	ResourceSaver.save(path, packed_scene)

func convert_formats():
	log("🔄 Convirtiendo PNG→TLV y GLB→SVG...")
	OS.execute("bash", ["-c", "for f in exports/png/*.png; do convert \"$f\" \"exports/tlv/$(basename \"${f%.png}\").tlv\"; done"], [])
	OS.execute("bash", ["-c", "for f in exports/glb/*.glb; do assimp export \"$f\" \"exports/svg/$(basename \"${f%.glb}\").svg\"; done"], [])
	log("✅ Conversiones TLV y SVG completadas exitosamente.")

func load_config(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var text = file.get_as_text()
		file.close()
		return JSON.parse_string(text)
	return {}

func log(msg: String):
	var now = Time.get_datetime_string_from_system(true, true)
	var f = FileAccess.open(log_file, FileAccess.WRITE_READ)
	if f:
		f.seek_end()
		f.store_line("[%s] %s" % [now, msg])
		f.close()
	print(msg)
