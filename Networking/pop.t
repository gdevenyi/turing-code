var id := Window.Open ("graphics:800;600")
var netStream : int
var server : string
var user : string
var password : string
var line : string
var choice : string
var dummy : int := 0

colorback(black)
cls
color(brightgreen)

loop
    put "Please enter the server address: " ..
    get server
    netStream := Net.OpenConnection (server, 110)
    if netStream <= 0 then
        put "Could not contact Server!"
    else
        exit
    end if
end loop
put "Connected to ", server, " on port 110"

loop
    put "Please enter your User Name: " ..
    get user
    put : netStream, "user ", user
    get : netStream, line : *
    get : netStream, line
    if line = "+OK" then
        put "User exists, continue"
        get : netStream, line : *
        exit
    else
        put "Error, user does not exist!"
    end if
end loop

loop
    password := ""
    put "Please enter Password: " ..
    setscreen ("noecho")
    get password
    setscreen ("echo")
    put : netStream, "pass ", password
    get : netStream, line
    if line = "-ERR" then
        put "\nPassword Incorrect"
        get : netStream, line : *
    else
        put "\nPassword Correct"
        get : netStream, line : *
        exit
    end if
end loop

if Net.LineAvailable (netStream) then
    get : netStream, line : *
end if

put : netStream, "list"
get : netStream, line
get : netStream, line
put "You have, ", line, " message(s)"
put "Please enter number of message to read: " ..
get choice
put : netStream, "retr ", choice

loop
    if Net.LineAvailable (netStream) = true then
        get : netStream, line : *
        put line ..
        delay (300)
    else
        exit
    end if
end loop

Net.CloseConnection (netStream)

