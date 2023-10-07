extends Button

class_name SessionListingButton

@onready var hostNameLabel : Label = $"MarginContainer/HBoxContainer/VBoxContainer/Host Name Label"
@onready var locationNameLabel : Label = $"MarginContainer/HBoxContainer/VBoxContainer/Location Name"

func set_data(data_dict : Dictionary):
	hostNameLabel.text = str(data_dict["hostusername"])
	locationNameLabel.text = str(data_dict["worldID"])
