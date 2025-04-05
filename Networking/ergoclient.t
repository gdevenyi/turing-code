var ip : string
var port : int := 31337
var netStream : int
var command : string
var param : string
var recieve : string

put "Please Enter the Host Address:" ..
get ip
netStream := Net.OpenConnection (ip, port)
put "Connected!"
put "Please Enter Command to Execute..."
loop
    get command
    if command not= "" then
        put : netStream, command
    end if
    get param : *
    if param not= "" then
        put : netStream, param
    end if
    command := ""
    param := ""
    if Net.LineAvailable (netStream) then
        get : netStream, recieve : *
        put recieve
    end if
end loop

