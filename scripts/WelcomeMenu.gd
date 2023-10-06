extends Control

class_name WelcomeMenu

signal host_session
signal join_session

@onready var addressEntry = $"MarginContainer/HBoxContainer/Login/Address Entry"
@onready var instanceAddressEntry = $"MarginContainer/HBoxContainer/Login/Instance Address Text Field"
@onready var playernameEntry = $"MarginContainer/HBoxContainer/Login/Username Entry"
var playername : String
var address : String


func _on_host_button_pressed():
	address = addressEntry.text
	playername = playernameEntry.text
	host_session.emit()


func _on_join_button_pressed():
	address = addressEntry.text
	playername = playernameEntry.text
	join_session.emit()



func _on_instance_login_button_pressed():
	NetworkManager.instanceAddress = instanceAddressEntry.text
	host_session.emit()
	NetworkManager.registerSession()
