--[[
This file exposes some DCS scripting functions via a REST API.
]]--

httpd.url_handlers["^/coord/LLtoLO/$"] = function(request, response)
	local lat = request._GET["latitude"] or request._GET["lat"]
	local lon = request._GET["longtitude"] or request._GET["lon"]
	local alt = request._GET["altitude"] or request._GET["alt"] or 0
	
	response:return_json(coord.LLtoLO(lat, lon, alt))
 end
 
httpd.url_handlers["^/coord/LOtoLL/$"] = function(request, response)
	local x = request._GET["x"]
	local y = request._GET["y"]
	local z = request._GET["z"]
	
	local vec3 = nil
	if z then
		vec3.x = x
		vec3.y = y
		vec3.z = z
	else
		vec3.x = x
		vec3.y = 0
		vec3.z = y
	end
	
	local lat, lon, alt = coord.LOtoLL(vec3)
	response:return_json({ latitude = lat, longtitude = lon, altitude = alt })
 end
 
 
httpd.url_handlers["^/land/getHeight/$"] = function(request, response)
	response:return_json(land.getHeight({ x = request._GET["x"], y = request._GET["y"] }))
end
