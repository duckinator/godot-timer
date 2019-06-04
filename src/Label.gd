extends Label

onready var timer = $Timer
var mins
var secs

var running = false

func _ready():
	redraw(true)
	timer.wait_time = 1
	timer.one_shot = false
	timer.connect("timeout", self, "timeout_handler")

# Allow to click+drag the window.
func _input(event):
	if not Input.is_mouse_button_pressed(BUTTON_LEFT) or Input.is_mouse_button_pressed(BUTTON_RIGHT):
		return
	
	if not event is InputEventMouseMotion:
		return
	
	OS.window_position += event.position - (OS.window_size / 2)

func _process(delta):
	if not running and Input.is_action_just_pressed("ui_cancel"):
		stop()
		redraw(true)
		return
	
	if not Input.is_action_just_pressed("ui_accept"):
		return
	
	if running:
		stop()
	else:
		start()

func start():
	mins = 0
	secs = 0
	redraw()
	timer.start()
	running = true

func stop():
	timer.stop()
	running = false

func redraw(reset=false):
	if reset:
		self.text = "--:--"
	else:
		var display_mins = str(mins).pad_zeros(2)
		var display_secs = str(secs).pad_zeros(2)
		self.text = display_mins + ":" + display_secs

func timeout_handler():
	secs += 1
	if secs > 59:
		mins += 1
		secs = 0
	
	redraw()