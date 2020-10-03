extends KinematicBody

export(float) var speed = 200.0

enum State {IDLE, FORWARD, RIGHT, LEFT}
var mState = State.IDLE

var mWallet = 0

func getCoin():
	print("Player got one coin")
	mWallet += 1

func _physics_process(delta):
	match mState:
		State.FORWARD:
			forward_todo -= delta
			if forward_todo <= 0:
				mState = State.IDLE
			var direction = Vector3(cos(rotation.y), 0, -sin(rotation.y))
			self.move_and_slide(direction*speed*delta, Vector3(0, 1, 0))
		State.LEFT:
			rotate_todo -= delta
			if rotate_todo <= 0:
				mState = State.IDLE
			self.rotate_y(0.7*delta)
		State.RIGHT:
			rotate_todo -= delta
			if rotate_todo <= 0:
				mState = State.IDLE
			self.rotate_y(-0.7*delta)

var forward_todo = 0.0
func _forward():
	# TODO: add paticles
	mState = State.FORWARD
	forward_todo = 3.0

var rotate_todo = 0.0
func _left():
	mState = State.LEFT
	rotate_todo = 2.0

func _right():
	mState = State.RIGHT
	rotate_todo = 2.0

func _faster():
	speed *= 1.5
	
func _slower():
	speed *= 0.67
