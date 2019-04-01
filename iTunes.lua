--[[
TaraniTunes
 Version 2.2.2
 This Advenced version is based off of the Original TaraniTunes
  http://github.com/GilDev/TaraniTunes
 By GilDev
 http://gildev.tk
It was agreed by GilDev and I that both versions of the script (the original
and this advanced version) would be available for users but hosted seperately.

----Playlist selector file-------
Change the wording of your playlist and quantity of the playlists below (starting on line line 52)
See the README file(s) for setting up the "main.lua" file
Also be sure to read about automated playlist creation---]]

local fileToLoad="/SCRIPTS/TELEMETRY/main.lua"
local active = true
local thisPage={}
local page={}
 
local function clearTable(t)
  if type(t)=="table" then
    for i,v in pairs(t) do
      if type(v) == "table" then
        clearTable(v)
      end
      t[i] = nil
    end
  end
  collectgarbage()
  return t
end

thisPage.init=function(...)
	 if active then
    page=dofile(fileToLoad)
    page.init(...)
  end
  return true
end

thisPage.background=function(...)
  if active then
    page.background(...)

  end
  return true
end

thisPage.run=function(...)
   if active then
    page.run(...)
    active= not (...==EVT_MENU_BREAK)
  else
   local set2=getValue("s2")--s2 is the selector for the playlists  
--[[Playlists are changed using the S2 Pot values from 1000 to -1000
As many times as you want to divide the switch is the limit to the number
of playlists available.
This file has 8 separate playlists --]]   
   if set2 > 750 then --value of s2 switch position to select this file
    		loadScript("/SOUNDS/lists/3dflying/playlist")()  -- selected playlist name
    elseif set2 > 500 then
    		loadScript("/SOUNDS/lists/competition/playlist")() 
  	elseif set2 > 250 then
    		loadScript("/SOUNDS/lists/cruising/playlist")()
  	elseif set2 > 0 then
    		loadScript("/SOUNDS/lists/demo/playlist")() 
  	elseif set2 > -250 then
    		loadScript("/SOUNDS/lists/relaxing/playlist")()
  	elseif set2 > -500 then
    		loadScript("/SOUNDS/lists/racing/playlist")()
  	elseif set2 > -750 then
   		loadScript("/SOUNDS/lists/practice/playlist")()
   	else loadScript("/SOUNDS/lists/flights/playlist")()
  end
 
  	-- Calculate indexes for screen display
	if LCD_W == 212 then -- if Taranis X9D
    lcd.clear()
    lcd.drawText(48, 0, "SELECT PLAYLIST", BLINK+MIDSIZE)   
	lcd.drawText(2, 21,string.char(126).. title,LEFT+MIDSIZE)
	lcd.drawText(10, 34, #playlist .. " Songs In This Selection",MIDSIZE)
    lcd.drawText(25, 55,"Change:  [S2]  /  Select:  [ENTER]")
    clearTable(page)
        active= (...==EVT_ENTER_BREAK)
    model.setTimer(2,{value=0})--resets song timer to 0 when new playlist is selected
    thisPage.init()
    else
    -- Title if Taranis Q X7
    lcd.clear()
    lcd.drawText( 22, 0, "SELECT PLAYLIST", BLINK,SMLSIZE)   
	lcd.drawText(2, 21,string.char(126).. title,LEFT)
	lcd.drawText(9, 30, #playlist .. " Songs In This Selection",SMLSIZE)
    lcd.drawText(0, 57,"Change: [S2] / Select: [ENTER]",SMLSIZE)	
    clearTable(page)
    active= (...==EVT_ROT_BREAK)
    model.setTimer(2,{value=0})
    thisPage.init() 
  return not (...==EVT_MENU_BREAK)
end end end
return thisPage
