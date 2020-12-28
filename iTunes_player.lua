--[[
TaraniTunes
 Version 3.0.3
 This Advanced version is based off of the Original TaraniTunes
  http://github.com/GilDev/TaraniTunes
 By GilDev http://gildev.tk
 
It was agreed by GilDev and I that both versions of the script (the original
and this advanced version) would be available for users but hosted separately.
The majority of the new enhancements to the playlist selection are due to the work of Exean (https://github.com/exean)

--Main Play Music File--

----Setting up the Transmitter----
!!You NEED to use logical switches to manipulate TaraniTunes!!
 If you use trims for changing songs (and I recommend you do),
 you need to deactivate the "real" trim functions on the trims switches you plan
 to use for manipulating TaraniTunes.
 To do this, go into "FLIGHT MODES" configuration, go to each flight mode
 you use for your model and set the appropriate "Trims" value to "--"
 (Rudder trims are used in the example).
 
----Additional Functions/Information-----
Since everything in the OpenTX is user programmable
You need to enter the switch number to "Pause" the song
The program works using a single 3 position switch it will not function as designed using multiple switches!

Here are the numbers for the switches

SA↑ 1, SA- 2, SA↓ 3, 
SB↑ 4, SB- 5, SB↓ 6, 
SC↑ 7, SC- 8, SC↓ 9,
SD↑ 10, SD- 11, SD↓ 12, 
SG↑ 19, SG- 20, SG↓ 21 

Replace the value in "pause" (below)with the appropriate number --]]

local pause = 5
 
--[[Enter the switch number you will used to "Pause" the music 
Set the trigger for timer3 in your Model Setup to invert this switch position (pause = SB- then set timer = !SB-)
The timer will continue to run in either the play or random switch position.
 				  
Here is a sample setup of the logical switches (LS61 thru LS64) you need to setup based on these inputs
  SWITCH  Func  V1	  V2
  LS60 	   OR	LS61  LS64 Plays the Music If The SB switch is in any Position but SB-
  LS61 	   OR	SB↓	  SB-  Plays the music and keeps song selected if paused 
  LS62	   OR	tRl	  tRl  Rudder trim left] plays previous song **XLITE Use Aileron or Elevator Trims
  LS63	   OR	tRr	  tRr  Rudder trim right plays next song**XLITE Use Aileron or Elevator Trims
  LS64	   OR	SB↑	  SB↑  Selects a random song mix from your playlist
  
**Using the Example above
SB↑  Selects a "Random" song plays it and then pick another "Random" song from your playlist when the song is over.
SB-  "Pauses" the current song and timer3
SB↓  "Plays" the selected /current song after it is over the next song in the playlist will play

--Change the display items starting on line 265 to your individual liking. --]]

-- logical switches 

local playSongLogicalSwitch   = 60 
local prevSongLogicalSwitch   = 62
local nextSongLogicalSwitch   = 63
local randomSongLogicalSwitch = 64

--Locals
local specialFunctionId = 30 -- This special function will be reserved. SF31 is also reserved
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

	-- Calculate indexes Special funtion play value for LS positions
	shPresent =getValue("sh")
	specialFunctionId  = specialFunctionId - 1
		playSongSwitchId = 53 + playSongLogicalSwitch
		model.setLogicalSwitch(58,{func=3,v1=230,v2=playlist[playingSong][3]})
	end
	
nextSongSwitchId   = getFieldInfo("ls" .. nextSongLogicalSwitch).id
prevSongSwitchId   = getFieldInfo("ls" .. prevSongLogicalSwitch).id
randomSongSwitchId = getFieldInfo("ls" .. randomSongLogicalSwitch).id

nextScreenUpdate = true
screenUpdate = true
songChanged = true

--background
local function background()
--Pause function
	model.setCustomFunction(30,{switch=pause,func = 17})
	
