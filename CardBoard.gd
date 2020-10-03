extends CanvasLayer

export(int) var idcardmax = 4

onready var mControl = $Control

export(int) var numcardmax = 3;
var selectP1 = 0;
var selectP2 = 0;

const Card = preload("res://card.tscn");
var spritesP1 = []
var spritesP2 = []

func _cardplayedby(playerid, cardid):
	match playerid:
		0:
			var counter = 0
			for sprite in spritesP1:
				sprite.position.x = 100 + 110*counter
				counter+=1
		1:
			var counter = 0
			for sprite in spritesP2:
				sprite.position.x = get_viewport().get_visible_rect().size.x/2 + 100 + 110*counter
				counter+=1

func giveOneCard():
	if spritesP1.size() < numcardmax and spritesP2.size() < numcardmax:
		var card1 = Card.instance()
		card1.position.x = 100 + 110*spritesP1.size()
		card1.position.y = 480
		card1.isfirstinhand = (spritesP1.size() == 0)
		mControl.add_child(card1)
		card1.connect("PlayerPlayed", self, "_cardplayedby")
		card1.connect("PlayerPlayed", get_parent(), "_cardplayedby")
		spritesP1.append(card1)
		
		var card2 = Card.instance()
		card2.position.x = get_viewport().get_visible_rect().size.x/2 + 100 + 110*spritesP2.size() # TODO screen width/2
		card2.position.y = 480
		card2.isfirstinhand = (spritesP2.size() == 0)
		mControl.add_child(card2)
		card2.connect("PlayerPlayed", self, "_cardplayedby")
		card2.connect("PlayerPlayed", get_parent(), "_cardplayedby")
		spritesP2.append(card2)

func _ready():
	updateDisplay()
	var counter = 0
	for sprite in spritesP2:
		sprite.position.x = get_viewport().get_visible_rect().size.x/2 + 100 + 110*counter
		counter+=1

func updateDisplay():
	updateCursorP1()
	updateCursorP2()

onready var mCursorP1 = $cursorP1
func updateCursorP1():
	mCursorP1.position.x = 100 + 110*selectP1
	
onready var mCursorP2 = $cursorP2
func updateCursorP2():
	mCursorP2.position.x = get_viewport().get_visible_rect().size.x/2 + 100 + 110*selectP2

func _process(delta):
	if Input.is_action_just_pressed("P1Accept") and spritesP1.size()>0:
		print("Player 1 selected ", selectP1, " = card id ", spritesP1[selectP1].id)
		spritesP1[selectP1].playCard(0)
		spritesP1.erase(spritesP1[selectP1])
		selectP1 = 0
		updateCursorP1()
	elif Input.is_action_just_pressed("P1Left"):
		if selectP1 > 0 and not spritesP1[selectP1-1].busy:
			spritesP1[selectP1].selectCard(false)
			selectP1 -= 1;
			spritesP1[selectP1].selectCard(true)
			updateCursorP1()
	elif Input.is_action_just_pressed("P1Right"):
		if selectP1 < spritesP1.size()-1 and not spritesP1[selectP1+1].busy:
			spritesP1[selectP1].selectCard(false)
			selectP1 += 1;
			spritesP1[selectP1].selectCard(true)
			updateCursorP1()
	
	if Input.is_action_just_pressed("P2Accept") and spritesP2.size()>0:
		print("Player 2 selected ", selectP2, " = card id ", spritesP2[selectP2].id)
		spritesP2[selectP2].playCard(1)
		spritesP2.erase(spritesP2[selectP2])
		selectP2 = 0
		updateCursorP2()
	elif Input.is_action_just_pressed("P2Left"):
		if selectP2 > 0 and not spritesP2[selectP2-1].busy:
			spritesP2[selectP2].selectCard(false)
			selectP2 -= 1;
			spritesP2[selectP2].selectCard(true)
			updateCursorP2()
	elif Input.is_action_just_pressed("P2Right"):
		print("P2 cursor ", selectP2)
		print("P2 hand size ", spritesP2.size())
		if selectP2 < spritesP2.size()-1 and not spritesP2[selectP2+1].busy:
			spritesP2[selectP2].selectCard(false)
			selectP2 += 1;
			spritesP2[selectP2].selectCard(true)
			updateCursorP2()

func _on_TimerCardDistr_timeout():
	giveOneCard()
	updateDisplay()
