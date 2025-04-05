%NOTE: This program does not work with WinOOT 3.1.1C for which it was developed
%WinOOT's Networking code is far too slow to work with this program
%This may work in a later version with Optimized Netoworking Code
var id := Window.Open ("graphics:800;600,nocursor,noecho")
var localshipx, localshipy, angle : int
var remoteshipx, remoteshipy : int
var remotelaserx, remotelasery, remoteactivelaser : int
var yspeed, xspeed : int
var activelaser : int
var locallaserx, locallasery, locallaserhit : array 1 .. 3 of int
var localshiphit, remoteshiphit : int
var shiphit : int
var boomnum : int
var netStream : int
var ip : string
var dataport : int := 5056
var choice : int
var gameover : int
var remoteblownup : int
var localblownup : int
var remoteangle : int

procedure ini
    for i : 1 .. 3
        locallaserx (i) := 9999
        locallasery (i) := 9999
        locallaserhit (i) := 0
    end for
    angle := 90
    yspeed := 0
    xspeed := 0
    activelaser := 0
    shiphit := 0
    boomnum := 0
    shiphit := 0
    localshipx := 9999
    localshipy := 9999
    gameover := 0
    remoteblownup := 0
    localblownup := 0
    remotelaserx := 9999
    remotelasery := 9999
    remoteshipx := 9999
    remoteshipy := 9999
    remoteactivelaser := 0
    remoteangle := 90
end ini


process boom
    Music.PlayFile ("boom.wav")
end boom

process lasersound
    Music.PlayFile ("laser.wav")
end lasersound

procedure explode (x, y, time : int)
    if boomnum <= 2 then
        boomnum += 1
        fork boom
    end if
    Draw.FillOval (x, y, 35, 35, black)
    Draw.FillOval (x, y, 5, 5, 12)
    Draw.FillOval (x, y, 5, 6, 40)
    delay (5)
    Draw.FillOval (x, y, 10, 7, 41)
    delay (5)
    Draw.FillOval (x, y, 15, 7, 41)
    delay (5)
    Draw.FillOval (x, y, 20, 9, 40)
    delay (5)
    Draw.FillOval (x, y, 21, 10, 41)
    delay (5)
    Draw.FillOval (x, y, 22, 10, 41)
    delay (5)
    Draw.FillOval (x, y, 23, 10, 41)
    Draw.FillOval (x, y, 24, 10, 41)
    delay (5)
    Draw.FillOval (x, y, 25, 15, 42)
    delay (5)
    Draw.FillOval (x, y, 27, 4, 43)
    delay (5)
    Draw.FillOval (x, y, 52, 1, 40)
    delay (5)
    Draw.FillOval (x, y, 53, 2, 41)
    delay (5)
    Draw.FillOval (x, y, 54, 3, 42)
    delay (5)
    Draw.FillOval (x, y, 55, 4, 43)
    delay (5)
    Draw.FillOval (x, y, 56, 5, 44)
    delay (5)
    Draw.FillOval (x, y, 57, 6, 43)
    delay (5)
    Draw.FillOval (x, y, 58, 7, 42)
    delay (5)
    Draw.FillOval (x, y, 27, 15, black)
    delay (5)
    Draw.FillOval (x, y, 40, 2, 90)
    delay (5)
    Draw.FillOval (x, y, 45, 3, 91)
    delay (5)
    Draw.FillOval (x, y, 51, 4, yellow)
    delay (5)
    Draw.FillOval (x, y, 50, 6, 92)
    delay (5)
    Draw.FillOval (x, y, 51, 7, 68)
    delay (5)
    Draw.FillOval (x, y, 58, 15, black)
    boomnum -= 1
    if boomnum < 0 then
        boomnum := 0
    end if
end explode

procedure DrawShip (x, y, angle, c : int)
    var ax, ay : int
    var bx, By : int
    var cx, cy : int
    var dx, dy : int
    ax := x
    ay := y
    bx := round (ax + 20 * cosd (angle))
    By := round (ay + 20 * sind (angle))
    cx := round (ax + 15 * cosd (angle + 135))
    cy := round (ay + 15 * sind (angle + 135))
    dx := round (ax + 15 * cosd (angle - 135))
    dy := round (ay + 15 * sind (angle - 135))
    Draw.Line (ax, ay, cx, cy, c)
    Draw.Line (cx, cy, bx, By, c)
    Draw.Line (bx, By, dx, dy, c)
    Draw.Line (dx, dy, ax, ay, c)
end DrawShip

process stars
    var starx : array 1 .. 500 of int
    var stary : array 1 .. 500 of int
    for i : 1 .. 500
        starx (i) := Rand.Int (1, maxx)
        stary (i) := Rand.Int (1, maxy)
    end for
    loop
        for i : 1 .. 500
            Draw.Dot (starx (i), stary (i), white)
        end for
    end loop
end stars

process laser (x, y, ang : int)
    var numlaser : int := activelaser
    locallaserx (numlaser) := localshipx
    locallasery (numlaser) := localshipy
    var speed : int := 10
    var laserxdir : int := round (speed * cosd (ang))
    var laserydir : int := round (speed * sind (ang))
    for i : 1 .. 100
        exit when locallaserx (numlaser) >= maxx
        exit when locallasery (numlaser) >= maxy
        exit when locallaserx (numlaser) <= 0
        exit when locallasery (numlaser) <= 0
        locallaserx (numlaser) += laserxdir
        locallasery (numlaser) += laserydir
        exit when shiphit = 1
        exit when locallaserhit (numlaser) = 1
        Draw.FillOval (locallaserx (numlaser), locallasery (numlaser), 20,
            20, black)
        Draw.FillOval (locallaserx (numlaser), locallasery (numlaser), 3, 3,
            yellow)
        delay (30)
    end for
    Draw.FillOval (locallaserx (numlaser), locallasery (numlaser), 20, 20,
        black)
    locallaserx (numlaser) := 9999
    locallasery (numlaser) := 9999
    activelaser -= 1
