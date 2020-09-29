---- #########################################################################
-----# TaraniTunes v.4.1                                                     #
---- # License GPLv3: http://www.gnu.org/licenses/gpl-3.0.html		     #
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
--[[Here are the numbers for the switches
SA↑ 1, SA- 2, SA↓ 3, 
SB↑ 4, SB- 5, SB↓ 6, 
SC↑ 7, SC- 8, SC↓ 9,
SD↑ 10, SD- 11, SD↓ 12, 
SG↑ 19, SG- 20, SG↓ 21 
Replace the value in "pause" (below)with the appropriate number --]]
local pause = 5 --switch that controls the pause (center switch position) 
local specialFunctionId = 62 
local errorOccured = false
local screenUpdate = true
local nextScreenUpdate = false
local songChanged = false
local resetDone = false
local mqTitle = 0

--Playlists folder names i.e. /SONGS/lists/"foldername"  below 
local songList=
{"3dflying",
"demo",
"cruising",
"garage"
} 

--logical switches used for play controls
local playSongLogicalSwitch   = 60 
local prevSongLogicalSwitch   = 62 --change the numbers on lines 366-371 to suit your switch & trim preferences 
local nextSongLogicalSwitch   = 63
local randomSongLogicalSwitch = 64

nextSongSwitchId   = getFieldInfo("ls" .. nextSongLogicalSwitch).id
prevSongSwitchId   = getFieldInfo("ls" .. prevSongLogicalSwitch).id
randomSongSwitchId = getFieldInfo("ls" .. randomSongLogicalSwitch).id

--Options
local options = {
  { "Use dflt clrs", BOOL, 1 },
  { "Shadow", BOOL, 0 }
}

-- create zones
local function create(zone, options)
  local tunes = { zone=zone, options=options}
     model.setGlobalVariable(8,0,1)
     return tunes
end

-- control functions
local function error(strings)
	errorStrings = strings
	errorOccured = true
end

--Update zones and options	
local function update(tunes, options)
 tunes.options = options
 end
 
--BackGround
local function background(tunes)
 end
 
-- Zone size: top bar widgets
local function refreshZoneTiny(tunes)
	local selection=playingSong
		lcd.drawText(tunes.zone.x, tunes.zone.y,songList[1], SMLSIZE)
		lcd.drawText(tunes.zone.x, tunes.zone.y+15,"> ".. playlist[selection][2],SMLSIZE)
end

--- Zone size: 160x32 1/8th
local function refreshZoneSmall(tunes)
	local selection=playingSong
		lcd.drawText(tunes.zone.x, tunes.zone.y+2,title, SMLSIZE)
		lcd.drawText(tunes.zone.x, tunes.zone.y+17, playlist[selection][1], INVERS+SMLSIZE)
 end 
	  
--- Zone size: 180x70 1/4th  (with sliders/trim)
--- Zone size: 225x98 1/4th  (no sliders/trim)
local function refreshZoneMedium(tunes)
local upTime=model.getTimer(2).value--do not change this value it is how long the current song has played
local long=playlist[playingSong][3]
local k = math.floor((upTime/long)*12)*10
	lcd.drawTimer(tunes.zone.x,tunes.zone.y, upTime, SMLSIZE+INVERS)
	lcd.drawTimer(tunes.zone.x+145,tunes.zone.y, long, SMLSIZE+INVERS)
	lcd.setColor(CUSTOM_COLOR,lcd.RGB(0,100,0))
	lcd.drawFilledRectangle(tunes.zone.x+35,tunes.zone.y+2,k,8,CUSTOM_COLOR)
