extends Spatial

onready var mPlayer1 = $Player1
onready var mPlayer2 = $Player2

func _cardplayedby(playerid, cardid):
	print("Player ", playerid, " played card ", cardid)
	var players = [mPlayer1, mPlayer2]
	match cardid:
		0: # Forward
			players[playerid]._forward()
		1: # Right
			players[playerid]._right()
		2: # Left
			players[playerid]._left()
		3: # Faster
			players[playerid]._faster()
		4: # Slower
			players[playerid]._slower()
		5: # TODO
			pass
		6: # TODO
			pass
