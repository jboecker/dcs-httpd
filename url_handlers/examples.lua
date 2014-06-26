 --[[
A URL handler function gets passed a request and a response object.
The following members are available on those objects:

request.method			HTTP method, e.g. "GET". The server does not support reading the HTTP request body yet, so POST data is not available.
request.url				The part of the URL that matched the regexp
request.url_remainder	The remainder of the URL that did not match the regexp
request.http_version	Last part of the HTTP request string, e.g. "HTTP/1.1"
request.headers			Request headers sent by the browser
request._GET			Parameters given in the query string
 
 response.headers					Response headers
 response.content_type				Content-Type header (will override response.headers["Content-Type"])
 response.status					The HTTP status code
 response.status_text				The status text (e.g. "Not Found")
 response:set_status(status_code)	Sets the HTTP status code. For codes 200, 404 and 500 it adds a matching status text.
 response:error_404()				Calls response:set_status(404) and sets the response body to "404 - Not Found"
 response:return_text(text)			Returns some text in the response body with Content-Type: text/plain and status 200
 response:return_html(html)			Returns some HTML in the response body with Content-Type: text/html and status 200
 response:return_json(object)		Serializes object to JSON and returns the resulting response body with Content-Type: application/json and status 200
 ]]--
 
 httpd.url_handlers["^/examples/show_parameters/$"] = function(request, response)
	--[[
	This handler simply returns the request object as JSON.
	Try calling it with different query strings.
	]]--
	response:return_json(request)
 end
 
 httpd.url_handlers["^/examples/spawn_smoke/$"] = function(request, response)
	--[[
	Spawn smoke relative to a named group.
	Example:
	/spawn_smoke/?relative_to=MyTankGroup&distance=20&smoke_color=Red
	]]--
	local relative_to = request._GET["relative_to"]
	local distance = request._GET["distance"] or 10
	
	if not relative_to then
		response:error_404()
		return
	end
	
	local unit = Group.getByName(relative_to):getUnit(1)
	local pos3 = unit:getPosition()
	local new_center = mist.vec.add(pos3["p"], mist.vec.scalar_mult(pos3["x"], distance))
	local smoke_color = trigger.smokeColor[request._GET["smoke_color"]] or "Green"
	
	trigger.action.smoke(new_center, smoke_color)
	response:return_text("spawned smoke.")
end