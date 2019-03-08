 --[[TaraniTunes
 Version 2.2.1
 This Advanced version is based off of the Original TaraniTunes
  http://github.com/GilDev/TaraniTunes
 By GilDev
 http://gildev.tk
It was agreed by GilDev and I that both versions of the script (the original
and this advanced version) would be available for users but hosted separately.

--Main Play Music File--

----Setting up the Transmitter----

!!You NEED to use logical switches to manipulate TaraniTunes!!

 WARNING: If you use trims for changing songs (and I recommend you do),
 you need to deactivate the "real" trim functions on the trims switches you plan
 to use for manipulating TaraniTunes.

 To do this, go into "FLIGHT MODES" configuration, go to each flight mode
 you use for your model and set the appropriate "Trims" value to "--"
 (Rudder trims are used in the example).

----Additional Functions/Information-----
Since everything in the OpenTX is user programmable
You need to enter the switch number to "Pause" the song and you need to enter the switch number for a "Random" Song
The program works using a single 3 position switch if you try and change it to multiple switches the program will not work properly!

Here are the numbers for the switches
Replace the value in "pause" and "random"(below)with the appropriate number

SA↑=1, SA-=2, SA↓=3, 
SB↑=4, SB-=5, SB↓=6, 
SC↑=7, SC-=8, SC↓=9,
SD↑=10, SD-=11, SD↓=12, 
SE↑=13, SE-=14, SE↓=15 
--]]
local random =4 --Enter the switch number you will used to "select a random song" SB↑=4 in this example

