%Declaration of Variables
var id := Window.Open ("fullscreen,nocursor,noecho")
%For Turing 4.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%var id := Window.Open ("graphics:max,max,nocursor,noecho")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var font1, font2, font3 : int
var yspeed, xspeed : int
var activelaser : int
var shipx, shipy, angle, shiphit : int
var boomnum : int
var blownup : int
var difficulity : string (1)
var timedelay : int
var scoremult : int
var flashbomb : int
var laserx, lasery, laserhit : array 1 .. 3 of int
var points : string
var playagain : string (1)
var screendone : int
var cheater : boolean := false
var cheatcount := 0
var numberasteroids : int := 0

%Initilatation of Variables
font1 := Font.New ("impact:100")
font2 := Font.New ("impact:50")
font3 := Font.New ("impact:30")
procedure ini
    for i : 1 .. 3
	laserx (i) := 9999
	lasery (i) := 9999
	laserhit (i) := 0
    end for
    angle := 90
    yspeed := 0
    xspeed := 0
    activelaser := 0
    shipx := 0
    shipy := 0
    shiphit := 0
    boomnum := 0
    blownup := 0
    screendone := 0
    shiphit := 0
    shipx := 9999
    shipy := 9999
    flashbomb := 0
end ini

%Declaration of Proceses and Procedures
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

process boom
    Music.PlayFile ("boom.wav")
end boom

process lasersound
    Music.PlayFile ("laser.wav")
end lasersound

process flashcharge
    Music.PlayFile ("flashcharge.wav")
end flashcharge

process flashshoot
    Music.PlayFile ("flashshoot.wav")
end flashshoot

process flash
    fork flashcharge
    delay (1500)
    fork flashshoot
    delay (500)
    flashbomb := 1
    delay (1000)
    flashbomb := 2
    delay (1000)
    flashbomb := 3
end flash

procedure DrawShip (x, y, angle : int)
    var ax, ay : int
    var bx, By : int
    var cx, cy : int
    var dx, dy : int
    ax := shipx
    ay := shipy
    bx := round (ax + 20 * cosd (angle))
    By := round (ay + 20 * sind (angle))
    cx := round (ax + 15 * cosd (angle + 135))
    cy := round (ay + 15 * sind (angle + 135))
    dx := round (ax + 15 * cosd (angle - 135))
    dy := round (ay + 15 * sind (angle - 135))
    Draw.Line (ax, ay, cx, cy, grey)
    Draw.Line (cx, cy, bx, By, grey)
    Draw.Line (bx, By, dx, dy, grey)
    Draw.Line (dx, dy, ax, ay, grey)
end DrawShip

procedure DrawAsteroid (x, y, size : int)
    var xasteroid : array 1 .. 6 of int
    var yasteroid : array 1 .. 6 of int
    xasteroid (1) := x - size div 2 + 10
    yasteroid (1) := y + size div 2 + 5
    xasteroid (2) := x + size div 2
    yasteroid (2) := y + size div 2
    xasteroid (3) := x + size div 2 + 10
    yasteroid (3) := y
    xasteroid (4) := x
    yasteroid (4) := y - size div 2
    xasteroid (5) := x - size div 2
    yasteroid (5) := y - size div 2
    xasteroid (6) := x - size div 2 - 15
    yasteroid (6) := y
    Draw.Polygon (xasteroid, yasteroid, 6, grey)
end DrawAsteroid

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

process screen
    for i : 1 .. 10
	delay (100)
	colorback (brightred)
	cls
	delay (100)
	colorback (white)
	cls
    end for
    colorback (white)
    cls
    colorback (black)
    cls
    screendone := 1
end screen

process score
    color (brightgreen)
    locate (2, 2)
    put "Asteroids Destroyed: ", blownup
    locate (2, 30)
    put "Score: ", blownup * scoremult
    loop
	exit when shiphit = 1
	locate (2, 2)
	put "Asteroids Destroyed: ", blownup ..
	locate (2, 30)
	put "Score: ", blownup * scoremult ..
    end loop
end score

process floatAsteroidSmall (xc, yc, size : int)
    var x := xc
    var y := yc
    var xDirection := Rand.Int ( - 10, 10)
    var yDirection := Rand.Int ( - 10, 10)
    var randx : int := Rand.Int (0, 1)
    var randy : int := Rand.Int (0, 1)
    if randx = 0 then
	randx := 5
    elsif randx = 1 then
	randx := - 5
    end if
    if randy = 0 then
	randy := 5
    elsif randy = 1 then
	randy := - 5
    end if
    x += randx
    y += randy
    loop
	DrawAsteroid (x, y, size)
	x += xDirection
	y += yDirection
	if x > maxx + 35 and xDirection > 0 then
	    x := 0 - 35
	elsif x = 0 - 35 and xDirection < 0 then
	    x += maxx + 35
	elsif y > maxy + 20 and yDirection > 0 then
	    y := 0 - 20
	elsif y = 0 - 20 and yDirection < 0 then
	    y += maxy + 20
	end if
	delay (50)
	Draw.FillOval (x, y, size + 15, size + 15, black)

	if sqrt ( (x - shipx) ** 2 + (y - shipy) ** 2) < 35 and cheater =
		false then
	    shiphit := 1
	    exit
	end if

	exit when shiphit = 1

	if sqrt ( (x - laserx (1)) ** 2 + (y - lasery (1)) ** 2) < 30
		then
	    laserhit (1) := 1
	    blownup += 1
	    exit
	elsif sqrt ( (x - laserx (2)) ** 2 + (y - lasery (2)) ** 2) < 30
		then
	    laserhit (2) := 1
	    blownup += 1
	    exit
	elsif sqrt ( (x - laserx (3)) ** 2 + (y - lasery (3)) ** 2) < 30
		then
	    laserhit (3) := 1
	    blownup += 1
	    exit
	elsif flashbomb = 1 then
	    exit
	elsif flashbomb = 2 then
	    exit
	end if
    end loop

    explode (x, y, 50)
    for i : 1 .. 3
	laserhit (i) := 0
    end for
