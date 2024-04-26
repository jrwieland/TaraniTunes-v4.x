---- #########################################################################
-----# TaraniTunes v.4.3                                                     #
---- # License GPLv3: http://www.gnu.org/licenses/gpl-3.0.html	             #
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
loadScript("/SOUNDS/lists/bubba_mix/playlist.lua")() --1st playlist in songList (see sample list below)

--Playlists folders names i.e. /SONGS/lists/"foldername"  below are sample names
local songList=
{"bubba_mix",
"classic_country",
"country_rock",
"easy",
"fun_country",
"todays",
"funrock",
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
}

--SF commands for songs to play based on Version Installed
-- Edge 2.8 switch = 132,func = 16,playlist[playingSong][2]
-- Edge 2.9 switch = 144, func =16,playlist[playingSong][2]
-- Edge 2.10 switch = 228,func =14,playlist[playingSong][2],active=1 
--  Change the song Controls below at the refresh section

-- create zones
local function create(zone, options)
  local tunes = { zone=zone, options=options}
  model.setGlobalVariable(7,0,1)
  model.setGlobalVariable(8,0,1)
  model.setCustomFunction(62,{switch = 228,func =14,name = playlist[1][2],active=1})--resets playing song on  to the 1st song on startup
  aircraft = Bitmap.open("/IMAGES/" .. model.getInfo().bitmap) 
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
  lcd.drawText(40, 90, "Flight Battery",SMLSIZE)
  lcd.drawFilledRectangle(40,105,100,2)
  if battsw == -1024 then 
    lcd.drawText(90,75,"SHORT 4.2",SMLSIZE)
    lcd.drawSwitch(60,75,13)else
    if battsw == 0 then
      lcd.drawSwitch(40,75,14)
      lcd.drawText(90,75,"REG 4.2", SMLSIZE) else
      lcd.drawSwitch(60,75,15)
      lcd.drawText(90,75,"4.35 PACK", SMLSIZE)
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

elogo = Bitmap.open("/THEMES/edge.png")
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
  lcd.drawText(63,24,"Time "..datenow.hour12..":"..timemins.." "..datenow.suffix)	
  local ver = getVersion() --OpenTX Version
  lcd.drawBitmap(elogo,3,0,53)
  lcd.drawText(63,4,"V. "..ver)
  lcd.drawText(185,5, model.getInfo().name,DBLSIZE)--adjust as needed
  lcd.drawBitmap(aircraft,170,45,90)--adjust as needed

--Transmitter battery
  local batt = getValue("tx-voltage")
  lcd.drawText(8, 50,"TX Batt "..round(batt,1).."v")
  
  --Receiver Voltage battery
  
  lcd.drawText(100, 50,"RX Batt ")
  lcd.drawChannel(160,50,"RxBt")

  -- Flight Battery Loaded
  --[[ I use different capacity batteries, the timers are
 	  adjusted using SF depending on the battery capactity ]]--
  lcd.drawFilledRectangle(8,73,130,2)
  lcd.drawText(10, 95, "Battery Loaded")
  lcd.drawFilledRectangle(8,116,130,2)
  local battsw = getValue('se')
  if battsw == -1024 then 
    lcd.drawText(65,75,"SHORT 4.2", INVERS)
    lcd.drawSwitch(30,75,13)else
    if battsw == 0 then
      lcd.drawSwitch(30,75,14)
      lcd.drawText(65,75,"REG 4.2", INVERS) else
      lcd.drawSwitch(30,75,15)
      lcd.drawText(65,75,"HV 4.35", INVERS)
    end 
  end

  -- Flight Mode
  lcd.drawFilledRectangle(380,60,90,2)
  lcd.drawFilledRectangle(380,105,90,2)
--  local fmno, fmname = getFlightMode()
--  if fmname == "" then
--    fmname = "FM".. fmno
--    lcd.drawText(410, 63, fmname)else
--    lcd.drawText(410, 63, "FM"..fmno)
--    lcd.drawText(380,83, fmname)
--  end

-- Speed
  lcd.drawText(360,63,"Speed= ")
  lcd.drawChannel(420,63,"GSpd")
  lcd.drawText(346,83,"Top Spd= ")
  lcd.drawChannel(420,83,"GSpd+",2)

--Flight Time
  local fly=model.getTimer(1).value  --flight duration timer: 0=timer1, 1=timer2
  lcd.drawText(384, 4, "Flight Time")
  lcd.drawTimer(380, 28, fly, DBLSIZE+PREC2)	

-- Cell Voltage
  lcd.drawText(372, 104, "Lipo Cell",MIDSIZE)
  lcd.drawChannel(380, 130,"LCEL", DBLSIZE+PREC2+INVERS) --displays a custom telementry sensor (lowest cell)calculated from "cels" sensor

--rssi
  lcd.drawText(8,122,"RSSI Sig  ")
  lcd.drawChannel(80,122,"RSSI")
  lcd.drawText(123,122," //MIN ")
  lcd.drawChannel(170,122,"RSSI-")

-- Altitude
  lcd.drawText(8,143,"HEIGHT= ")
  lcd.drawChannel(80,143,"GAlt")
  lcd.drawText(130, 143,"//Max")
  lcd.drawChannel(185,143,"GAlt+",2)
	
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
--SF commands for songs to play based on Version Installed
-- Edge 2.8 switch = 132,func = 16,playlist[playingSong][2]
-- Edge 2.9 switch = 144, func =16,playlist[playingSong][2]
-- Edge 2.10 switch = 228,func =14,playlist[playingSong][2],active=1 
 
 listP = getValue("ls63")
  listN = getValue("ls64")
  prevS = getValue("ls61")
  nextS = getValue("ls62")
  SongSw = getFieldInfo("ls60").id

--song over

  local long=playlist[playingSong][3]
  if model.getTimer(2).value >= long then
    if playingSong == #playlist then
      model.setGlobalVariable(7,0,1)
      playingSong = model.getGlobalVariable(7,0)
      flushAudio()
       model.setCustomFunction(62,{switch = 228,func =14,name = playlist[playingSong][2],active=1})
      model.setTimer(2,{value=0})
    else
      flushAudio()
      playingSong = playingSong +1
      model.setGlobalVariable(7,0,playingSong)
       model.setCustomFunction(62,{switch = 228,func =14,name = playlist[playingSong][2],active=1})
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
      model.setCustomFunction(62,{switch = 228,func =14,name = playlist[playingSong][2],active=1})
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
       model.setCustomFunction(62,{switch = 228,func =14,name = playlist[playingSong][2],active=1})
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
       model.setCustomFunction(62,{switch = 228,func =14,name = playlist[playingSong][2],active=1})
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
       model.setCustomFunction(62,{switch = 228,func =14,name = playlist[playingSong][2],active=1})
      model.setTimer(2,{value=0})
    end
  else
    prevSongSwitchPressed = false
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
