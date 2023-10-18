extends Node


func _ready():
	get_tree().root.use_occlusion_culling = true
	discord_sdk.app_id = 890871180268023829 # Application ID
	discord_sdk.details = "A demo activity by vaporvee"
	discord_sdk.state = "Checkpoint 23/23"
	
	discord_sdk.large_image = "example_game" # Image key from "Art Assets"
	discord_sdk.large_image_text = "Try it now!"
	discord_sdk.small_image = "boss" # Image key from "Art Assets"
	discord_sdk.small_image_text = "Fighting the end boss! D:"

	discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
	# discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"

	discord_sdk.refresh() # Always refresh after changing the values!
	

