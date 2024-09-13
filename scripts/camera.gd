extends Camera2D

var mouse_pos = Vector2()
var mouse_posGlobal = Vector2()

var start = Vector2()
var startV = Vector2()
var end = Vector2()
var endV = Vector2()
var is_dragging = false
signal area_selected
signal star_mov_selected
@onready var box: Panel = $"../UI/Panel"

func _ready():
	connect("area_selected", Callable(get_parent(), "_on_area_selected")) 

func _process(delta):
	if Input.is_action_just_pressed("LeftClick"):
		
		start = mouse_posGlobal
		startV = mouse_pos
		is_dragging = true 
	if is_dragging:
		end = mouse_posGlobal
		endV = mouse_pos
		draw_area()
	if Input.is_action_just_released("LeftClick"):
		if startV.distance_to(mouse_pos) > 20:	
			end = mouse_posGlobal
			endV = mouse_pos
			is_dragging = false
			draw_area(false)
			emit_signal("area_selected", self)
		else: 
			end = start
			is_dragging = false
			draw_area(false)

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouse:	
		mouse_pos = event.position
		mouse_posGlobal = get_global_mouse_position()
 	

func draw_area(s = true):
	box.size = Vector2(abs(startV.x - endV.x), abs(startV.y - endV.y))
	var pos = Vector2()
	pos.x = min(startV.x, endV.x)
	pos.y = min(startV.y, endV.y)
	box.position = pos
	box.size *= int(s)
