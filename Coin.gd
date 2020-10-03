extends Area

func _on_Coin_body_entered(body):
	body.getCoin()
	self.queue_free()
