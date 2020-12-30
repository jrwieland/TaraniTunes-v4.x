--[[ below is an option to add both the artist to the screen
and an scrolling effect for long song titles

to add an artist you must modify your playlists to include the artist
here is an example, the artist name is ficticious in this example
it was placed there for testing purposes only.

Sample playlist lua file (title, wav, length, artist)

title="Bubba Mix"
playlist={
{"Danger Zone","danzon",208,"Break Dance"},
{"Country Girl (Shake It For Me)","cntryg",223,"testing 123"},
{"Bad Case Of Loving You","drdr",190,"down and dirty"},
{"Some Beach","smbch",200,"ebany"},
{"She's Got the Look","gotlok",237,"ivory and seen"},
{"Shake It Off","shkoff",215,"test 234"},
}

replace the code in your itunes_player file with the snippets below --]]

--Artist title
	if string.len(playlist[playingSong][4]) > 13 then
		lcd.drawText((LCD_W-22) - ((getTime()/25)%(5*string.len(playlist[playingSong][4]))), 1, playlist[playingSong][4], SMLSIZE)
	else
		lcd.drawText((LCD_W / 2)-((string.len(playlist[playingSong][4])*5)/2) + 8, 1, playlist[playingSong][4], SMLSIZE)
	end
	
--Current song title
	if string.len(playlist[playingSong][1]) > 26 then
		lcd.drawText((LCD_W-22) - ((getTime()/25)%(7*string.len(playlist[playingSong][1]))), y, playlist[playingSong][1], SMLSIZE+INVERS)
	elseif string.len(playlist[playingSong][1]) > 21 then
		lcd.drawText((LCD_W-22) - ((getTime()/25)%(6*string.len(playlist[playingSong][1]))), y, playlist[playingSong][1], SMLSIZE+INVERS)
	elseif string.len(playlist[playingSong][1]) > 16 then
		lcd.drawText((LCD_W-22) - ((getTime()/25)%(5*string.len(playlist[playingSong][1]))), y, playlist[playingSong][1], SMLSIZE+INVERS)
	else
		lcd.drawText((LCD_W / 2)-((string.len(playlist[playingSong][1])*5)/2) + 3, y, playlist[playingSong][1], SMLSIZE+INVERS)
	end


-- Song selector
if selection == 1 then
	if playlist[selection] then
		if string.len(playlist[selection][1]) > 36 then tom = 2.5
		elseif string.len(playlist[selection][1]) > 31 then tom = 2
		elseif string.len(playlist[selection][1]) > 26 then tom = 1
			lcd.drawText(6 - ((getTime()/25)%(tom*string.len(playlist[selection][1]))), y+13, playlist[selection][1], SMLSIZE+INVERS)
			lcd.drawText(1, y+13, string.char(126), SMLSIZE+INVERS) 
		else lcd.drawText(1, y+13, string.char(126) .. playlist[selection][1], SMLSIZE+INVERS) end end
	if playlist[selection + 1] then lcd.drawText(1, y+20, playlist[selection + 1][1], SMLSIZE) end
	if playlist[selection + 2] then lcd.drawText(1, y+27, playlist[selection + 2][1], SMLSIZE) end
	if playlist[selection + 3] then lcd.drawText(1, y+34, playlist[selection + 3][1], SMLSIZE) end
	if playlist[selection + 4] then lcd.drawText(1, y+41, playlist[selection + 4][1], SMLSIZE) end
	if playlist[selection + 5] then lcd.drawText(1, y+48, playlist[selection + 5][1], SMLSIZE) end

elseif selection == 2 then 
	if playlist[selection - 1] then lcd.drawText(1, y+13, playlist[selection - 1][1], SMLSIZE) end
	if playlist[selection] then
		if string.len(playlist[selection][1]) > 36 then tom = 2.5
		elseif string.len(playlist[selection][1]) > 31 then tom = 2
		elseif string.len(playlist[selection][1]) > 26 then tom = 1
			lcd.drawText(6 - ((getTime()/25)%(tom*string.len(playlist[selection][1]))), y+20, playlist[selection][1], SMLSIZE+INVERS)
			lcd.drawText(1, y+20, string.char(126), SMLSIZE+INVERS) 
		else lcd.drawText(1, y+20, string.char(126) .. playlist[selection][1], SMLSIZE+INVERS) end end
	if playlist[selection + 1] then lcd.drawText(1, y+27, playlist[selection + 1][1], SMLSIZE) end
	if playlist[selection + 2] then lcd.drawText(1, y+34, playlist[selection + 2][1], SMLSIZE) end
	if playlist[selection + 3] then lcd.drawText(1, y+41, playlist[selection + 3][1], SMLSIZE) end
	if playlist[selection + 4] then lcd.drawText(1, y+48, playlist[selection + 4][1], SMLSIZE) end

