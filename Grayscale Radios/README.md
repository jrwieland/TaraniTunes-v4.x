### Installation

1. On your computer:
	1. Edit `iTunes.lua` to have your desired amount of playlists. Place the file in the `/SCRIPT/TELEMETRY` directory on your SD card.  

	2. Create a folder "lists" under /SOUNDS

	3. Create separate folders under "lists" for each desired playlist on your SD card. The folder names should pertain to the music played. **Do not add spaces to the directory names**
Examples >> `/SOUNDS/lists/3dflying`, `/SOUNDS/lists/practice`, `/SOUNDS/lists/hardrock`, `/SOUNDS/lists/competition`

2. Create a "playlist.lua" file in each of those directories.
	1. I recommend using [`Mp3tag`](https://www.mp3tag.de/en/index.html) to create your playlists. It will automatically add the required information in TaraniTunes’ format. *Please look at the instructions in [`Auto_Playlist`](/Auto_Playlist)*.

	2.  If you prefer to manually create the playlist files. Each line must be formatted like this:   
	`{"Song name", "SONG_FILENAME", duration},`
		1. `Song name` is the full name, with artist if you want.
		2. `SONG_FILENAME` must be 6 characters or less.
		3. `duration` is your song’s duration in seconds. *EXAMPLE - Your song is 3:45 long you would enter 225. For a 4:52 song you would enter 292. Simply calculate `minute’s × 60 + seconds` to get your song’s duration. Song length can usually be found in the file’s properties.*  

 Look at [playlist.lua](playlist.lua) for an example of the required structure of the file.

3. Put your corresponding songs `SONG_FILENAME.wav` in `/SOUNDS/en` if your radio is in English (otherwise replace `en` with your language). They must be converted to mono, preferably normalized, and encoded in Microsoft WAV 16-bits signed PCM at a 32 kHz sampling rate, you can use [Audacity](http://www.audacityteam.org) to do that, it works great. Remember the filename must be 6 characters or less or else it will not play.

4. On your Taranis or (in companion) **This is how I setup my radio:
	1. Set “TIMER3” as follows:      
	![Timer settings](/Screenshots/timer.PNG)  
	2. Set active “FLIGHT MODES” model rudder trims as follows:     
	![Flight modes settings](/Screenshots/trims.PNG)  
	Set the rudder and Aileron trims to “`--`” for every flight mode you use.  
	XLITE users Use the Aileron or Elevator trims (Rudder requires the use of the shift button).  
	3. Set each FM in Model Global Variable 8 and 9 to refer back to FM0  These two are used to select the song and the playlist respectively.  
	![Flight modes settings](/Screenshots/Global.PNG)  
	4. Set “LOGICAL SWITCHES” settings as follows:  
	![Logical Switch Settings](/Screenshots/LogicalSwitch.PNG)  
	5.  Set the Special Functions SF 58-64 as follows:  
	**SF63 will automatically be installed and updated by the program.  
	![Special Function Settings](/Screenshots/SpecialFunction.PNG)  
	7. Under Telemetry “DISPLAY” Choose to display `Script iTunes`  
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
2. The song will automaticlly play.  
## This allows you to change playlists or music without having to look at the radio heeping you model in sight.   
