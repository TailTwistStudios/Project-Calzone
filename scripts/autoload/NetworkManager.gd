extends Node

@onready var httpRequest : HTTPRequest = $HTTPRequest

var instanceAddress : String


func registerSession():
	var requestString = ("http://" + instanceAddress 
		+ "/registersession?"
		+ "hostusername=randomname"
		+ "&hostIP=" + IP.get_local_addresses()[2]
		+ "&worldID=default_world"
		+ "&visibility=public")
	
	print(requestString)
	httpRequest.request(requestString)
	print()


func _on_http_request_request_completed(result, response_code, headers, body):
	print(response_code)