elseif selection == (#playlist - 2) then 
	if playlist[selection - 3] then lcd.drawText(1, y+13, playlist[selection - 3][1], SMLSIZE) end
	if playlist[selection - 2] then lcd.drawText(1, y+20, playlist[selection - 2][1], SMLSIZE) end
	if playlist[selection - 1] then lcd.drawText(1, y+27, playlist[selection - 1][1], SMLSIZE) end
		if playlist[selection] then
		if string.len(playlist[selection][1]) > 36 then tom = 2.5
		elseif string.len(playlist[selection][1]) > 31 then tom = 2
		elseif string.len(playlist[selection][1]) > 26 then tom = 1
			lcd.drawText(6 - ((getTime()/25)%(tom*string.len(playlist[selection][1]))), y+34, playlist[selection][1], SMLSIZE+INVERS)
			lcd.drawText(1, y+34, string.char(126), SMLSIZE+INVERS) 
		else lcd.drawText(1, y+34, string.char(126) .. playlist[selection][1], SMLSIZE+INVERS) end end
	if playlist[selection + 1] then lcd.drawText(1, y+41, playlist[selection + 1][1], SMLSIZE) end
	if playlist[selection + 2] then lcd.drawText(1, y+48, playlist[selection + 2][1], SMLSIZE) end

elseif selection == (#playlist - 1) then 
	if playlist[selection - 4] then lcd.drawText(1, y+13, playlist[selection - 4][1], SMLSIZE) end
	if playlist[selection - 3] then lcd.drawText(1, y+20, playlist[selection - 3][1], SMLSIZE) end
	if playlist[selection - 2] then lcd.drawText(1, y+27, playlist[selection - 2][1], SMLSIZE) end
	if playlist[selection - 1] then lcd.drawText(1, y+34, playlist[selection - 1][1], SMLSIZE) end
		if playlist[selection] then
		if string.len(playlist[selection][1]) > 36 then tom = 2.5
		elseif string.len(playlist[selection][1]) > 31 then tom = 2
		elseif string.len(playlist[selection][1]) > 26 then tom = 1
			lcd.drawText(6 - ((getTime()/25)%(tom*string.len(playlist[selection][1]))), y+41, playlist[selection][1], SMLSIZE+INVERS)
			lcd.drawText(1, y+41, string.char(126), SMLSIZE+INVERS) 
		else lcd.drawText(1, y+41, string.char(126) .. playlist[selection][1], SMLSIZE+INVERS) end end
	if playlist[selection + 1] then lcd.drawText(1, y+48, playlist[selection + 1][1], SMLSIZE) end

elseif selection == #playlist then 
	if playlist[selection - 5] then lcd.drawText(1, y+13, playlist[selection - 5][1], SMLSIZE) end
	if playlist[selection - 4] then lcd.drawText(1, y+20, playlist[selection - 4][1], SMLSIZE) end
	if playlist[selection - 3] then lcd.drawText(1, y+27, playlist[selection - 3][1], SMLSIZE) end	
	if playlist[selection - 2] then lcd.drawText(1, y+34, playlist[selection - 2][1], SMLSIZE) end
	if playlist[selection - 1] then lcd.drawText(1, y+41, playlist[selection - 1][1], SMLSIZE) end
		if playlist[selection] then
		if string.len(playlist[selection][1]) > 36 then tom = 2.5
		elseif string.len(playlist[selection][1]) > 31 then tom = 2
		elseif string.len(playlist[selection][1]) > 26 then tom = 1
			lcd.drawText(6 - ((getTime()/25)%(tom*string.len(playlist[selection][1]))), y+48, playlist[selection][1], SMLSIZE+INVERS)
			lcd.drawText(1, y+48, string.char(126), SMLSIZE+INVERS) 
		else lcd.drawText(1, y+48, string.char(126) .. playlist[selection][1], SMLSIZE+INVERS) end end

else		
	if playlist[selection - 2] then lcd.drawText(1, y+13, playlist[selection - 2][1], SMLSIZE) end
	if playlist[selection - 1] then lcd.drawText(1, y+20, playlist[selection - 1][1], SMLSIZE) end
	if playlist[selection] then
	if string.len(playlist[selection][1]) > 36 then tom = 2.5
		elseif string.len(playlist[selection][1]) > 31 then tom = 2
		elseif string.len(playlist[selection][1]) > 26 then tom = 1
			lcd.drawText(6 - ((getTime()/25)%(tom*string.len(playlist[selection][1]))), y+27, playlist[selection][1], SMLSIZE+INVERS)
			lcd.drawText(1, y+27, string.char(126), SMLSIZE+INVERS) 
		else lcd.drawText(1, y+27, string.char(126) .. playlist[selection][1], SMLSIZE+INVERS) end end
	if playlist[selection + 1] then lcd.drawText(1, y+34, playlist[selection + 1][1], SMLSIZE) end
	if playlist[selection + 2] then lcd.drawText(1, y+41, playlist[selection + 2][1], SMLSIZE) end
	if playlist[selection + 3] then lcd.drawText(1, y+48, playlist[selection + 3][1], SMLSIZE) end
end