end laser

process moveship
    var onekey : string (1)
    loop
        exit when shiphit = 1
        getch (onekey)
        if ord (onekey) = 200 and angle = 90 then
            yspeed += 2
        elsif ord (onekey) = 200 and angle = 270 then
            yspeed -= 2
        elsif ord (onekey) = 200 and angle = 0 then
            xspeed += 2
        elsif ord (onekey) = 200 and angle = 180 then
            xspeed -= 2
        elsif ord (onekey) = 200 and angle = 45 then
            xspeed += 2
            yspeed += 2
        elsif ord (onekey) = 200 and angle = 135 then
            xspeed -= 2
            yspeed += 2
        elsif ord (onekey) = 200 and angle = 225 then
            xspeed -= 2
            yspeed -= 2
        elsif ord (onekey) = 200 and angle = 315 then
            xspeed += 2
            yspeed -= 2
        elsif ord (onekey) = 203 then
            angle += 45
        elsif ord (onekey) = 205 then
            angle -= 45
        elsif ord (onekey) = 32 and activelaser < 2 then
            activelaser += 1
            fork lasersound
            fork laser (localshipx, localshipy, angle)
            delay (100)
        end if
        if angle < 0 then
            angle += 360
        elsif angle >= 360 then
            angle -= 360
        end if
        exit when shiphit = 1
    end loop
end moveship

process localfloatship
    localshipy := maxy div 2
    loop
        if sqrt ( (remotelaserx - localshipx) ** 2 + (remotelaserx -
                localshipy) ** 2) < 15 then
            shiphit := 1
            exit
        end if

        if shiphit = 1 then
            exit
        end if
        if xspeed > 8 then
            xspeed := 8
        elsif xspeed < - 8 then
            xspeed := - 8
        end if
        if yspeed > 8 then
            yspeed := 8
        elsif yspeed < - 8 then
            yspeed := - 8
        end if
        if localshipx > maxx + 20 and xspeed > 1 then
            localshipx := 0 - 20
        elsif localshipx < 0 - 20 and xspeed < 1 then
            localshipx := maxx + 20
        end if
        if localshipy > maxy + 20 and yspeed > 1 then
            localshipy := 0 - 20
        elsif localshipy < 0 - 20 and yspeed < 1 then
            localshipy := maxy + 20
        end if
        localshipy += yspeed
        localshipx += xspeed
        Draw.FillOval (localshipx, localshipy, 35, 35, black)
        DrawShip (localshipx, localshipy, angle, brightred)
        delay (50)
    end loop
    explode (localshipx, localshipy, 100)
    localblownup := 1
    localshipx := 900
    localshipy := 900
end localfloatship

process remotefloatship
    loop
        exit when remoteblownup = 1
        Draw.FillOval (remoteshipx, remoteshipy, 35, 35, black)
        DrawShip (remoteshipx, remoteshipy, remoteangle, 11)
        if remoteactivelaser = 1 then
            Draw.FillOval (remotelaserx, remotelasery, 20,
                20, black)
            Draw.FillOval (remotelaserx, remotelasery, 3, 3,
                yellow)
            Draw.FillOval (remotelaserx, remotelasery, 20,
                20, black)
        end if
        delay (50)
    end loop
    explode (remoteshipx, remoteshipy, 100)
    remoteshipx := 900
    remoteshipy := 900
end remotefloatship


process recievedata
    loop
        exit when gameover = 1
        loop
            if Net.LineAvailable (netStream) then
                get : netStream, remoteblownup
                exit
            end if
        end loop

        loop
            if Net.LineAvailable (netStream) then
                get : netStream, remoteshipx
                exit
            end if
        end loop

        loop
            if Net.LineAvailable (netStream) then
                get : netStream, remoteshipy
                exit
            end if
        end loop

        loop
            if Net.LineAvailable (netStream) then
                get : netStream, remoteangle
                exit
            end if
        end loop

        loop
            if Net.LineAvailable (netStream) then
                get : netStream, remoteactivelaser
                exit
            end if
        end loop


        if remoteactivelaser = 1 then
            loop
                if Net.LineAvailable (netStream) then
                    get : netStream, remotelaserx
                    exit
                end if
            end loop
            loop
                if Net.LineAvailable (netStream) then
                    get : netStream, remotelasery
                    exit
                end if
            end loop
        end if
    end loop
end recievedata

process senddata
    loop
        exit when gameover = 1
        put : netStream, localblownup
        put : netStream, localshipx
        put : netStream, localshipy
        put : netStream, angle
        put : netStream, activelaser
        if activelaser = 1 then
            put : netStream, locallaserx (activelaser)
            put : netStream, locallasery (activelaser)
        end if
    end loop
end senddata

colorback (black)
cls
ini
fork stars

color (brightgreen)
put "Press 1 to Create a Game Press 2 to Join a Game: " ..
setscreen ("echo")
get choice
if choice = 1 then
    put "Waiting for Connection..."
    netStream := Net.WaitForConnection (dataport, ip)
    put "Connected!"
    localshipx := (maxx div 2) div 2
else
    put "Please enter the IP Address: " ..
    get ip
    netStream := Net.OpenConnection (ip, dataport)
    delay (5000)
    put "Connected!"
    localshipx := (maxx div 2) + ( (maxx div 2) div 2)
end if
setscreen ("noecho")
fork senddata
fork recievedata
fork remotefloatship
fork moveship
fork localfloatship
loop
    if remoteblownup = 1 then
        gameover := 1
    end if
end loop

