## TaraniTunes v4.0 Non Color Radios   
Awesome music player for OpenTX & EdgeTX radios.

Key Enhancements   
** Streamlined code to match the Color Widget version in both look and feel.    
** FlushAudio Added to clear song playing when a new song/playlist is selected.   
** Song or playlist immediately play when selected.  No need to move switches as an "Enter Key".    
** Model Global Variable 8 and 9 used is also used to keep track of the music and playlists.      
** Removed the separate player file all interaction is contained within the code.   


### Installation  
1. On your computer:   
	a. Edit `iTunes.lua` to have your desired amount of playlists. Place the file in the `/SCRIPT/TELEMETRY` directory on your SD card.  

	b. Create a folder "lists" under /SOUNDS

	c. Create separate folders under "lists" for each desired playlist on your SD card. The folder names should pertain to the music played. **Do not add spaces to the directory names**
Examples >> `/SOUNDS/lists/3dflying`, `/SOUNDS/lists/practice`, `/SOUNDS/lists/hardrock`, `/SOUNDS/lists/competition`

2. Create a "playlist.lua" file in each of those directories.
	a. I recommend using [`Mp3tag`](https://www.mp3tag.de/en/index.html) to create your playlists. It will automatically add the required information in TaraniTunes’ format. *Please look at the instructions in [`Auto_Playlist`](/Auto_Playlist)*.

	b.  If you prefer to manually create the playlist files. Each line must be formatted like this:   
	`{"Song name", "SONG_FILENAME", duration},`
		1. `Song name` is the full name, with artist if you want.
		2. `SONG_FILENAME` must be 6 characters or less.
		3. `duration` is your song’s duration in seconds. *EXAMPLE - Your song is 3:45 long you would enter 225. For a 4:52 song you would enter 292. Simply calculate `minute’s × 60 + seconds` to get your song’s duration. Song length can usually be found in the file’s properties.*  

 Look at [playlist.lua](playlist.lua) for an example of the required structure of the file.

3. Put your corresponding songs `SONG_FILENAME.wav` in `/SOUNDS/en` if your radio is in English (otherwise replace `en` with your language). They must be converted to mono, preferably normalized, and encoded in Microsoft WAV 16-bits signed PCM at a 32 kHz sampling rate, you can use [Audacity](http://www.audacityteam.org) to do that, it works great. Remember the filename must be 6 characters or less or else it will not play.

4. On your Taranis or (in companion) **This is how I setup my radio:
	a. Set “TIMER3” as follows:      
	![Timer settings](/Screenshots/timer.PNG)  
	
	b. Set active “FLIGHT MODES” model rudder trims as follows:     
	![Flight modes settings](/Screenshots/trims.PNG)  
	Set the rudder and Aileron trims to “`--`” for every flight mode you use.  
	XLITE users Use the Aileron or Elevator trims (Rudder requires the use of the shift button).  
	
	c. Set each FM in Model Global Variable 8 and 9 to refer back to FM0  These two are used to select the song and the playlist respectively.  
	![Flight modes settings](/Screenshots/Global.PNG)  
	
	d. Set “LOGICAL SWITCHES” settings as follows:  
	![Logical Switch Settings](/Screenshots/LogicalSwitch.PNG)  
	
	e.  Set the Special Functions SF 58-64 as follows:  
	**SF63 will automatically be installed and updated by the program.  
	![Special Function Settings](/Screenshots/SpecialFunction.PNG)  
	
	f. Under Telemetry “DISPLAY” Choose to display `Script iTunes`  
	![Display settings](/Screenshots/DisplaySettings.PNG)

There you go! Next section will explain how to use TaraniTunes.

### Usage

From the main screen, hold “Page” to access TaraniTunes Telemetry Screen.  
1. Put the “SB” switch in the lower position to start playing the music.  
2. Put the "SB" switch in the Middle position to pause the song. It will continue from where it left off when the switch is returned to the lower "play" position.  
3. Put “SB” in the up position reset the song (restart). It will play once it is returned to the lower "play" position.   
4. When the song ends, the next song will automatically play.  
5. Press rudder trim right or left to play next or previous song respectively.  
 
#### Changing Playlists

1. Press Aileron trim right or left to play next or previous playlist respectively.  
2. The song will automatically play.  
This allows you to change playlists or music without having to look at the radio keeping you model in sight.   
