% Code for a programming competition simulating a "water baloon fight" between two schools


var id := Window.Open ("fullscreen,nocursor")
%For Turing 4.0 Beta
%var id := Window.Open ("graphics:max,max,nocursor")
%%%%%%%
var currentx, currenty : int := 200
var timedone : real := 0
var realx, realy : real := 0
var impact : boolean := false
var velocity, angle : real := 0

process shoot
    %Music.PlayFile ("laser.wav")
end shoot

process boom
    %Music.PlayFile ("boom.wav")
end boom

procedure screen
    colorback (11)
    cls
    Draw.Line (0, 200, 1000, 200, black)
    Draw.FillBox (0, 200, 200, 260, black)
    Draw.Line (400, 200, 400, 260, black)
    Draw.Line (600, 200, 600, 260, black)
    Draw.FillBox (800, 200, 1000, 260, black)
    Draw.FillBox (0, 0, maxx, 199, green)
    Draw.FillOval (200, 200, 5, 5, brightgreen)
end screen

procedure fire (vel, ang : real)
    impact := false
    timedone := 0
    loop
	timedone += 0.01
	realx := (vel * cosd (ang)) * timedone
	realy := (vel * sind (ang)) * timedone - 0.5 * 9.8 * timedone ** 2

	currentx := round (200 + realx * 20)
	currenty := round (200 + realy * 20)

	if currentx >= 200 and currentx <= 400 and currenty <= 199 then
	    put "It Hit in Our Courtyard!"
	    impact := true
	    exit
	elsif currentx >= 395 and currentx <= 405 and currenty >= 200 and
		currenty <= 260 then
	    put "It Hit our Fence!"
	    impact := true
	    exit
	elsif currentx >= 400 and currentx <= 600 and currenty <= 200 then
	    put "It Hit the Street!"
	    impact := true
	    exit
	elsif currentx >= 595 and currentx <= 605 and currenty >= 200 and
		currenty <= 260 then
	    put "It Hit their Fence!"
	    impact := true
	    exit
	elsif currentx >= 600 and currentx <= 800 and currenty <= 200 then
	    put "It Hit their Courtyard! Good Work!"
	    impact := true
	    exit
	elsif currentx >= 800 and currentx <= 1000 and currenty >= 200 and
		currenty <= 260 then
	    put "It Hit their School!"
	    impact := true
	    exit
	else
	    Draw.FillOval (currentx, currenty, 5, 5, brightred)
	    delay (10)
	    Draw.FillOval (currentx, currenty, 5, 5, 11)
	end if
    end loop
    fork boom
    for i : 1 .. 10
	Draw.FillOval (currentx, currenty, i, i, brightred)
    end for
    delay (100)
    Draw.FillOval (currentx, currenty, 10, 10, 11)
end fire

loop
    screen
    put "Please Enter the Inital Velocity: " ..
    get velocity
    put "Please Enter the Inital Angle: " ..
    get angle
    fork shoot
    fire (velocity, angle)
    delay (1000)
end loop

