extends Camera2D
var MousePos = Vector2()
var MousePosG = Vector2()
var start = Vector2()
var startV = Vector2()
var end= Vector2()
var endV = Vector2()
var isDragging = false 
signal area_selected 
signal star_move_selection
#ZOOM
@export var Speed = 20.0
@export var SpeedZoom = 50.0
@export var ZoomMargen = 0.1
@export var ZoomMin = 0.3
@export var ZoomMax = 1.0

var zoomFactor = 1.0
var zoomPos = Vector2()
var zoomIng = false    

func _ready() -> void:
	connect('area_selected', Callable(get_parent(), "_on_area_selected"))

func _process(delta: float) -> void:
	
	var inputX = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left"))
	var inputY = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
	
	position.x = lerp(position.x, position.x+inputX*Speed*zoom.x, Speed*delta)
	position.y = lerp(position.y, position.y+inputY*Speed*zoom.y, Speed*delta)	
	
	zoom.x = lerp(zoom.x, zoom.x * zoomFactor, SpeedZoom*delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomFactor, SpeedZoom*delta)
	
	zoom.x = clamp(zoom.x, ZoomMin, ZoomMax)
	zoom.y = clamp(zoom.y, ZoomMin, ZoomMax)
	
	if not zoomIng:
		zoomFactor = 1.0
		
	if Input.is_action_just_pressed("LeftClick"):
		start = MousePosG
		startV = MousePos
		isDragging = true 
	if isDragging:
		end = MousePosG
		endV = MousePos
		draw_area() 
	if Input.is_action_just_released("LeftClick"):
		if startV.distance_to(MousePos) > 20:	
			end = MousePosG
			endV = MousePos
			isDragging = false
			draw_area(false)
			emit_signal("area_selected", self)
		else: 
			end = start
			isDragging = false
			draw_area(false)
		
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		MousePos = event.position
		MousePosG = get_global_mouse_position()
		
	if abs(zoomPos.x  - get_global_mouse_position().x) > ZoomMargen:
		zoomFactor = 1.0
	if abs(zoomPos.y  - get_global_mouse_position().y) > ZoomMargen:	
		zoomFactor = 1.0
	if event is InputEventMouseButton:
		if event.is_pressed():
			zoomIng = true
			if event.is_action("WheelDown"):
				zoomFactor -= 0.01 * SpeedZoom 
				zoomPos = get_global_mouse_position() 
			if event.is_action("WheelUp"):
				zoomFactor += 0.01 * SpeedZoom 
				zoomPos = get_global_mouse_position() 
		else:
			zoomIng = false 
	
 
func draw_area(s = true):
	get_node("../ui/Panel").size = Vector2(abs(startV.x - endV.x),abs(startV.y - endV.y))
	var pos = Vector2()
	pos.x = min(startV.x, endV.x)
	pos.y = min(start.y, endV.y)
	get_node("../ui/Panel").position = pos 
	get_node("../ui/Panel").size *= int(s) 
	
