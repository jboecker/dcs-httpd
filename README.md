dcs-httpd
=========

A minimal HTTP server that can run within the DCS: World Mission Scripting environment.
The server supports HTTP/1.1 GET requests with query strings and can reload the URL handlers while the mission is running.

## Security Considerations
While I have tried to make the server secure, I do not claim to fully understand the Lua scripting environment inside DCS: World.

Editing your MissionScripting.lua file can possibly allow mission scripts to delete your files, send spam and kill your cat. Use this at your own risk.

## Initial Setup
* Copy the files to `%USERPROFILE%\Saved Games\DCS\Scripts\dcs-httpd` (e.g. `C:\Users\<Your Username>\Saved Games\DCS\Scripts\dcs-httpd`).
* Go to your DCS: World installation directory (most likely `C:\Program Files\Eagle Dynamics\DCS World`), open the `Scripts` subfolder and edit the file `MissionScripting.lua`.
Add the following code somewhere before the function `sanitizeModule` is defined:
````lua
httpd = {}
-- uncomment the following lines and change the paths
-- if you want the server to look elsewhere for files and URL handlers
-- httpd.document_root = lfs.writedir()..[[Scripts\dcs-httpd\public_html\]]
-- httpd.handlerdir = lfs.writedir()..[[Scripts\dcs-httpd\url_handlers\]]
httpd.bind_address = "localhost" -- set to "*" to allow connections from other computers
dofile(lfs.writedir()..[[Scripts\dcs-httpd\httpd.lua]])
````

## Adding the HTTP server to a mission
To start the server, your mission will have to call `httpd.start(timer, env)` (you have to pass it the `timer` and `env` objects because they are not available at the point the server is defined).

Simply create a new trigger set to fire ONCE, create a new condition TIME IS MORE (1 second) and create a DO SCRIPT action with the text `httpd.start(timer, env)`.

Then start your mission, enter a slot (or unpause it in multiplayer) and point your browser at http://localhost:12080 and it should tell you its version.
You can also try http://localhost:12080/example.html to get a static HTML file.

## URL handlers
The object `httpd.url_handlers` maps regular expressions to URL handler functions. The first function whose regex matches the request URL will handle it.
If no handler function is found, the server will look for a static file under the directory `httpd.document_root` instead (that variable is only read once during initialization).

Look at the file `url_handlers\example.lua` to see how to write your own handlers.

On startup, all lua files in the `url_handlers` directory are executed. When you browse to `http://localhost:12080/reload/`, they will be re-read.

Note: The /reload/ URL is a special case and cannot be overridden in a custom URL handler.

## Debugging with dcs-httpd
The URL handlers you write are executed in the same context as your mission scripts.
During a running mission, you can simply Alt+Tab out of the game, edit your URL handler, browse to the /reload/ URL to reload it,
and then browse to its URL to execute the code.

It probably gets even more convenient if you have a second computer handy and put the URL handlers in a shared folder.
Make sure to set `httpd.bind_address` to `"*"` in MissionScripting.lua to listen to requests from other computers.

## License
The code is released under the terms of the GNU GPLv3 or any later version (see the LICENSE file).
