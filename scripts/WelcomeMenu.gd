extends Control

class_name WelcomeMenu

signal host_session
signal join_session

@onready var addressEntry = $"MarginContainer/HBoxContainer/Login/Address Entry"
var address : String


func _on_host_button_pressed():
	address = addressEntry.text
	host_session.emit()


func _on_join_button_pressed():
	address = addressEntry.text
	join_session.emit()
