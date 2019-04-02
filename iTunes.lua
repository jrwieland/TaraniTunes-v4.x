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

local fileToLoad="/SCRIPTS/TELEMETRY/iTunes_player.lua"
local active = true
local thisPage={}
local page={}
local playlists={
"/SOUNDS/lists/3dflying/playlist.lua",
"/SOUNDS/lists/between/playlist.lua",
"/SOUNDS/lists/cruising/playlist.lua",
"/SOUNDS/lists/demo/playlist.lua",
"/SOUNDS/lists/flights/playlist.lua"
}

function getSelectedPlaylistID()
	local res = 1
	--read selected playlist from config
	local f = io.open("itunes.conf", "r")	
	if f ~= nil then
		res = tonumber(io.read(f, 4))
		io.close(f)
	end
	return res;
end
 

local playlistID = getSelectedPlaylistID()
selectedPlaylistFile=playlists[playlistID]

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
  if active then
    page.run(...)
    active= not (...==EVT_MENU_BREAK)
  else  
	-- INPUT HANDLING --
	if (... == EVT_ROT_RIGHT or ... == EVT_MINUS_FIRST or ... == EVT_MINUS_RPT) then
		if playlistID == #playlists then
			playlistID = 1
		else
			playlistID = playlistID + 1
		end
	elseif (... == EVT_ROT_LEFT or ... == EVT_PLUS_FIRST or ... == EVT_PLUS_RPT) then
		if playlistID == 1 then
			playlistID = #playlists
		else
			playlistID = playlistID - 1
		end
	end	
	local plf = playlists[playlistID]
	if plf == nil then 
		plf = playlists[1];
	end
    loadScript(plf)() 
	-- Calculate indexes for screen display
	if LCD_W == 212 then -- if Taranis X9D	
		lcd.clear()
		lcd.drawText(48, 0, "SELECT PLAYLIST", BLINK+MIDSIZE)   
		lcd.drawText(2, 21,string.char(126).. title,LEFT+MIDSIZE)
		lcd.drawText(10, 34, #playlist .. " Songs In This Selection",MIDSIZE)
		lcd.drawText(25, 55,"Select:  [ENTER]")
    else
		-- Title if Taranis Q X7
		lcd.clear()
		lcd.drawText( 22, 0, "SELECT PLAYLIST", BLINK,SMLSIZE) 
		lcd.drawText( 37, 14, title, DBLSIZE)
		lcd.drawText(37, 34,"Songs: " .. #playlist,SMLSIZE)
		lcd.drawText(30, 57,"Select: [ENTER]",SMLSIZE)	
		lcd.drawPixmap(0, 19, cover)
	end
	clearTable(page)
	if ... == EVT_ROT_BREAK or ... == EVT_ENTER_BREAK then
		active = true
		local f = io.open("itunes.conf", "w") 
		io.write(f, playlistID)
		io.close(f)
		selectedPlaylistFile=playlists[playlistID]
		model.setTimer(2,{value=0})
	elseif ... == EVT_PAGE_BREAK then
		active = true
	end
	thisPage.init()
	return not (...==EVT_MENU_BREAK)
  end   
end


return thisPage
