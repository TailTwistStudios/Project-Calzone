extends Node3D

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $"CanvasLayer/MainMenu/MarginContainer/VBoxContainer/Address Entry"

const Player = preload("res://scenes/player.tscn")
const PORT = 38945
var enet_peer = ENetMultiplayerPeer.new()

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


func _on_host_button_pressed():
	main_menu.hide()
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)

	add_player(multiplayer.get_unique_id())


func _on_join_button_pressed():
	main_menu.hide()
	
	if address_entry.text == "": address_entry.text = "localhost"
	enet_peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer


func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)
