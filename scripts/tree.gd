extends StaticBody2D

var timeT = 5
var currentTime
var units = 0

@onready var progress = $ProgressBar 
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentTime = timeT
	progress.max_value = timeT
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress.value = currentTime
	if currentTime <= 0:
		tree_chooped()
	pass
	

func _on_area_tree_body_entered(body: Node2D) -> void:
	print("X")
	if "units" in body.name:
		units +=1
		start_chooping()

func _on_area_tree_body_exited(body: Node2D) -> void:
	if "units" in body.name:
		units -=1
		if units <= 0:
			timer.stop()
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	var chopSpeed = 1* units
	currentTime -= chopSpeed
	var tween = get_tree().create_tween()
	tween.tween_property(progress, "value", currentTime, 0.5).set_trans(tween.TRANS_LINEAR)	
	
	
func start_chooping():
	if not timer.is_stopped():
		return
	timer.start()

func tree_chooped():
	queue_free()
	
