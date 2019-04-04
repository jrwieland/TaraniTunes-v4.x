 --[[TaraniTunes
 Version 3.0
 This Advanced version is based off of the Original TaraniTunes
  http://github.com/GilDev/TaraniTunes
 By GilDev
 http://gildev.tk
It was agreed by GilDev and I that both versions of the script (the original
and this advanced version) would be available for users but hosted separately.

The new way music is loaded is thanks to the work of Tobias Ries aka Exean on Github https://github.com/exean

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
				  Set the trigger for timer3 in your Model Setup to match this switch
 				  BGMusic|| (pause) will automatically be placed on SF32.
	
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

-- logical switches --]]

local playSongLogicalSwitch   = 61 -- Logical switch that will play the current song
local nextSongLogicalSwitch   = 62 -- Logical switch that will set the current song to the next one
local prevSongLogicalSwitch   = 63 -- Logical switch that will set the current song to the previous one
local randomSongLogicalSwitch = 64 -- Logical switch that will set the current song to a random one

--Change the display items starting on line 246 to your individual liking.

--Locals
local specialFunctionId = 30 -- This special function will be reserved. SF31 and SF32 are also reserved
local errorOccured = false
local screenUpdate = true
local nextScreenUpdate = false
local playingSong = 1
local selection = 1
local songChanged = false
local resetDone = false
local mqTitle = 0

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

	loadScript(selectedPlaylistFile)() 

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
		mqTitle = -20
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
		function round(num, decimals)
		  local mult = 10^(decimals or 0)
		  return math.floor(num * mult + 0.5) / mult
		end
	local long=playlist[playingSong][3]--do not change this value it is the length of the current song playing
	local flight=model.getTimer(1).value--flight duration timer: 0=timer1, 1=timer2
	local upTime=model.getTimer(2).value--do not change this value it is how long the current song has played
	local datenow = getDateTime()		
	local timeText = datenow.hour .. ":" .. datenow.min
 	local batt=getValue("tx-voltage")
	
-- Calculate indexes for screen display
	if LCD_W == 212 then -- Taranis X9D Radio Larger text layout for 9X radios
	--Flight Time
		lcd.drawText(LCD_W/4+5, 1, "Flight =",MIDSIZE)
		lcd.drawTimer(LCD_W/4+69, 1, flight,MIDSIZE)
		
	--current time
		lcd.drawText(1,15,"Time= ".. timeText,PREC11)	
		elseif LCD_W == 128 then

-- Smaller text layout for QX7 radios	
	--Flight Time
		lcd.drawText(LCD_W/4+3, 1, "Flight =",SMLSIZE)
		lcd.drawTimer(LCD_W/2+9, 1, flight,SMLSIZE)
		
	--current time
		lcd.drawText(1,15, timeText,PREC1)	
	end
		
--[[ Change the layout of this portion to your desired screen look
	 Comment out any items that you do not want--]]
	
		-- Cell Voltage
	local Cell1=getValue("LCEL")--displays a custom telementry sensor (lowest cell)calculated from "cels" sensor
		lcd.drawNumber(LCD_W - 33, 10,Cell1*100, MIDSIZE+PREC2)
		lcd.drawText(LCD_W -8, 10,"v",MIDSIZE)

		-- Altitude
	local altN=getValue("Alt")--current altitude from telementry
	local altM=getValue("Alt+")--max altitude from telementry
		lcd.drawText(LCD_W/2-36, 15,"Alt= ",SMLSIZE)
		lcd.drawNumber(LCD_W/2-16, 15,altN,SMLSIZE)
		lcd.drawText(LCD_W/2, 15,"/",SMLSIZE)
		lcd.drawNumber(LCD_W/2+7, 15,altM,SMLSIZE)	
			
		--Receiver battery
		lcd.drawFilledRectangle(3, 1, 4, 1)
		lcd.drawFilledRectangle(2, 2, 6, 11)				
		lcd.drawText(11, 0,round(batt,1), MIDSIZE+PREC1)
			
		--rssi
		lcd.drawText(LCD_W-8-(string.len(""..getValue("RSSI"))*7),1, getValue("RSSI"))
		lcd.drawFilledRectangle(LCD_W-2, 10, 2, 0)
		lcd.drawLine(LCD_W-3,8,LCD_W,8, SOLID, FORCE)
		lcd.drawLine(LCD_W-4,6,LCD_W,6, SOLID, FORCE)
		lcd.drawLine(LCD_W-5,4,LCD_W,4, SOLID, FORCE)
		lcd.drawLine(LCD_W-6,2,LCD_W,2, SOLID, FORCE)
		lcd.drawLine(LCD_W-8,0,LCD_W,0, SOLID, FORCE)
				
		local y = 23;
		
		--title background
		lcd.drawFilledRectangle(0,y-1,LCD_W,8)
		
		--Playlist title
		lcd.drawText((LCD_W / 2)-((string.len(title)/2)*5), y, title, SMLSIZE+INVERS)
		
		--Timer
		lcd.drawTimer(1, y, upTime, SMLSIZE+INVERS)
		lcd.drawTimer(LCD_W-22, y, long, SMLSIZE+INVERS)
		
		-- Progressbar
		lcd.drawRectangle(0, y+8, LCD_W, 3, SOLID, FORCE)
		lcd.drawLine(0, y+9, (LCD_W - 1)*(upTime/long), y+9, SOLID, FORCE)

		-- Song selector
		if selection == 1 then
			if playlist[selection] then lcd.drawText(1, y+13, string.char(126) .. playlist[selection][1], SMLSIZE+INVERS) end
			if playlist[selection + 1] then lcd.drawText(6, y+20, playlist[selection + 1][1], SMLSIZE) end
			if playlist[selection + 2] then lcd.drawText(6, y+27, playlist[selection + 2][1], SMLSIZE) end
			if playlist[selection + 3] then lcd.drawText(6, y+34, playlist[selection + 3][1], SMLSIZE) end
		else		
			if playlist[selection - 1] then lcd.drawText(6, y+13, playlist[selection - 1][1], SMLSIZE) end
			if playlist[selection] then lcd.drawText(1, y+20, string.char(126) .. playlist[selection][1], SMLSIZE+INVERS) end
			if playlist[selection + 1] then lcd.drawText(6, y+27, playlist[selection + 1][1], SMLSIZE) end
			if playlist[selection + 2] then lcd.drawText(6, y+34, playlist[selection + 2][1], SMLSIZE) end
		end
		
		-- Print error
		if errorOccured then
			yLine = {18, 26, 34, 42, 50}
			for i = 1, #errorStrings do
				lcd.drawText(1, yLine[i], errorStrings[i])
			end
			return
		end
		
	end
end
return {run = run, background = background, init = init}
