var server : string := ""
var email : string := ""
var subject : string := ""
var rcpt : string := ""
var rcptname : string := ""
var sendername : string := ""
var line : string := "hello"
var netStream : int
var foo : string

loop
    netStream := Net.OpenConnection (server, 25)
    get : netStream, foo : *
    put foo
    put : netStream, "helo ergo"
    get : netStream, foo : *
    put foo
    put : netStream, "mail from:", email
    get : netStream, foo : *
    put foo
    put : netStream, "rcpt to:", rcpt
    get : netStream, foo : *
    put foo
    put : netStream, "data"
    get : netStream, foo : *
    put foo
    put : netStream, "From: \"", sendername, "\""
    put : netStream, "To: \"", rcptname, "\""
    put : netStream, "Subject: ", subject
    for i : 1 .. 5
        put : netStream, line
    end for
  put : netStream, "."
    get : netStream, foo : *
    put foo

    Net.CloseConnection (netStream)
end loop

