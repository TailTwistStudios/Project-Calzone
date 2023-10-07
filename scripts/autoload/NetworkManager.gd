extends Node

@onready var registerRequest : HTTPRequest = $RegisterRequest
@onready var checkInRequest : HTTPRequest = $CheckInRequest
@onready var closeRequest : HTTPRequest = $CloseRequest
@onready var checkInTimer : Timer = $CheckInTimer

var instanceAddress : String
var sessionID: String
var sessionOwnerKey: String

func getInstanceURL() -> String:
	return ("http://" + instanceAddress)


func registerSession():
	if multiplayer.is_server():
		var requestString = (getInstanceURL()
			+ "/registersession?"
			+ "hostusername=randomname"
			+ "&hostIPv4=" + IP.get_local_addresses()[2]
			+ "&worldID=default_world"
			+ "&visibility=public")
	
		print("Registered Session" + str(requestString))
		registerRequest.request(requestString)

func closeSession():
	if multiplayer.is_server():
		closeRequest.request(getInstanceURL() + "/closesession?"
			+ "sessionID=" + sessionID
			+ "&sessionOwnerKey=" + sessionOwnerKey)

func _on_register_request_request_completed(_result, _response_code, _headers, _body):
	var json : Dictionary = JSON.parse_string(_body.get_string_from_utf8())
	print("Registered" + str(json))
	
	if json["success"]:
		sessionID = str(json["sessionID"])
		sessionOwnerKey = str(json["sessionOwnerKey"])
		checkInTimer.wait_time = json["sessionKeepAliveTime"] * 0.8
		checkInTimer.start()



func _on_check_in_request_request_completed(_result, _response_code, _headers, _body):
	var json : Dictionary = JSON.parse_string(_body.get_string_from_utf8())
	print("Checked in" + str(json))


func _on_check_in_timer_timeout():
	checkInRequest.request(getInstanceURL() +"/checkinsession?"
		+ "sessionID=" + sessionID
		+ "&sessionOwnerKey=" + sessionOwnerKey)
