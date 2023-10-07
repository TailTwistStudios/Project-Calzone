extends Button

@onready var quitDelayTimer : Timer = $QuitDelay

func _ready():
	pressed.connect(NetworkManager.closeSession)
	pressed.connect(quitDelayTimer.start)

func _on_quit_delay_timeout():
	get_tree().quit()
