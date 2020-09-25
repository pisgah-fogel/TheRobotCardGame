extends CanvasLayer

export(int) var idcardmax = 4

onready var mControl = $Control

export(int) var numcardmax = 3;
var selectP1 = 0;
var handP1 = [];
var selectP2 = 0;
var handP2 = [];

func giveOneCard():
	if handP1.size() < numcardmax and handP2.size() < numcardmax:
		handP1.append(randi()%numcardmax)
		handP2.append(randi()%numcardmax)
		# TODO: add animation

const Card = preload("res://card.tscn");
var spritesP1 = []
func updateDisplay():
	for inst in spritesP1:
		inst.queue_free()
	spritesP1.clear()
	
	var i = 0;
	for cardid in handP1:
		var tmp = Card.instance();
		tmp.frame = cardid
		tmp.position = Vector2(100 + 110*i, 530);
		spritesP1.append(tmp)
		mControl.add_child(tmp)
		i += 1;

func _process(delta):
	if Input.is_action_just_pressed("P1Accept"):
		print("Player 1 selected ", selectP1, " = card id ", handP1[selectP1])
	elif Input.is_action_just_pressed("P1Left"):
		if selectP1 > 0:
			selectP1 -= 1;
	elif Input.is_action_just_pressed("P1Right"):
		if selectP1 < handP1.size()-1:
			selectP1 += 1;
	
	if Input.is_action_just_pressed("P2Accept"):
		print("P2Accept");
	elif Input.is_action_just_pressed("P2Left"):
		print("P2Left");
	elif Input.is_action_just_pressed("P2Right"):
		print("P2Right");


func _on_TimerCardDistr_timeout():
	giveOneCard()
	updateDisplay()
