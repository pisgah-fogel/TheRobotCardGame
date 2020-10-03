extends Sprite

onready var mAnimationPlayer = $AnimationPlayer

var busy = true

export(int) var id = 0 setget setId

const probabilities = [50, 20, 20, 20, 20]
const probTotal = 160

func randomCard() -> int:
	var rand = randi()%probTotal
	var sum = 0
	var counter = 0
	for i in probabilities:
		sum += i
		if sum > rand:
			return counter
		counter += 1
	return randi()%5

var isfirstinhand = false

func setId(newid):
	# TODO: check newid's range
	id = newid
	self.frame = id

signal PlayerPlayed(playernum, cardid)

func _ready():
	self.modulate.a = 0
	setId(randomCard())
	busy = true
	mAnimationPlayer.play("Enter")

func _process(delta):
	pass

var selected = false

func selectCard(status):
	if status and not selected:
		mAnimationPlayer.play("Select")
		selected = true
		busy = true
	elif not status and selected:
		mAnimationPlayer.play("Unselect")
		selected = false
		busy = true

var playerId = 0

func playCard(newplayerId):
	mAnimationPlayer.play("Play")
	playerId = newplayerId
	busy = true

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"Enter":
			busy = false
			if isfirstinhand:
				selectCard(true)
		"Select":
			busy = false
		"Unselect":
			busy = false
		"Play":
			emit_signal("PlayerPlayed",playerId,id)
			self.queue_free()
