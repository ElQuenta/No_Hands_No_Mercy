extends CharacterBody2D

@export var selected = false
@onready var box = get_node("Box")
@onready var animation = get_node("AnimationPlayer")
@onready var target = position 
var follow_cursor = false
var speed = 75
func _ready() -> void:
	set_selected(selected)
func set_selected(value):
	selected = value
	box.visible = value


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("RightClick"):
		follow_cursor = true
	if event.is_action_released("RightClick"):
		follow_cursor = false 	
	
func _physics_process(delta: float) -> void:
	if 	follow_cursor == true:
		if selected:
			target = get_global_mouse_position()
			animation.play("idle")
	velocity = position.direction_to(target)*speed
	if position.distance_to(target) > 	10:
		move_and_slide()
	
	
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