local selection=playingSong
	lcd.drawText(tunes.zone.x, tunes.zone.y+16,"Playing > ".. title, SMLSIZE)
	if selection == #playlist then
	  	lcd.drawText(tunes.zone.x, tunes.zone.y+30, playlist[selection - 2][1],SMLSIZE)
	  	lcd.drawText(tunes.zone.x, tunes.zone.y+45, playlist[selection - 1][1],SMLSIZE)
	  	lcd.drawText(tunes.zone.x, tunes.zone.y+60, string.char(126) .. playlist[selection][1],INVERS+SMLSIZE)
	else
	  if selection == 1 then	
		lcd.drawText(tunes.zone.x, tunes.zone.y+30, string.char(126) .. playlist[selection][1],INVERS+SMLSIZE)
		lcd.drawText(tunes.zone.x, tunes.zone.y+45, playlist[selection + 1][1],SMLSIZE)
		lcd.drawText(tunes.zone.x, tunes.zone.y+60, playlist[selection + 2][1],SMLSIZE)
	else		
		lcd.drawText(tunes.zone.x, tunes.zone.y+30, playlist[selection - 1][1],SMLSIZE)
		lcd.drawText(tunes.zone.x, tunes.zone.y+45, string.char(126) .. playlist[selection][1], INVERS+SMLSIZE)
		lcd.drawText(tunes.zone.x, tunes.zone.y+60, playlist[selection + 1][1],SMLSIZE)
  	end 
  	end	
end
 
--- Zone size: 192x152 1/2
local function refreshZoneLarge(tunes)
lcd.drawText(tunes.zone.x+2, tunes.zone.y,"  iTunes Music", MIDSIZE)
local upTime=model.getTimer(2).value--do not change this value it is how long the current song has played
	local long=playlist[playingSong][3]
	local k = math.floor((upTime/long)*12)*10
		lcd.drawTimer(tunes.zone.x,tunes.zone.y+40, upTime, SMLSIZE+INVERS)
		lcd.drawTimer(tunes.zone.x+160,tunes.zone.y+40, long, SMLSIZE+INVERS)
		lcd.setColor(CUSTOM_COLOR,lcd.RGB(0,100,0))
		lcd.drawFilledRectangle(tunes.zone.x+35,tunes.zone.y+40,k,18,CUSTOM_COLOR)
	local selection=playingSong
	local selection=playingSong
		lcd.drawText(tunes.zone.x, tunes.zone.y+60,"Playing > ".. title, SMLSIZE)
	if selection == #playlist then
	  	lcd.drawText(tunes.zone.x, tunes.zone.y+85, playlist[selection - 2][1])
	  	lcd.drawText(tunes.zone.x, tunes.zone.y+105, playlist[selection - 1][1])
	  	lcd.drawText(tunes.zone.x, tunes.zone.y+125, string.char(126) .. playlist[selection][1],INVERS)
	else
	if selection == 1 then	
		lcd.drawText(tunes.zone.x, tunes.zone.y+85, string.char(126) .. playlist[selection][1],INVERS)
		lcd.drawText(tunes.zone.x, tunes.zone.y+105, playlist[selection + 1][1])
		lcd.drawText(tunes.zone.x, tunes.zone.y+125, playlist[selection + 2][1])
	else		
		lcd.drawText(tunes.zone.x, tunes.zone.y+85, playlist[selection - 1][1])
		lcd.drawText(tunes.zone.x, tunes.zone.y+105, string.char(126) .. playlist[selection][1],INVERS)
		lcd.drawText(tunes.zone.x, tunes.zone.y+125, playlist[selection + 1][1])
  	end 
  	end	
end
	
--- Zone size: 390x172 1/1 (with sliders and trims)
local function refreshZoneXLarge(tunes)
local upTime=model.getTimer(2).value--do not change this value it is how long the current song has played
local long=playlist[playingSong][3]

 function round(num, decimals)
	  local mult = 10^(decimals or 0)
	  return math.floor(num * mult + .5) / mult 
	 end
	  
--Current Model Information

	local aircraft = Bitmap.open("/IMAGES/" .. model.getInfo().bitmap)
	lcd.drawText(150,60, model.getInfo().name, MIDSIZE)--adjust for right look
	lcd.drawBitmap(aircraft,180,70,75)--adjust location and % for right look
	
