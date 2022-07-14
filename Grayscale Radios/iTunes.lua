--[[  #########################################################################
      # TaraniTunes v.4.0                                                     #
      # B&W Radios                                                            #
      # License GPLv3: http://www.gnu.org/licenses/gpl-3.0.html		            #
      #                                                                       #
      # This program is free software; you can redistribute it and/or modify  #
      # it under the terms of the GNU General Public License version 3 as     #
      # published by the Free Software Foundation.                            #
      #                                                                       #
      # This program is distributed in the hope that it will be useful        #
      # but WITHOUT ANY WARRANTY; without even the implied warranty of        #
      # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
      # GNU General Public License for more details.                          #
      #########################################################################--]]

--Locals
local playingSong = 1
local errorOccured = false
local ver = getVersion() --OpenTX Version
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

-- Initiate Program
local function init()
  model.setGlobalVariable(7,0,1)
  model.setGlobalVariable(8,0,1)
  shPresent =getValue("sh")
  if shPresent== 0 then
    sw1=98
  elseif LCD_W==212 then
    sw1=113   
  else
    sw1=104
  end
  model.setCustomFunction(62,{switch = sw1,func = 16,name = playlist[1][2]})--resets playing song on  to the 1st song on startup
  return tunes
end

-- error Control functions
local function error(strings)
  errorStrings = strings
  errorOccured = true
end

--BackGround 
local function background(tunes)
end

local function run(tunes)
--Update Locals
  lcd.clear()
  local selection=playingSong
  local long=playlist[playingSong][3]--do not change this value it is the length of the current song playing
  local upTime=model.getTimer(2).value--do not change this value it is how long the current song has played
  local batt = getValue("tx-voltage")
  local datenow = getDateTime()		
  local timemins = (string.format("%02d",datenow.min))
  local fly=model.getTimer(1).value  --flight duration timer: 0=timer1, 1=timer2
  local altN=getValue("Alt")--current altitude from telementry
  local altM=getValue("Alt+")--max altitude from telementry
  local shPresent =getValue("sh")
  
  -- LS60 Switch Number controled by Radio profile
  if shPresent== 0 then
    sw1=98
  elseif LCD_W==212 then
    sw1=113   
  else
    sw1=104
  end

--Math
  function round(num, decimals)
    local mult = 10^(decimals or 0)
    return math.floor(num * mult + .5) / mult 
  end

--Current time, OpenTX Version & Model Name
  lcd.drawText(1,10,datenow.hour12..":"..timemins..datenow.suffix,SMLSIZE)	
  lcd.drawText(1,2,"OTX "..ver,SMLSIZE)
  if LCD_W == 212 then
    lcd.drawText(LCD_W/2-(string.len(model.getInfo().name)/2)*6,2,model.getInfo().name)
  else
    lcd.drawText(LCD_W/2-(string.len(model.getInfo().name)/2)*5,13,model.getInfo().name)  
  end
  
  --Transmitter battery
  lcd.drawText(14, 18,"TX "..round(batt,1).."v",PREC1+SMLSIZE)
  
  -- Altitude
  lcd.drawText(1, 26,"Alt= "..round(altN,2).."/"..round(altM,2),SMLSIZE)

--Flight Time
  lcd.drawTimer(LCD_W-32, 20, fly, MIDSIZE)	
  
--rssi
  lcd.drawText(LCD_W-51,1,"RSSI "..getValue("RSSI").."/"..getValue("RSSI-"))

--Cell Voltage
  lcd.drawChannel(LCD_W-(string.len("LCEL"))*6, 11,"LCEL", PREC2) --displays a custom telementry sensor (lowest cell)calculated from "cels" sensor

--Music Display
  local y = 23;
--Playlist title
  lcd.drawLine(0, y+10, LCD_W, y+10,SOLID,FORCE)
  lcd.drawText(LCD_W/2-(string.len(title))/2*5, y+12, title, SMLSIZE)

-- Progressbar
  --local k = math.floor((upTime/long)*33)*10
  lcd.drawLine(0, y+18, LCD_W, y+18,SOLID,FORCE)
  lcd.drawFilledRectangle(20, y+11, math.floor((upTime/long)*(LCD_W-43)), 7)
  lcd.drawTimer(1, y+12, upTime, SMLSIZE+INVERS)
  lcd.drawTimer(LCD_W-22, y+12, long, SMLSIZE+INVERS)

--Song display
  if selection == #playlist then
    lcd.drawText(6, y+19, playlist[selection - 1][1],SMLSIZE)
    lcd.drawText(1, y+26, string.char(126) .. playlist[selection][1],SMLSIZE)
    lcd.drawText(6, y+33, playlist[1][1],SMLSIZE)
  else
    if selection == 1 then	
      lcd.drawText(6, y+19, playlist[#playlist][1],SMLSIZE)
      lcd.drawText(1, y+26, string.char(126) .. playlist[selection][1],SMLSIZE)
      lcd.drawText(6, y+33, playlist[selection + 1][1],SMLSIZE)  
    else		
      lcd.drawText(6, y+19, playlist[selection - 1][1],SMLSIZE)
      lcd.drawText(1, y+26, string.char(126) .. playlist[selection][1], SMLSIZE)
      lcd.drawText(6, y+33, playlist[selection + 1][1],SMLSIZE)
    end 
  end	

-- Music Controls
  listP = getValue("ls63")
  listN = getValue("ls64")
  prevS = getValue("ls61")
  nextS = getValue("ls62")

--song over
  if model.getTimer(2).value >= long then
    if playingSong == #playlist then
      model.setGlobalVariable(7,0,1)
      playingSong = model.getGlobalVariable(7,0)
      flushAudio()
      model.setCustomFunction(62,{switch = sw1,func = 16,name = playlist[playingSong][2]})
      model.setTimer(2,{value=0})
    else
      flushAudio()
      playingSong = playingSong +1
      model.setGlobalVariable(7,0,playingSong)
      model.setCustomFunction(62,{switch = sw1,func = 16,name = playlist[playingSong][2]})
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
      model.setCustomFunction(62,{switch = sw1,func = 16,name = playlist[playingSong][2]})
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
      model.setCustomFunction(62,{switch = 98,func = 16,name = playlist[playingSong][2]})
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
      model.setCustomFunction(62,{switch = sw1,func = 16,name = playlist[playingSong][2]})
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
      model.setCustomFunction(62,{switch = sw1,func = 16,name = playlist[playingSong][2]})
      model.setTimer(2,{value=0})
    end
  else
    prevSongSwitchPressed = false
  end	
end

return {run = run, background = background, init = init}
