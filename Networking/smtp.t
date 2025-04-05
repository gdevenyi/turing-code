var id := Window.Open("graphics:800;600")
var netStream : int
var server : string
var email : string
var subject : string
var rcpt : string
var rcptname : string
var sendername : string
var line : string

colorback(black)
cls
color(brightgreen)

loop
    put "Please enter the server address: " ..
    get server
    netStream := Net.OpenConnection (server, 25)
    if netStream <= 0 then
        put "Could not contact Server!"
    else
        exit
    end if
end loop

put "Connected to ", server, " on port 25"
get : netStream, line : *


loop
    put "Please Enter your Email Address: " ..
    get email
    put : netStream, "mail from:", email
    delay (1500)
    get : netStream, line
    if line = "250" then
        get : netStream, line : *
        exit
    else
        put "Error, Please Try Again"
    end if
end loop

loop
    put "Please Enter the Reciepent's Address: " ..
    get rcpt
    put : netStream, "rcpt to:", rcpt
    get : netStream, line
    if line = "250" then
        get : netStream, line : *
        exit
    else
        put "Error, Invalid E-mail Address"
    end if
end loop

loop
    put : netStream, "data"
    delay (500)
    get : netStream, line
    exit when line = "354"
end loop

put "Please Enter Your Name: " ..
get line : *
put : netStream, "From: \"", line, "\""
put "Please Enter the Recipent's Name: " ..
get line : *
put : netStream, "To: \"", line, "\""
put "Please enter the Subject: " ..
get line : *
put : netStream, "Subject: ", line
put "Please Enter the Message:(leave \".\" on a blank line to finish)"
loop
    get line : *
    put : netStream, line
    exit when line = "."
end loop


Net.CloseConnection (netStream)

