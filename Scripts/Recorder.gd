extends Node

@export var screenshot_interval : int = 2  # Capture every X frames
@export var max_screenshots : int = 2000   # Safety limit
@export var screenshot_path : String = "res://Images/"
@export var use_threading : bool = true    # Threaded saving for better performance
@export var use_timestamps : bool = false  # Use timestamps instead of frame numbers

var frame_count := 0
var save_thread := Thread.new()

func _ready():
	# Create screenshots directory
	var dir = DirAccess.open("/home/mohamed/ScreenShots/")
	if dir:
		var err = dir.make_dir_recursive(screenshot_path)
		if err != OK:
			push_error("Failed to create screenshot directory: ", err)
	else:
		push_error("Failed to access user directory")

func _process(_delta):
	frame_count += 1
	if frame_count % screenshot_interval == 0 and frame_count <= max_screenshots:
		# Get the viewport image
		var img = get_viewport().get_texture().get_image()
		
		if use_threading:
			# Save in background thread
			if save_thread.is_started():
				save_thread.wait_to_finish()
			save_thread.start(_save_image.bind(img.duplicate(), frame_count))
		else:
			# Save immediately
			_save_image(img, frame_count)

func _save_image(img: Image, frame_num: int):
	# Generate filename
	var filename : String
	if use_timestamps:
		var timestamp = Time.get_datetime_string_from_system().replace(":", "-")
		filename = "%sscreenshot_%s.png" % [screenshot_path, timestamp]
	else:
		filename = "%sscreenshot_%05d.png" % [screenshot_path, frame_num]
	
	# Save the image
	var err = img.save_png(filename)
	if err != OK:
		push_error("Failed to save screenshot: ", err)

func _exit_tree():
	# Clean up thread when exiting
	if save_thread.is_started():
		save_thread.wait_to_finish()
