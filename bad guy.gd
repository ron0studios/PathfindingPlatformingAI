extends KinematicBody2D

const UP = Vector2(0, -1);
const GRAVITY = 20;
export var SPEED = 300;
export var JUMP_HEIGHT = -500;
var motion = Vector2();
var targetBody : CollisionObject2D
var TargetActive : bool = false
var a = 0
export var pathpointA = Vector2(0,0)
export var pathpointB = Vector2(0,0)
var activepoint
var Targetdir : Vector2
var pathpointdir : Vector2
export var idleTime = 1.0
export var outofrangeTime = 2.0
export(String, "never", "none", "always") var canAlwaysSee = "none"

var isPlayer
var idle : bool = false


func _ready():
	$idletimer.wait_time = idleTime
	$outofrange.wait_time = outofrangeTime
	set_physics_process(false)
	pass

func inSight():

	$sight.cast_to = Vector2(targetBody.position.x - position.x, targetBody.position.y - position.y)
	if $sight.get_collider() != targetBody:
		return false
	else:
		return true

func canSee():
	if $eye.overlaps_body(targetBody):
		if inSight():
			return true
	else:
		$sight.cast_to = Vector2(0,0)
		return false

	

func canJump():
	if is_on_floor() and $jumpcasts/jumpcast.is_colliding() and not $jumpcasts/jumpmax.is_colliding() and not $jumpcasts/jumpcast.get_collider().name == "Player":
		return true
	else:
		return false


func _physics_process(delta):
	motion.y += GRAVITY
	
	if canAlwaysSee == "always":
		TargetActive = true
	elif canAlwaysSee == "never":
		TargetActive = false
	else:
		TargetActive = TargetActive
	
	
	if targetBody.position.x - position.x + 32 <= 50 and targetBody.position.x - position.x >= -50:
		Targetdir.x = 0
	else:
		Targetdir.x = sign(targetBody.position.x - position.x)
		
	if activepoint == 0:
		if pathpointA.x - position.x <= 5 and pathpointA.x - position.x >= -5 :
			pathpointdir.x = 0
		else:
			pathpointdir.x = sign(pathpointA.x - position.x)
	elif activepoint == 1:
		if pathpointB.x - position.x <= 5 and pathpointB.x - position.x >= -5:
			pathpointdir.x = 0
		else:
			pathpointdir.x = sign(pathpointB.x - position.x)

	if canSee() and !TargetActive:
		TargetActive = true

	if TargetActive:
		motion.x = lerp(motion.x, Targetdir.x * SPEED, 0.2)
		if Targetdir.x == -1:
			$eye.scale.x = -1
			$jumpcasts.scale.x = -1
		elif Targetdir.x == 1:
			$eye.scale.x = 1
			$jumpcasts.scale.x = 1
		
		if canJump():
			motion.y = JUMP_HEIGHT
	else:
		if activepoint == null:
			activepoint = 0
			
		if not idle:
			motion.x = lerp(motion.x,pathpointdir.x * SPEED,0.2)
		elif idle:
			motion.x = 0
		
		if pathpointdir.x == -1:
			$eye.scale.x = -1
			$jumpcasts.scale.x = -1
		elif pathpointdir.x == 1:
			$eye.scale.x = 1
			$jumpcasts.scale.x = 1
		elif pathpointdir.x == 0:
			idle = true
			if $idletimer.time_left == 0:
				$idletimer.start()
			$eye.scale.x = $eye.scale.x
			$jumpcasts.scale.x = $jumpcasts.scale.x
			
		if canJump():
			motion.y = JUMP_HEIGHT

	if !canSee() and TargetActive and not $outofrange.time_left > 0:
		$outofrange.start()
	
	motion = move_and_slide(motion, UP);
	pass

func _on_outofrange_timeout():
	if !canSee():
		TargetActive = false
	pass # Replace with function body.
	

func _on_VisibilityNotifier2D_screen_entered():

	set_physics_process(true)
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():

	set_physics_process(false)
	pass # Replace with function body.


func _on_idletimer_timeout():
	idle = false
	if activepoint == 0:
		activepoint = 1
	elif activepoint == 1:
		activepoint = 0
	pass # Replace with function body.