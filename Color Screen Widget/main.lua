---- #########################################################################
-----# TaraniTunes v.4.2                                                     #
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
local errorOccured = false

loadScript("/SOUNDS/lists/funrock/playlist.lua")() --1st playlist in songList (see sample list below)

--Playlists folders names i.e. /SONGS/lists/"foldername"  below are sample names
local songList=
{"funrock",
"bubba_mix",
"classic_country",
"country_rock",
"easy",
"fun_country",
"todays",
"hard",
"laid_back",
"modern",
"rock",
"soundtracks",
"garage",
"upbeat",
} 

--Options
local options = {
  { "Use dflt clrs", BOOL, 1 },
  { "Shadow", BOOL, 0 }
  }

-- create zones
local function create(zone, options)
  local tunes = { zone=zone, options=options}
  model.setGlobalVariable(8,0,1)
  model.setCustomFunction(62,{switch = 132,func = 16,name = playlist[1][2]})--resets playing song on  to the 1st song on startup
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
 
-- Following is the various widgets zones from top bar to full screen (make changes as desired)
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
 	local battsw = getValue('sb')
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
	lcd.drawText(73,22,"Time "..datenow.hour12..":"..timemins.." "..datenow.suffix, INVERS)	
	local ver = getVersion() --OpenTX Version
  lcd.drawBitmap(elogo,5,8,90)
 	lcd.drawText(73,4,"V. "..ver)
	lcd.drawText(185,23, model.getInfo().name,DBLSIZE)--adjust as needed
	lcd.drawBitmap(aircraft,175,55)--adjust as needed
	
--Transmitter battery
local batt = getValue("tx-voltage")
lcd.drawText(8, 48,"TX Batt "..round(batt,1).."v")
 
 -- Flight Battery Loaded
 --[[ I use different capacity batteries, the timers are
 	  adjusted using SF depending on the battery capactity ]]--
	lcd.drawFilledRectangle(8,73,130,2)
	lcd.drawText(10, 95, "Battery Loaded")
	lcd.drawFilledRectangle(8,116,130,2)
 	local battsw = getValue('se')
 	if battsw == -1024 then 
 		lcd.drawText(65,75,"REG", INVERS)
 		lcd.drawSwitch(30,75,13)else
 	if battsw == 0 then
 		lcd.drawSwitch(30,75,14)
 		lcd.drawText(65,75,"MED", INVERS) else
 		lcd.drawSwitch(30,75,15)
 		lcd.drawText(65,75,"XXL", INVERS)
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
	lcd.drawText(125,122,getValue("RSSI-").." MIN", INVERS)
	
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
	lcd.drawText(90, y+4, "Selected Playlist >>".. title, SMLSIZE)
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
listP = getValue("ls63")
listN = getValue("ls64")
prevS = getValue("ls61")
nextS = getValue("ls62")

--song over
local long=playlist[playingSong][3]
if model.getTimer(2).value >= long then
  if playingSong == #playlist then
    model.setGlobalVariable(7,0,1)
    playingSong = model.getGlobalVariable(7,0)
    flushAudio()
    model.setCustomFunction(62,{switch = 132,func = 16,name = playlist[playingSong][2]})
    model.setTimer(2,{value=0})
  else
    flushAudio()
    playingSong = playingSong +1
    model.setGlobalVariable(7,0,playingSong)
    model.setCustomFunction(62,{switch = 132,func = 16,name = playlist[playingSong][2]})
    model.setTimer(2,{value=0})
  end

end
-- Next song
if nextS > -1 then
  if not nextSongSwitchPressed then
      if playingSong == #playlist then
      model.setGlobalVariable(7,0,1)
      playingSong = model.getGlobalVariable(7,0)	
    else
      playingSong = model.getGlobalVariable(7,0)
    end
    flushAudio()
    model.setCustomFunction(62,{switch = 132,func = 16,name = playlist[playingSong][2]})
    model.setTimer(2,{value=0})
  else
    nextSongSwitchPressed = false
  end	
end

--Change Previous Playlist
if listP > -1 then
  if not prevListSwitchPressed then
     if model.getGlobalVariable(8,0)<= 0 then	
      model.setGlobalVariable(8,0,#songList)
      set2 = songList[model.getGlobalVariable(8,0)]
      playingSong = 1
    else
      set2 = songList[model.getGlobalVariable(8,0)]
      playingSong = 1
    end
    loadScript("/SOUNDS/lists/"..set2.."/playlist.lua")()
    model.setCustomFunction(62,{switch = 132,func = 16,name = playlist[playingSong][2]})
    model.setGlobalVariable(7,0,1)
    flushAudio()
    model.setTimer(2,{value=0})
  else
    prevListSwitchPressed = false
  end
end

--Change next Playlist
if listN > -1 then
  if not nextListSwitchPressed then
     if model.getGlobalVariable(8,0) >= #songList then
      set2 = songList[1] 
      model.setGlobalVariable(8,0,1)
      playingSong = 1
      else
      set2 = songList[model.getGlobalVariable(8,0)]
      playingSong = 1
    end
   
    loadScript("/SOUNDS/lists/"..set2.."/playlist.lua")()
    model.setCustomFunction(62,{switch = 132,func = 16,name = playlist[playingSong][2]})
    model.setGlobalVariable(7,0,1)
    flushAudio()
    model.setTimer(2,{value=0})
  else
    nextListSwitchPressed = false
  end
end
-- previous song
if prevS > -1 then
  if not prevSongSwitchPressed then
    if playingSong == 1 then
      model.setGlobalVariable(7,0,#playlist)
      playingSong = model.getGlobalVariable(7,0)
    else
      playingSong = model.getGlobalVariable(7,0)
    end
    flushAudio()
    model.setCustomFunction(62,{switch = 132,func = 16,name = playlist[playingSong][2]})
    model.setTimer(2,{value=0})
  end
else
  prevSongSwitchPressed = false
end	
 
return { name="iTunes", options=options, create=create, update=update, refresh=refresh, background=background }
