---- #########################################################################
-----# TaraniTunes v.4.0                                                     #
---- # License GPLv3: http://www.gnu.org/licenses/gpl-3.0.html				 #
---- #                                                                       #
---- # This program is free software; you can redistribute it and/or modify  #
---- # it under the terms of the GNU General Public License version 3 as     #
---- # published by the Free Software Foundation.                            #
---- #                                                                       #
---- # This program is distributed in the hope that it will be useful        #
---- # but WITHOUT ANY WARRANTY; without even the implied warranty of        #
---- # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
---- # GNU General Public License for more details.                          #
---- #                                                                       #
---- #########################################################################
--Locals
local playingSong = 1
local pause = 5 --SF swicth where the Pause will be located
local specialFunctionId = 61 -- This special function will be reserved to play the music.
local errorOccured = false
local screenUpdate = true
local nextScreenUpdate = false
local songChanged = false
local resetDone = false
local mqTitle = 0


--Playlists folder names
local songList=
{"3dflying",
"demo" ,
"cruising",
"garage",
} 


--logical switches used for play controls
local playSongLogicalSwitch   = 60 
local prevSongLogicalSwitch   = 62
local nextSongLogicalSwitch   = 63
local randomSongLogicalSwitch = 64

nextSongSwitchId   = getFieldInfo("ls" .. nextSongLogicalSwitch).id
prevSongSwitchId   = getFieldInfo("ls" .. prevSongLogicalSwitch).id
randomSongSwitchId = getFieldInfo("ls" .. randomSongLogicalSwitch).id

--Bitmaps
local logo = Bitmap.open("/THEMES/Darkblue/topmenu_opentx.bmp")

--Options
local options = {
  { "Use dflt clrs", BOOL, 1 },
  { "Shadow", BOOL, 0 }
}

local function create(zone, options)
  local tunes = { zone=zone, options=options, counter=0 }
     aircraft = Bitmap.open("/IMAGES/" .. model.getInfo().bitmap)
     model.setGlobalVariable(8,0,1)
     return tunes
end

-- control functions
local function error(strings)
	errorStrings = strings
	errorOccured = true
end
	
local function update(tunes, options)
 bubba.options = options
 end

local function background(tunes)
local set1=getValue(nextSectionSwitchId)
	
 end
 
