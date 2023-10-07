extends Node

@onready var httpRequest : HTTPRequest = $HTTPRequest

var instanceAddress : String

func getInstanceURL() -> String:
	return ("http://" + instanceAddress)


func registerSession():
	var requestString = ( getInstanceURL()
		+ "/registersession?"
		+ "hostusername=randomname"
		+ "&hostIPv4=" + IP.get_local_addresses()[2]
		+ "&worldID=default_world"
		+ "&visibility=public")
	
	print(requestString)
	httpRequest.request(requestString)


func _on_http_request_request_completed(_result, _response_code, _headers, _body):
	var json = JSON.parse_string(_body.get_string_from_utf8())
	print(json)
