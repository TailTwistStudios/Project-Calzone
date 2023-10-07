extends Control

class_name WelcomeMenu

signal host_session
signal join_session

@onready var instanceAddressEntry = $"MarginContainer/HBoxContainer/Login/Instance Address Text Field"
var playername : String
var address : String

func _on_instance_login_button_pressed():
	NetworkManager.instanceAddress = instanceAddressEntry.text
	host_session.emit()
	NetworkManager.registerSession()