--Timer3 function after 1st song
	model.setLogicalSwitch(58,{func=3,v1=230,v2=playlist[playingSong][3]})
		
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
		 if getValue(randomSongSwitchId) > 0 then
			playingSong = math.random (1, #playlist)
			model.setTimer(2,{value=0})
			songChanged = true
			screenUpdate = true
			nextScreenUpdate = true	
		 else
			model.setTimer(2,{value=0})
			nextSongSwitchPressed = true
			nextScreenUpdate = true
			songChanged = true
			screenUpdate = true
			if playingSong == #playlist then
			   playingSong = 1	
			else
			   playingSong = playingSong + 1
		  end
		end
	   end
	end
	
-- Next song
	if getValue(nextSongSwitchId) > 0 then
		if not nextSongSwitchPressed then
		if getValue(randomSongSwitchId) > 0 then
			playingSong = math.random (1, #playlist)
			model.setTimer(2,{value=0})
			songChanged = true
			screenUpdate = true
			nextScreenUpdate = true	
			else
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
		end
	else
		nextSongSwitchPressed = false
	end

-- Previous song
	if getValue(prevSongSwitchId) > 0 then
		if not prevSongSwitchPressed then
		if getValue(randomSongSwitchId) > 0 then
			playingSong = math.random (1, #playlist)
			model.setTimer(2,{value=0})
			songChanged = true
			screenUpdate = true
			nextScreenUpdate = true	
			else
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
		end
	else
		prevSongSwitchPressed = false
	end
	end

--event controls
local function run(event)

	-- INPUT HANDLING --
	if (event == EVT_MINUS_FIRST) then
		if selection == #playlist then
			selection = 1 else
			selection = selection + 1
		end
		screenUpdate = true
		elseif (event == EVT_PLUS_FIRST or event == EVT_PLUS_RPT or event == EVT_UP_BREAK) then
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
	  return math.floor(num * mult + .5) / mult end
	  
	local long=playlist[playingSong][3]--do not change this value it is the length of the current song playing
	local fly=model.getTimer(1).value--flight duration timer: 0=timer1, 1=timer2
	local upTime=model.getTimer(2).value--do not change this value it is how long the current song has played
	local datenow = getDateTime()		
	local timemins = (string.format("%02d",datenow.min))
 	local batt = getValue("tx-voltage")
	
--[[ Change the layout of this portion to your desired screen look
	 Comment out any items that you do not want--]]

	--Transmitter battery
		lcd.drawText(2, 2,"TX "..round(batt,1).."v",SMLSIZE)
		
   --Switch position
	 local battsw = getValue('se')
	 if battsw == -1024 then 
	 	lcd.drawText(65,2,"REG",4)
	 	lcd.drawSwitch(LCD_W/3-25,2,13)elseif
	 	battsw == 0 then
	 	lcd.drawSwitch(LCD_W/3-25,2,14)
	 	lcd.drawText(65,2,"MID",4)else
	 	lcd.drawSwitch(LCD_W/3-25,2,15)
	 	lcd.drawText(65,2,"XXL",4)
	 	end
		lcd.drawText(LCD_W/3+15, 2, "FLIGHT BATTERY",4)
		
	--Flight Time
		
		lcd.drawTimer(LCD_W-33, 0, fly, 2+MIDSIZE)
	
	-- Altitude
	local altN=getValue("Alt")--current altitude from telementry
	local altM=getValue("Alt+")--max altitude from telementry
		lcd.drawText(22,12,"HEIGHT= ",SMLSIZE)
		lcd.drawChannel(58,12,"Alt",SMLSIZE)
		lcd.drawText(LCD_W/3+23, 12,"// Max",SMLSIZE)
		lcd.drawChannel(LCD_W/2+18,12,"Alt+",SMLSIZE+2)
				
	--current time
		lcd.drawText(1,21,"TIME= "..datenow.hour12..":"..timemins.." "..datenow.suffix,SMLSIZE)		    
			
	--rssi
		lcd.drawText(LCD_W/2-5,21,"RX SIGNAL "..getValue("RSSI"),SMLSIZE)
		
	-- Cell Voltage
	local Cell1=getValue("LCEL")--displays a custom telementry sensor (lowest cell)calculated from "cels" sensor
		lcd.drawNumber(LCD_W -35, 16,Cell1*100, MIDSIZE+PREC2)
		lcd.drawText(LCD_W -10, 16,"v",MIDSIZE)
					
	local y = 23;
		
		--title background
		lcd.drawFilledRectangle(0,y+6,LCD_W,8,GREY_DEFAULT)
		
		--Playlist title
		lcd.drawText((LCD_W / 2)-((string.len(title)/2)*5), y+7, title, SMLSIZE+INVERS)
		
		--Timer
		lcd.drawTimer(1, y+7, upTime, SMLSIZE+INVERS)
		lcd.drawTimer(LCD_W-25, y+7, long, SMLSIZE+INVERS)
		
		-- Progressbar
		lcd.drawRectangle(0, y+14, LCD_W, 3, SOLID, FORCE)
		lcd.drawLine(0, y+15, (LCD_W - 1)*(upTime/long), y+16, SOLID, FORCE)

		-- Song selector
		if selection == 1 then
			if playlist[selection] then lcd.drawText(1, y+18, string.char(126) .. playlist[selection][1], SMLSIZE+INVERS) end
			if playlist[selection + 1] then lcd.drawText(6, y+25, playlist[selection + 1][1], SMLSIZE) end
			if playlist[selection + 2] then lcd.drawText(6, y+33, playlist[selection + 2][1], SMLSIZE) end
		else		
			if playlist[selection - 1] then lcd.drawText(6, y+18, playlist[selection - 1][1], SMLSIZE) end
			if playlist[selection] then lcd.drawText(1, y+25, string.char(126) .. playlist[selection][1], SMLSIZE+INVERS) end
			if playlist[selection + 1] then lcd.drawText(6, y+33, playlist[selection + 1][1], SMLSIZE) end
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
