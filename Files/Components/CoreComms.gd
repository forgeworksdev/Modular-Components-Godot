##CoreC (pronounced Core C) is the Core of Communications.
class_name CoreComms extends Node

	#func generate_uuid() -> String:
		#var uuid: String = ""
		#for i in range(16):
			#uuid += "%02x" % (randi() % 256)
			#if i in [3, 5, 7, 9]:
				#uuid += "-"
		#return uuid
