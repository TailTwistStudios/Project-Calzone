extends VBoxContainer

@onready var httpRequest : HTTPRequest = $"../SessionRequest"
@onready var sessionlabel : Label = $SessionLabel
@onready var sessionListingPrefab : PackedScene = preload("res://scenes/ui/session_listing.tscn")

func updateSessionList():
	httpRequest.request(NetworkManager.getInstanceURL() + "/sessions")


# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(updateSessionList)
	updateSessionList()


func _on_refresh_button_pressed():
	updateSessionList()


func _on_session_request_request_completed(_result, _response_code, _headers, _body):
	for child in get_children():
		child.queue_free()
	
	var json = JSON.parse_string(_body.get_string_from_utf8())
	#print(str(json))
	for entry in json:
		var entryDict : Dictionary = entry
		var sessionListingInstance : SessionListingButton = sessionListingPrefab.instantiate()
		add_child(sessionListingInstance)
		sessionListingInstance.set_data(entryDict)
		
