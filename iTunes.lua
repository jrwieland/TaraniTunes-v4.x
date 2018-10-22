--[[
TaraniTunes
 Version 2.2
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
--[[Playlists are changed using the S2 Pot values from 1000 to -1000
As many times as you want to divide the switch is the limit to the number
of playlists available.
This file has 8 separate playlists --]]   

local set2=getValue("s2")--s2 is the selector for the playlists
  if set2 > 750 then --value of s2 switch position to select this file
    	set1 = 8 -- number index of the playlist
    	name1 = "       3d Flying" elseif -- selected playlist name
  	set2 > 500 then
    	set1 = 7
    	name1 = "   Competition" elseif
  	set2 > 250 then
    	set1 = 6
    	name1 = "Just Cruising" elseif
  	set2 > 0 then
    	set1 = 5
    	name1 = "Demo for Others" elseif
  	set2 < -750 then
    	set1 = 1
    	name1 = "     A Few Flights" elseif
  	set2 < -500 then
   		set1 = 2
   		name1 = "   Practice Time" elseif
  	set2 < -250 then
   		set1 = 3
   		name1 = "    Race Time" else  -- spaces help center the display
   		set1 = 4
   		name1 = "   Out Relaxing"
  end

   if active then
    page.run(...)
    active= not (...==EVT_MENU_BREAK)
  else
  	-- Calculate indexes for screen display
	if LCD_W == 212 then -- if Taranis X9D
    lcd.clear()
    lcd.drawText( 40, 6, "!! NEW PLAYLIST REQUEST !!", BLINK)
    lcd.drawText( 60, 18, "Select Playlist", 0)
    lcd.drawText( 48, 29, "Swicth S2 Position = " ..set1, 0)
    lcd.drawText( 64, 39, name1, 0)
    lcd.drawText( 40, 50,"Press ENTER to Activate",0)
    clearTable(page)
        active= (...==EVT_ENTER_BREAK)
    model.setTimer(2,{value=0})--resets song timer to 0 when new playlist is selected

    thisPage.init()
    else
    -- Title if Taranis Q X7
    lcd.clear()
    lcd.drawText( 8, 8, "!New Playlist Request!", BLINK,SMLSIZE)
    lcd.drawText( 22, 20, "Select Playlist",SMLSIZE)
    lcd.drawText( 16, 30, "Switch S2 Position = " .. set1, SMLSIZE)
    lcd.drawText( 16, 40, name1, 0)
    lcd.drawText(10, 50,"Press ENTER to Activate",SMLSIZE)
    clearTable(page)
    active= (...==EVT_ROT_BREAK)
    model.setTimer(2,{value=0})
    thisPage.init()

  return not (...==EVT_MENU_BREAK)
end end end


return thisPage
