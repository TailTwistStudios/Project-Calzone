extends HTTPRequest

@onready var resultsLabel : Label = $"../Label"

func _ready():
	if is_multiplayer_authority():
		request_completed.connect(_on_request_completed)
		request("http://localhost:3000/worldmap")

func _on_request_completed(_result, _response_code, _headers, body):
	if body == null: 
		push_warning("Unable to download worldmap, is the instance server down?")
		return
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
	resultsLabel.text = str(json);
