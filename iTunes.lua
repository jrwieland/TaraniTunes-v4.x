--[[ 
TaraniTunes
 Version 3.0
 This Advanced version is based off of the Original TaraniTunes 
  http://github.com/GilDev/TaraniTunes
 By GilDev
 http://gildev.tk
It was agreed by GilDev and I that both versions of the script (the original 
and this advanced version) would be available for users but hosted separately.

The majority of the new enhancements are due to the work of Exean (https://github.com/exean)

----Playlist selector file-------
Also be sure to read about automated playlist creation---]]

local fileToLoad="/SCRIPTS/TELEMETRY/iTunes_player.lua"
local active = true
local thisPage={}
local page={}
-- Playlist Directories
local playlists={
	"/SOUNDS/lists/classic/playlist.lua",
	"/SOUNDS/lists/country/playlist.lua",
	"/SOUNDS/lists/easy/playlist.lua",
	"/SOUNDS/lists/funrock/playlist.lua",
	"/SOUNDS/lists/garage/playlist.lua",
	"/SOUNDS/lists/hard/playlist.lua",
	"/SOUNDS/lists/soundtracks/playlist.lua",
	"/SOUNDS/lists/modern/playlist.lua",
	"/SOUNDS/lists/rock/playlist.lua",
	"/SOUNDS/lists/upbeat/playlist.lua",
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

-- Select Screen
	if LCD_W==212 then --9DX screen
		lcd.clear()
		lcd.drawText(LCD_W/3, 0, "SELECT PLAYLIST", BLINK,SMLSIZE) 
		lcd.drawText(LCD_W/2-string.len(title)*4, 20, title, MIDSIZE)
		lcd.drawText(LCD_W/3+17, 34,"Songs: " .. #playlist,SMLSIZE)
		lcd.drawText(46, 57,"Scroll: [+/-] SELECT: [ENTER]",SMLSIZE)	
	else
		lcd.clear()
		lcd.drawText(LCD_W/6, 0, "SELECT PLAYLIST", BLINK,SMLSIZE) 
		lcd.drawText(LCD_W/2-string.len(title)*4, 20, title, MIDSIZE)
		lcd.drawText(LCD_W/3+7,32,"Songs: " .. #playlist,SMLSIZE)
		lcd.drawText(0, 57,"Choose Scroll/Select:[ENTER]",SMLSIZE)	
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