--Transmitter battery
	local batt = getValue("tx-voltage")
	lcd.drawText(40, 51,"TX Batt "..round(batt,1).."v")
		
--Flight Time
	local fly=model.getTimer(1).value  --flight duration timer: 0=timer1, 1=timer2
	lcd.drawText(355, 51, "Flight Time")
	lcd.drawTimer(380, 72, fly, 2)	
 
 -- Flight Battery Loaded
 --[[ I use different capacity batteries the timers are
 	  adjusted using SF depending on the battery I'm flying ]]--
	lcd.drawFilledRectangle(40,73,100,2)
 	local battsw = getValue('se')
 	lcd.drawText(40, 90, "Battery Loaded",SMLSIZE)
	lcd.drawFilledRectangle(40,105,100,2)
 	if battsw == -1024 then 
 		lcd.drawText(90,75,"REG",SMLSIZE)
 		lcd.drawSwitch(60,75,13)else
 	if battsw == 0 then
 		lcd.drawSwitch(40,75,14)
 		lcd.drawText(90,75,"MED", SMLSIZE) else
 		lcd.drawSwitch(60,75,15)
 		lcd.drawText(90,75,"XXL", SMLSIZE)
 	end 
 	end
 
-- Cell Voltage
	lcd.drawFilledRectangle(365,96,78,2)
	lcd.drawText(375, 98, "Lipo Cell")
	lcd.drawChannel(390, 119,"LCEL", PREC2+INVERS) --displays a custom telementry sensor (lowest cell)calculated from "cels" sensor

-- Altitude
	lcd.drawText(40,110,"HEIGHT= ", SMLSIZE)
	lcd.drawChannel(100,110,"Alt",SMLSIZE)
	lcd.drawText(42, 125,"Max", SMLSIZE)
	lcd.drawChannel(82,125,"Alt+",2+SMLSIZE)	
		
--Tementry separator bar
	local y = 160
	lcd.drawFilledRectangle(40,y-18,400,6,GREY_DEFAULT)

--Music
-- Progressbar 
	local upTime=model.getTimer(2).value--do not change this value it is how long the current song has played
	local k = math.floor((upTime/long)*33)*10
	lcd.drawTimer(44, y-10, upTime, SMLSIZE+INVERS)
	lcd.drawTimer(400,y-10, long, SMLSIZE+INVERS)
	lcd.setColor(CUSTOM_COLOR,lcd.RGB(0,100,0))
	lcd.drawFilledRectangle(80,y-10,k,18,CUSTOM_COLOR)
		
--music display
	local selection=playingSong
	lcd.drawText(90, y+5, "Selected Playlist >>",SMLSIZE)
	lcd.drawText(220, y+5, title, SMLSIZE)
	if selection == #playlist then
	  	lcd.drawText(40, y+20, playlist[selection - 2][1])
	  	lcd.drawText(40, y+38, playlist[selection - 1][1])
	  	lcd.drawText(40, y+56, string.char(126) .. playlist[selection][1],INVERS)
	else
	  if selection == 1 then	
		lcd.drawText(40, y+20, string.char(126) .. playlist[selection][1],INVERS)
		lcd.drawText(40, y+38, playlist[selection + 1][1])
		lcd.drawText(40, y+56, playlist[selection + 2][1])
	else		
		lcd.drawText(40, y+20, playlist[selection - 1][1])
		lcd.drawText(40, y+38, string.char(126) .. playlist[selection][1], INVERS)
		lcd.drawText(40, y+56, playlist[selection + 1][1])
  	 end 
	 end
end
	  
 --- Zone size: 460x252 1/1 (no sliders/trim/topbar)
local function refreshZoneFull(tunes)
local upTime=model.getTimer(2).value--do not change this value it is how long the current song has played
local long=playlist[playingSong][3]

 function round(num, decimals)
	  local mult = 10^(decimals or 0)
	  return math.floor(num * mult + .5) / mult 
 end
	  
--Current time, OpenTX Version & Model Information
	local datenow = getDateTime()		
	local timemins = (string.format("%02d",datenow.min))
	lcd.drawText(8,30,datenow.hour12..":"..timemins.." "..datenow.suffix,INVERS)	
	local ver = getVersion() --OpenTX Version
	local logo = Bitmap.open("/THEMES/Darkblue/topmenu_opentx.bmp")
	lcd.drawBitmap(logo,8,5,75)
	lcd.drawText(35,7,ver)
	local aircraft = Bitmap.open("/IMAGES/" .. model.getInfo().bitmap)
	lcd.drawText(190,40, model.getInfo().name)--adjust for right look
	lcd.drawBitmap(aircraft,165,50,95)--adjust location and % for right look
	
--Transmitter battery
	local batt = getValue("tx-voltage")
	lcd.drawText(8, 51,"TX Batt "..round(batt,1).."v")
 
 -- Flight Battery Loaded
 --[[ I use different capacity batteries the timers are
 	  adjusted using SF depending on the battery I'm flying ]]--
	lcd.drawFilledRectangle(8,73,130,2)
	lcd.drawText(10, 95, "Battery Loaded")
	lcd.drawFilledRectangle(8,116,130,2)
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
	lcd.drawFilledRectangle(44,y-10,k,18,CUSTOM_COLOR)
	
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

function refresh(tunes) 
--load Playlist selection
	if model.getGlobalVariable(8,0) == #songList+1 then
		set2 = songList[1] 
		model.setGlobalVariable(8,0,1)
	elseif model.getGlobalVariable(8,0) == 0 then
		model.setGlobalVariable(8,0,#songList)
		set2 = #songList 
	else
		set2 = songList[model.getGlobalVariable(8,0)]
	end
		loadScript("/SOUNDS/lists/"..set2.."/playlist.lua")()
	
-- set Special Functions and Logical Switches
  	model.setCustomFunction(specialFunctionId,{switch = 132,func = 16,name = playlist[playingSong][2]})
	model.setCustomFunction(63,{switch = pause,func = 17})
    model.setLogicalSwitch(59,{func=9,v1=133, v2=136})--this reads swicthes on LS61 and 64 to run the timer
    model.setLogicalSwitch(60,{func=9,v1=4, v2=5})--switch numbers listed at the begining
    
    -- Trim #'s 61=rl,62=rr,63=ed,64=eu,65=td,66=tu,67=al,68=ar,69=5d,70=5u,71=6d,72=6u
    model.setLogicalSwitch(61,{func=9,v1=71, v2=71})--adjust to your preference using numbers above
    model.setLogicalSwitch(62,{func=9,v1=72, v2=72})--adjust to your preference using numbers above
    model.setLogicalSwitch(63,{func=9,v1=6, v2=6})--switch numbers listed at the begining
  
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
			nextSongSwitchPressed =true
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
	
--Widget Display by Size
	if tunes.zone.w  > 450 and tunes.zone.h > 240 then refreshZoneFull(tunes)
  	  elseif tunes.zone.w  > 200 and tunes.zone.h > 165 then refreshZoneXLarge(tunes)
	  elseif tunes.zone.w  > 180 and tunes.zone.h > 145 then refreshZoneLarge(tunes)
	  elseif tunes.zone.w  > 170 and tunes.zone.h >  65 then refreshZoneMedium(tunes)
	  elseif tunes.zone.w  > 150 and tunes.zone.h >  28 then refreshZoneSmall(tunes)
	  elseif tunes.zone.w  >  65 and tunes.zone.h >  35 then refreshZoneTiny(tunes)
  	end
end
 
return { name="iTunes", options=options, create=create, update=update, refresh=refresh, background=background }