function refresh(tunes) 
--load Playlist selection
	if model.getGlobalVariable(8,0) == #songList+1 then
		set2 = songList[1] 
		model.setGlobalVariable(8,0,1)
	else
	if model.getGlobalVariable(8,0) == 0 then
		model.setGlobalVariable(8,0,#songList)
		set2 = #songList 
		else
		songChanged = true 
		screenUpdate = true
		set2 = songList[model.getGlobalVariable(8,0)]
		end end
		loadScript("/SOUNDS/lists/"..set2.."/playlist.lua")()
	
-- set Special Functions and Logical Switches
  	model.setCustomFunction(specialFunctionId,{switch = 132,func = 16,name = playlist[playingSong][2]})
	model.setCustomFunction(62,{switch = pause,func = 17})
    model.setLogicalSwitch(59,{func=9,v1=133, v2=136})
    model.setLogicalSwitch(60,{func=9,v1=4, v2=5})
    model.setLogicalSwitch(61,{func=9,v1=71, v2=71})
    model.setLogicalSwitch(62,{func=9,v1=72, v2=72})
    model.setLogicalSwitch(63,{func=9,v1=6, v2=6})
  
--song over
local long=playlist[playingSong][3]
	if model.getTimer(2).value >= long then
		if playingSong == #playlist then
			playingSong = 1	
			model.setCustomFunction(specialFunctionId,{name = playlist[playingSong][2]})
			 model.setTimer(2,{value=0})
		 else
		    playingSong = playingSong + 1
		    model.setCustomFunction(specialFunctionId,{name = playlist[playingSong][2]})
			model.setTimer(2,{value=0})
		end
	end
	
-- Next song
	if getValue(nextSongSwitchId) >= 1 then
		if not nextSongSwitchPressed then
			nextScreenUpdate = true
			songChanged = true
			screenUpdate = true
			if playingSong == #playlist then
				playingSong = 1	
				model.setCustomFunction(specialFunctionId,{name = playlist[playingSong][2]})
				model.setTimer(2,{value=0})
			 else
			 	playingSong = playingSong + 1
			    model.setCustomFunction(specialFunctionId,{name = playlist[playingSong][2]})
				model.setTimer(2,{value=0})
			end
		else
		nextSongSwitchPressed = false
		end
	end	
		
-- Previous song
	if getValue(prevSongSwitchId) >= 4 then
		if not prevSongSwitchPressed then
			prevSongSwitchPressed = true
			nextScreenUpdate = true
			songChanged = true
			screenUpdate = true
			if playingSong == 1 then
				playingSong = #playlist	
				model.setCustomFunction(specialFunctionId,{name = playlist[playingSong][2]})
				model.setTimer(2,{value=0})
			 else
			    playingSong = playingSong - 1
			    model.setCustomFunction(specialFunctionId,{name = playlist[playingSong][2]})
				model.setTimer(2,{value=0})
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
  			model.setCustomFunction(specialFunctionId,{name = playlist[playingSong][2]})
			model.setTimer(2,{value=0})
		end																	   
		else
		randomSongSwitchPressed = false	
	end
	
--Display
	function round(num, decimals)
	  local mult = 10^(decimals or 0)
	  return math.floor(num * mult + .5) / mult 
	 end
	  
	--Current time, OpenTX Version & Model Information
		local datenow = getDateTime()		
		local timemins = (string.format("%02d",datenow.min))
		lcd.drawText(8,30,datenow.hour12..":"..timemins.." "..datenow.suffix,INVERS)	
		local ver = getVersion() --OpenTX Version
		lcd.drawBitmap(logo,8,5,75)
		lcd.drawText(35,7,ver)
		lcd.drawText(170,50, model.getInfo().name, MIDSIZE)--adjust for right look
		lcd.drawBitmap(aircraft,180,60,90)--adjust location and % for right look
	
	--Transmitter battery
		local batt = getValue("tx-voltage")
		lcd.drawText(8, 51,"TX Batt "..round(batt,1).."v")
 
	 -- Flight Battery Loaded
	 --[[ I use different capacity batteries the timers are
	 	  adjusted using SF depending on the battery i'm flying ]]--
		lcd.drawFilledRectangle(8,73,130,2)
	 	local battsw = getValue('se')
	 	if battsw == -1024 then 
	 		lcd.drawText(65,75,"REG")
	 		lcd.drawSwitch(8,75,13)else
	 		if battsw == 0 then
	 			lcd.drawSwitch(30,75,14)
	 			lcd.drawText(65,75,"MED") else
	 			lcd.drawSwitch(8,75,15)
	 			lcd.drawText(65,75,"XXL")
	 		end 
	 	end
	 		lcd.drawText(10, 95, "Battery Loaded")
			lcd.drawFilledRectangle(8,116,130,2)
	
	 -- Flight Mode
		lcd.drawFilledRectangle(380,60,90,2)
		lcd.drawFilledRectangle(380,105,90,2)
		local fmno, fmname = getFlightMode()
		if fmname == "" then
			fmname = "FM".. fmno
			lcd.drawText(410, 63, fmname)else
			lcd.drawText(410, 63, "FM"..fmno)
			lcd.drawText(380,83, fmname)
		end
			
	--Flight Time
		local fly=model.getTimer(1).value  --flight duration timer: 0=timer1, 1=timer2
		lcd.drawText(384, 4, "Flight Time")
		lcd.drawTimer(400, 26, fly, 2+MIDSIZE)	
	
	-- Cell Voltage
		lcd.drawText(372, 104, "Lipo Cell",MIDSIZE)
		lcd.drawChannel(380, 132,"LCEL", DBLSIZE+PREC2+INVERS) --displays a custom telementry sensor (lowest cell)calculated from "cels" sensor
	
	--rssi
		lcd.drawText(8,122,"RSSI Sig  "..getValue("RSSI").." / ")
		lcd.drawText(125,122,getValue("RSSI-").." MIN")
		
	-- Altitude
		lcd.drawText(8,143,"HEIGHT= ")
		lcd.drawChannel(80,143,"Alt")
		lcd.drawText(130, 143,"//Max")
		lcd.drawChannel(185,143,"Alt+",2)	
		
	--Tementry separator bar
		local y = 185
		lcd.drawFilledRectangle(6,y-18,462,6,GREY_DEFAULT)
	
	--Music
	-- Progressbar 
		local upTime=model.getTimer(2).value--do not change this value it is how long the current song has played
		local k = math.floor((upTime/long)*40)*10
		lcd.drawTimer(7, y-10, upTime, SMLSIZE+INVERS)
		lcd.drawTimer(434,y-10, long, SMLSIZE+INVERS)
		lcd.setColor(CUSTOM_COLOR,lcd.RGB(0,100,0))
		lcd.drawFilledRectangle(44,y-10,k,16,CUSTOM_COLOR)
		
	--music display
		local selection=playingSong
		lcd.drawText(90, y+4, "Selected Playlist >>",SMLSIZE)
		lcd.drawText(220, y+4, title, SMLSIZE)
		if selection == #playlist then
		  	lcd.drawText(12, y+20, playlist[selection - 2][1])
		  	lcd.drawText(12, y+40, playlist[selection - 1][1])
		  	lcd.drawText(12, y+60, string.char(126) .. playlist[selection][1],INVERS)
		else
		  if selection == 1 then	
			lcd.drawText(12, y+20, string.char(126) .. playlist[selection][1],INVERS)
			lcd.drawText(12, y+40, playlist[selection + 1][1])
			lcd.drawText(12, y+60, playlist[selection + 2][1])
		else		
			lcd.drawText(12, y+20, playlist[selection - 1][1])
			lcd.drawText(12, y+40, string.char(126) .. playlist[selection][1], INVERS)
			lcd.drawText(12, y+60, playlist[selection + 1][1])
	  	 end 
	  end	
end
 
return { name="iTunes", options=options, create=create, update=update, refresh=refresh, background=background }
