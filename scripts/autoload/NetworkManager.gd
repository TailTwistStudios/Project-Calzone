extends Node

@onready var registerRequest : HTTPRequest = $RegisterRequest
@onready var checkInRequest : HTTPRequest = $CheckInRequest
@onready var closeRequest : HTTPRequest = $CloseRequest
@onready var checkInTimer : Timer = $CheckInTimer

var instanceAddress : String
var sessionID: String
var sessionOwnerKey: String
var customHeaders : PackedStringArray = [
	"User-Agent:CalzoneClient",
	"Content-Type: application/json",
]

func getInstanceURL() -> String:
	return ("http://" + instanceAddress)


func registerSession():
	if multiplayer.is_server():
		var url : String = getInstanceURL() + "/registersession"
		var requestDictionary : Dictionary = {
			"hostusername": "randomname",
			"hostIPv4": str(IP.get_local_addresses()[2]),
			"worldID":"default_world",
			"visibility":"public",
		}
		var requestData : String = JSON.stringify(requestDictionary)
		
		registerRequest.request(url,customHeaders,HTTPClient.METHOD_POST,requestData)
		print("Sent registration request to " + url)

func _on_check_in_timer_timeout():
	var url : String = getInstanceURL() + "/checkinsession"
	var requestDictionary : Dictionary = {
		"sessionID": sessionID,
		"sessionOwnerKey": sessionOwnerKey,
	}
	var requestData : String = JSON.stringify(requestDictionary)
	
	checkInRequest.request(url,customHeaders,HTTPClient.METHOD_POST,requestData)


func closeSession():
	if multiplayer.is_server():
			
		var url : String = getInstanceURL() + "/closesession"
		var requestDictionary : Dictionary = {
			"sessionID": sessionID,
			"&sessionOwnerKey": sessionOwnerKey,
		}
		var requestData : String = JSON.stringify(requestDictionary)
		
		registerRequest.request(url,customHeaders,HTTPClient.METHOD_POST,requestData)
		print("Sent session close request to " + url)



#Response handling

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
