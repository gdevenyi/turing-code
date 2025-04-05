var ip, ip2 : string
var chatport : int
var user : string
var sendline, recieveline : string := ""
var netStream, netStream2 : int
var choice : int
var win2 := Window.Open ("graphics:800;290,position:0;0")
var win := Window.Open ("graphics:800;290,position:0;320")
var error : boolean := false

colorback (black)
cls
color (brightgreen)
Window.SetActive(win2)
colorback (black)
cls
color (brightgreen)

procedure server (port : int)
    put "Waiting for Connection on IP: ", Net.LocalAddress, ", on machine ",
        Net.LocalName
    netStream := Net.WaitForConnection (port, ip)
    put "Connected!"
    delay (500)
end server

procedure connect (address : string, port : int)
    netStream := Net.OpenConnection (address, port)
    if netStream <= 0 then
        put "Error, Could not Establish Connection"
        error := true
    end if
end connect

process sendchat
    loop
        exit when sendline = "quit"
        Window.SetActive(win)
        get sendline : *
        put : netStream, user, ": ", sendline
    end loop
end sendchat

process recievechat
    loop
        if Net.LineAvailable (netStream) then
            exit when recieveline = "quit"
            get : netStream, recieveline : *
            Window.SetActive(win2)
            put recieveline
            Window.SetActive(win)
        end if
    end loop
end recievechat

process recievechat2
    netStream2 := Net.WaitForConnection (5056, ip2)
    if netStream2 > 0 then
        loop
            if Net.LineAvailable (netStream2) then
                exit when recieveline = "quit"
                get : netStream2, recieveline : *
                Window.SetActive(win2)
                put recieveline
                Window.SetActive(win)
            end if
        end loop
    end if
end recievechat2

%Main Prog
Window.SetActive(win2)
put "Waiting For Other User...."
Window.SetActive(win)
put "Press 1 to Run Chat Server, Press 2 to Connect to Chat Server"
get choice
if choice = 1 then
    put "What is your User Name?"
    get user : *
    put "What is the Chat Port?"
    get chatport
    server (chatport)
    cls
    delay (500)
    put : netStream, "User ", user, " Has Joined!"
    fork sendchat
    fork recievechat
else
    put "What is your User Name?"
    get user : *
    put "What is the IP Address?"
    get ip
    put "What is the Chat Port?"
    get chatport
    connect (ip, chatport)
    if error = false then
        cls
        delay (500)
        put "Connected to Machine, ", Net.HostNameFromAddress (ip),
            " on IP: ", ip
        put : netStream, "User ", user, " Has Joined!"
        fork sendchat
        fork recievechat
    end if
end if

loop
    exit when error
    if recieveline = "quit" then
        Net.CloseConnection (netStream)
        exit
    elsif sendline = "quit" then
        Net.CloseConnection (netStream)
        exit
    end if
end loop