end floatAsteroidSmall

process floatAsteroid (size : int)
    numberasteroids += 1
    var x, y : int
    var xDirection := Rand.Int ( - 10, 10)
    var yDirection := Rand.Int ( - 10, 10)
    x := Rand.Int (0, 1)
    y := Rand.Int (0, 1)
    if x = 0 then
	x := maxx
    elsif x = 1 then
	x := 0
    end if
    if y = 0 then
	y := maxy
    elsif y = 1 then
	y := 0
    end if
    loop
	DrawAsteroid (x, y, size)
	x += xDirection
	y += yDirection
	if x > maxx + 45 and xDirection > 0 then
	    x := 0 - 45
	elsif x = 0 - 45 and xDirection < 0 then
	    x += maxx + 45
	end if

	if y > maxy + 40 and yDirection > 0 then
	    y := 0 - 40
	elsif y = 0 - 40 and yDirection < 0 then
	    y += maxy + 40
	end if

	delay (40)
	Draw.FillOval (x, y, size + 5, size + 5, black)

	if sqrt ( (x - shipx) ** 2 + (y - shipy) ** 2) < 45 and cheater =
		false then
	    shiphit := 1
	    exit
	end if

	exit when shiphit = 1

	if sqrt ( (x - laserx (1)) ** 2 + (y - lasery (1)) ** 2) < 50
		then
	    laserhit (1) := 1
	    blownup += 1
	    exit
	elsif sqrt ( (x - laserx (2)) ** 2 + (y - lasery (2)) ** 2) < 50
		then
	    laserhit (2) := 1
	    blownup += 1
	    exit
	elsif sqrt ( (x - laserx (3)) ** 2 + (y - lasery (3)) ** 2) < 50 then
	    laserhit (3) := 1
	    blownup += 1
	    exit
	elsif flashbomb = 1 then
	    exit
	elsif flashbomb = 2 then
	    exit
	end if
    end loop
    numberasteroids -= 1
    explode (x, y, 50)
    for i : 1 .. 3
	laserhit (i) := 0
    end for
    for i : 1 .. 4
	fork floatAsteroidSmall (x, y, 25)
    end for
end floatAsteroid

process laser (x, y, ang : int)
    var numlaser : int := activelaser
    laserx (numlaser) := shipx
    lasery (numlaser) := shipy
    var speed : int := 10
    var laserxdir : int := round (speed * cosd (ang))
    var laserydir : int := round (speed * sind (ang))
    for i : 1 .. 100
	exit when laserx (numlaser) >= maxx
	exit when lasery (numlaser) >= maxy
	exit when laserx (numlaser) <= 0
	exit when lasery (numlaser) <= 0
	laserx (numlaser) += laserxdir
	lasery (numlaser) += laserydir
	exit when shiphit = 1
	exit when laserhit (numlaser) = 1
	Draw.FillOval (laserx (numlaser), lasery (numlaser), 20, 20, black)
	Draw.FillOval (laserx (numlaser), lasery (numlaser), 3, 3, yellow)
	delay (30)
    end for
    Draw.FillOval (laserx (numlaser), lasery (numlaser), 20, 20, black)
    laserx (numlaser) := 9999
    lasery (numlaser) := 9999
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
	elsif ord (onekey) = 32 and activelaser < 3 then
	    activelaser += 1
	    fork lasersound
	    fork laser (shipx, shipy, angle)
	    delay (100)
	elsif onekey = "f" or onekey = "F" then
	    if flashbomb = 0 then
		fork flash
	    end if
	end if
	if angle < 0 then
	    angle += 360
	elsif angle >= 360 then
	    angle -= 360
	end if
	exit when shiphit = 1
    end loop
end moveship

process floatship
    shipx := maxx div 2
    shipy := maxy div 2
    loop
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
	if shipx > maxx + 20 and xspeed > 1 then
	    shipx := 0 - 20
	elsif shipx < 0 - 20 and xspeed < 1 then
	    shipx := maxx + 20
	end if
	if shipy > maxy + 20 and yspeed > 1 then
	    shipy := 0 - 20
	elsif shipy < 0 - 20 and yspeed < 1 then
	    shipy := maxy + 20
	end if
	shipy += yspeed
	shipx += xspeed
	Draw.FillOval (shipx, shipy, 35, 35, black)
	DrawShip (shipx, shipy, angle)
	delay (50)
    end loop
    fork screen
    explode (shipx, shipy, 100)
    shipx := 900
    shipy := 900