local pause =6  --[[Enter the switch number you will used to "Pause" the music SB↓=6
				--Set the trigger for timer3 in your Model Setup to match this switch

Here is a sample setup of the logical switches (LS61 thru LS64) you need to setup based on these inputs

  SWITCH  Func  V1	V2
  LS61 	   OR	SB-	SB↓ (**Explanation under this example)
  LS62	   OR	tRr	tRr (LS62 [Rudder trim right] plays next song)
  LS63	   OR	tRl	tRl (LS63 [Rudder trim left plays previous song)
  LS64	   OR	SB↑	SB↑ (LS64 selects a random song )

**Using the Example above
SB↑ will "Select" a "Random" song and reset timer3 when the switch is returned to SB- it will play
SB- will "Play" the music & timer 3 will advance
SB↓ will "Pause" the song and Timer3

Make sure that the Logical Switch values match your selection above

LS60 will list the song length of the currently playing song
	This is updated automatically; you do not have to enter any values.

BGMusic|| (pause) will be placed on SF32.
	This will be automatically inserted based on the information you listed above.

The locations/directory of your playlists starts on line 103 below
Change the display items starting on line 261 to your individual needs

-- locals--]]
local specialFunctionId = 30 -- This special function will be reserved. SF31 and SF32 are also reserved
local playSongLogicalSwitch   = 61 -- Logical switch that will play the current song
local nextSongLogicalSwitch   = 62 -- Logical switch that will set the current song to the next one
local prevSongLogicalSwitch   = 63 -- Logical switch that will set the current song to the previous one
local randomSongLogicalSwitch = 64 -- Logical switch that will set the current song to a random one
local errorOccured = false
local screenUpdate = true
local nextScreenUpdate = false
local playingSong = 1
local selection = 1
local songChanged = false
local resetDone = false

 -- control functions
local function error(strings)
	errorStrings = strings
	errorOccured = true
end

function playSong()
	model.setCustomFunction(specialFunctionId,{switch = playSongSwitchId,func = 16,
			name = playlist[playingSong][2]})
end

function resetSong()
	model.setCustomFunction(specialFunctionId,{switch = -playSongSwitchId})
end

-- set initial variables
nextSongSwitchPressed   = false;
prevSongSwitchPressed   = false;
randomSongSwitchPressed = false;

--Initiate
local function init()
--[[Playlists are changed using the S2 Pot values from 1000 to -1000
As many times as you want to divide the switch is the limit to the number
of playlists available.
This file has 8 separate playlists  --]]

local set=getValue("s2")  --s2 is the selector for the playlists  **Must match the selector in iTunes.lua**
  if set > 750 then  --value of s2 switch position to select this file **This is the upper limit of the switch **Each additional selection moves towards center
  		loadScript("/SOUNDS/lists/3dflying/playlist")()--location of the playlist file **Notice the directory should be named somthing that relates to the music "without spaces"
  elseif set > 500 then
 		loadScript("/SOUNDS/lists/competition/playlist")()--all lua files must be named "playlist" do not include the .lua extension
  elseif set > 250 then
  		loadScript("/SOUNDS/lists/cruising/playlist")()
  elseif set >= 0 then
  		loadScript("/SOUNDS/lists/demo/playlist")()
  elseif set < -750 then   -- this is the lower limit of the switch  **Each additional selection moves towards center
  		loadScript("/SOUNDS/lists/flights/playlist")()
  elseif set < -500 then
 		loadScript("/SOUNDS/lists/practice/playlist")()
  elseif set < -250 then
  		loadScript("/SOUNDS/lists/racing/playlist")()
  else
  		loadScript("/SOUNDS/lists/relaxing/playlist")()end

	-- Calculate indexes
	specialFunctionId  = specialFunctionId - 1
	if LCD_W == 212 then -- if Taranis X9D
		playSongSwitchId = 50 + playSongLogicalSwitch
		model.setLogicalSwitch(59,{func=3,v1=230,v2=playlist[playingSong][3]})
	else -- if Taranis Q X7
		playSongSwitchId = 38 + playSongLogicalSwitch
		model.setLogicalSwitch(59,{func=3,v1=225,v2=playlist[playingSong][3]})
	end

	nextSongSwitchId   = getFieldInfo("ls" .. nextSongLogicalSwitch).id
	prevSongSwitchId   = getFieldInfo("ls" .. prevSongLogicalSwitch).id
	randomSongSwitchId = getFieldInfo("ls" .. randomSongLogicalSwitch).id

	nextScreenUpdate = true
	screenUpdate = true
	songChanged = true
end

--background
local function background()
	model.setCustomFunction(30,{switch=pause,func = 17})
	model.setCustomFunction(31,{switch=random,func=3,value=2,active=1})
	if resetDone then
		playSong()
		resetDone = false
	end

	if songChanged then
		resetSong()
		songChanged = false
		resetDone = true
	end

-- Song Over
	if model.getTimer(2).value >= playlist[playingSong][3] then
		if not nextSongSwitchPressed then
			model.setTimer(2,{value=0})
			nextSongSwitchPressed = true
			nextScreenUpdate = true
			songChanged = true
			screenUpdate = true
			if playingSong == #playlist then
				playingSong = 1	else
				playingSong = playingSong + 1
			end	else
		nextSongSwitchPressed = false
		end
	end

-- Next song
	if getValue(nextSongSwitchId) > 0 then
		if not nextSongSwitchPressed then
			nextSongSwitchPressed = true
			nextScreenUpdate = true
			songChanged = true
			screenUpdate = true
			if playingSong == #playlist then
				playingSong = 1
				model.setTimer(2,{value=0})
			else
				playingSong = playingSong + 1
				model.setTimer(2,{value=0})
			end
		end
	else
		nextSongSwitchPressed = false
	end

-- Previous song
	if getValue(prevSongSwitchId) > 0 then
		if not prevSongSwitchPressed then
			model.setTimer(2,{value=0})
			prevSongSwitchPressed = true
			nextScreenUpdate = true
			songChanged = true
			screenUpdate = true
			if playingSong == 1 then
				playingSong = #playlist
			else
				playingSong = playingSong - 1
			end
		end
	else
		prevSongSwitchPressed = false
	end

-- Random song
	if getValue(randomSongSwitchId) > 0 then
		if not randomSongSwitchPressed then
			randomSongSwitchPressed = true
			playingSong = math.random (1, #playlist)
			songChanged = true
			screenUpdate = true
			nextScreenUpdate = true
			end
	else
		randomSongSwitchPressed = false
	end
end

--event controls
local function run(event)

	-- INPUT HANDLING --
	if (event == EVT_ROT_RIGHT or event == EVT_MINUS_FIRST or event == EVT_MINUS_RPT) then
		if selection == #playlist then
			selection = 1 else
			selection = selection + 1
				end

		screenUpdate = true
	elseif (event == EVT_ROT_LEFT or event == EVT_PLUS_FIRST or event == EVT_PLUS_RPT) then
		if selection == 1 then
			selection = #playlist else
			selection = selection - 1
		end

		screenUpdate = true
	elseif event == EVT_ROT_BREAK or event == EVT_ENTER_BREAK then
		playingSong = selection
		songChanged = true
		screenUpdate = true
		model.setTimer(2,{value=0})
	elseif nextScreenUpdate then
		selection = playingSong
		nextScreenUpdate = false
		model.setTimer(2,{value=0})
		end

-- DRAWING --
	if screenUpdate or event == 191 then
		screenUpdate = true

		lcd.clear();
	local long=playlist[playingSong][3]--do not change this value it is the length of the current song playing
	local flight=model.getTimer(1).value--flight duration timer: 0=timer1, 1=timer2
	local upTime=model.getTimer(2).value--do not change this value it is how long the current song has played
	local Cell1=getValue("LCEL")--displays a custom telementry sensor (lowest cell)calculated from "cels" sensor
	local altN=getValue("Alt")--current altitude from telementry
	local altM=getValue("Alt+")--max altitude from telementry

		-- Calculate indexes for screen display
	if LCD_W == 212 then -- if Taranis X9D

		-- Title 9XD
		lcd.drawText(1, 1, "Flight =",MIDSIZE)
		lcd.drawTimer(65, 1, flight,MIDSIZE)
		lcd.drawText(1, 17,"Max Alt=",SMLSIZE)
		lcd.drawNumber(40, 17,altM,SMLSIZE)
		lcd.drawText(55,17," / Alt=",SMLSIZE)
		lcd.drawNumber(86, 17,altN,SMLSIZE)
		lcd.drawText(110, 8, "Played", SMLSIZE)
		lcd.drawTimer(112, 17, upTime, SMLSIZE)
		lcd.drawText(139, 17, string.char(62),SMLSIZE)
		lcd.drawText(145, 8, "Song", SMLSIZE)
		lcd.drawTimer(144, 17, long, SMLSIZE)
		lcd.drawNumber(LCD_W - 35, 1,Cell1*100, MIDSIZE+PREC2)
		lcd.drawText(LCD_W -10, 1,"v", MIDSIZE)

	else -- Title if Taranis Q X7
		lcd.drawText(1,1,"Alt=",SMLSIZE)
		lcd.drawNumber(20, 1,altN,SMLSIZE)
		lcd.drawText(35,1,"/Max=",SMLSIZE)
		lcd.drawNumber(62, 1,altM,SMLSIZE)
		lcd.drawText(1, 8, "Played", SMLSIZE)
		lcd.drawTimer(5, 17, upTime, SMLSIZE)
		lcd.drawText(30, 17, string.char(62),SMLSIZE)
		lcd.drawText(38, 8, "Song", SMLSIZE)
		lcd.drawTimer(38, 17, long, SMLSIZE)
		lcd.drawNumber(LCD_W - 35, 1,Cell1*100, MIDSIZE+PREC2)
		lcd.drawText(LCD_W -10, 1,"v", MIDSIZE)
		lcd.drawText(LCD_W -60, 17, "Flight =",SMLSIZE)
		lcd.drawTimer(LCD_W -23, 17, flight,SMLSIZE)
	end
		-- Separator
		lcd.drawLine(0, 24, LCD_W - 1, 24, SOLID, FORCE)

		-- Print error
		if errorOccured then
			yLine = {18, 26, 34, 42, 50}
			for i = 1, #errorStrings do
				lcd.drawText(1, yLine[i], errorStrings[i])
			end
			return
		end

		-- Now playing
		lcd.drawText(1,26, string.char(62) .. playlist[playingSong][1],0)

		-- Separator
		lcd.drawLine(0, 33, LCD_W - 1, 33, DOTTED, FORCE)

		-- Song selector
			if playlist[selection - 1] then lcd.drawText(6, 35, playlist[selection - 1][1], SMLSIZE) end
		if playlist[selection] then lcd.drawText(1, 42, string.char(126) .. playlist[selection][1], SMLSIZE+INVERS) end
		if playlist[selection + 1] then lcd.drawText(6, 49, playlist[selection + 1][1], SMLSIZE) end
		if playlist[selection + 2] then lcd.drawText(6, 56, playlist[selection + 2][1], SMLSIZE) end

	end
end
return {run = run, background = background, init = init}
