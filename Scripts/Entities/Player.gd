extends Node2D

onready var walk_checker : RayCast2D = $CollisionDetector/BodyCollider/WalkChecker
onready var animator : AnimationPlayer = $AnimationPlayer
onready var sprite : AnimatedSprite = $AnimatedSprite

enum DIRECTION { NONE = -1, DOWN = 0, LEFT = 1, RIGHT = 2, UP = 3 }
const VECTOR_DIRECTION = [Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.UP]
const ANIM_NAMES = ["walk_down", "walk_left", "walk_right", "walk_up"]

func _on_ready():
	pass

func _process(_delta):
	var input_direction = _get_input_direction()
	if(input_direction != DIRECTION.NONE):
		#  sprite
		var new_anim = ANIM_NAMES[input_direction]
		if(new_anim != sprite.get_animation()):
			sprite.set_animation(new_anim)
			sprite.set_frame(3)
		_try_moving(input_direction)

func _try_moving(direction):
	set_process(false)
	
	# set direction of raycast
	walk_checker.set_cast_to(VECTOR_DIRECTION[direction] * 16)
	# walk if space is open
	walk_checker.force_raycast_update()
	if(!walk_checker.is_colliding()):
		# walk anim
		animator.play(ANIM_NAMES[direction])
		yield(animator, "animation_finished")
		
	animator.stop(true)
	
	set_process(true)

func move(direction):
	# move character
	set_position(VECTOR_DIRECTION[direction] * 16 + get_position())

func _get_input_direction():
	var temp = Input.is_action_pressed("ui_up")
	if(temp or Input.is_action_pressed("ui_down")):
		return DIRECTION.UP if temp else DIRECTION.DOWN
	temp = Input.is_action_pressed("ui_right")
	if(temp or Input.is_action_pressed("ui_left")):
		return DIRECTION.RIGHT if temp else DIRECTION.LEFT
	return DIRECTION.NONE

