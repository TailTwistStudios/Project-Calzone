extends Node3D

@onready var main_menu : WelcomeMenu = $CanvasLayer/Control/WelcomeMenu

const Player = preload("res://scenes/player.tscn")
const PORT = 38945
var enet_peer = ENetMultiplayerPeer.new()


func add_player(peer_id : int):
	var player = Player.instantiate()
	player.name = str(peer_id)
	player.set_multiplayer_authority(peer_id,true)
	multiplayer.peer_disconnected.connect(player._on_player_leave)
	
	add_child(player)
	
	


func _on_welcome_menu_host_session():
	main_menu.hide()
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)

	add_player(multiplayer.get_unique_id())


func _on_welcome_menu_join_session():
	main_menu.hide()
	
	if main_menu.address == "": main_menu.address = "localhost"
	enet_peer.create_client(main_menu.address, PORT)
	multiplayer.multiplayer_peer = enet_peer