end floatship
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fork stars
loop
    ini
    colorback (black)
    cls
    Font.Draw ("Asteroids!", maxx div 2 - 200, maxy - 120, font1, brightred)
    Font.Draw ("Instructions", maxx div 2 - 110, maxy - 200, font2,
	brightred)
    Font.Draw ("Your ship has been stranded in an Asteroid field", maxx div
	2 - 270, maxy - 250, font3, brightgreen)
    Font.Draw ("You must protect your ship by destroying every Asteroid you can",






	maxx div 2 - 380, maxy - 280, font3, brightgreen)
    Font.Draw ("Use the arrow keys to move your ship and the spacebar to fire",






	maxx div 2 - 370, maxy - 310, font3, brightgreen)
    Font.Draw ("Press \"F\" to use a Flash Bomb you only have one so use it wisely",






	maxx div 2 - 380, maxy - 340, font3, brightgreen)
    Font.Draw ("Press any key to continue...", maxx div 2 - 150, maxy - 390,
	font3, brightgreen)
    Input.Pause
    loop
	cls
	Font.Draw ("Please Select Difficulity(1-5)", 0, maxy - 55, font2,
	    brightgreen)
	getch (difficulity)
	case difficulity of
	    label "1" :
		timedelay := 4000
		scoremult := 50
		exit
	    label "2" :
		timedelay := 3000
		scoremult := 100
		exit
	    label "3" :
		timedelay := 2000
		scoremult := 250
		exit
	    label "4" :
		timedelay := 1000
		scoremult := 500
		exit
	    label "5" :
		timedelay := 500
		scoremult := 1000
		exit
	    label "p" :
		cheatcount += 1
		if cheatcount = 5 then
		    cheater := true
		    fork boom
		end if
	    label :
		color (brightgreen)
		put "Please Enter a Valid Intiger"
		delay (500)


	end case
    end loop
    cls
    Font.Draw ("Get Ready!", maxx div 2 - 90, maxy div 2 - 20, font2,
	brightgreen)
    delay (500)
    Font.Draw ("Get Ready!.", maxx div 2 - 90, maxy div 2 - 20, font2,
	brightgreen)
    delay (500)
    Font.Draw ("Get Ready!..", maxx div 2 - 90, maxy div 2 - 20, font2,
	brightgreen)
    delay (500)
    Font.Draw ("Get Ready!...", maxx div 2 - 90, maxy div 2 - 20, font2,
	brightgreen)
    delay (500)
    cls
    fork score
    fork moveship
    fork floatship
    loop
	exit when shiphit = 1
	if numberasteroids < 6 then
	    fork floatAsteroid (50)
	end if
	delay (timedelay)
	timedelay -= 100
	if timedelay < 500 then
	    timedelay := 500
	end if
    end loop
    loop
	if screendone = 1 then
	    exit
	end if
    end loop
    delay (500)
    points := intstr (blownup * scoremult)
    Font.Draw ("GAME OVER", maxx div 2 - 210, maxy - 130, font1, brightred)
    Font.Draw ("You Blew up", maxx div 2 - 250, maxy - 200, font2,
	brightgreen)
    Font.Draw (intstr (blownup), maxx div 2 + 5, maxy - 200, font2,
	brightgreen)
    Font.Draw ("Asteroids!", maxx div 2 + 65, maxy - 200, font2, brightgreen)
    Font.Draw ("You scored", maxx div 2 - 250, maxy - 250, font2,
	brightgreen)
    Font.Draw (points, maxx div 2 - 5, maxy - 250, font2, brightgreen)
    Font.Draw ("Points!", maxx div 2 + 135, maxy - 250, font2, brightgreen)
    Font.Draw ("Play again?(Y/N)", maxx div 2 - 160, maxy - 350, font2,
	brightgreen)

    loop
	getch (playagain)
	if playagain = "n" or playagain = "N" or playagain = "Y" or
		playagain = "y" then
	    exit
	else
	    put "Please press \"Y\" or \"N\""
	end if
    end loop

    if playagain = "n" or playagain = "N" then
	exit
    end if

end loop
cls
Font.Draw ("Credits", maxx div 2 - 135, maxy - 110, font1, brightred)
Font.Draw ("Programming by Gabriel Devenyi", maxx div 2 - 190, maxy - 140,
    font3, brightgreen)
Font.Draw ("Concept by Gabriel Devenyi", maxx div 2 - 160, maxy - 170,
    font3, brightgreen)
Font.Draw ("Beta Testing by Matt Condren", maxx div 2 - 175, maxy - 200,
    font3, brightgreen)
Pic.ScreenLoad ("ace.bmp", maxx div 2 - 139, maxy div 2 - 50, picCopy)
delay (2000)
sysexit (0)

