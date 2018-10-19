TaraniTunes v2.2 
===========
*Awesome music player for FrSky radios.*  
*This is a seperate Advanced fork from the Original TaraniTunes developed by [GilDev](https://github.com/GilDev)*

Key Advances with this version
------------------------------
** Multiple Playlists (the code contains 8 seperate playlists)  
** Playlists are seperated by recognizable names you have chosen (3dflying, Practice, Competition)  
** On-screen confimation of the playlist selected (not just a number anymore)  
** Songs are changed automatically based on their length  
** On-Screen Flight Time and Telementry Information   

Compatible with FrSky’s [Taranis Q X7](https://www.frsky-rc.com/product/taranis-q-x7-2), [Taranis X9D](https://www.frsky-rc.com/product/taranis-x9d-plus-2) and their variants.
You need at least [OpenTX](http://www.open-tx.org) 2.2.

* Taranis Q X7  
  ![Taranis Q X7](Screenshots/TaraniTunesQX7.png)
* Taranis X9D  
  ![Taranis X9D](Screenshots/TaraniTunesX9D.PNG)

### Installation

A full working version for you to try on companion is available from my dropbox.  It uses your existing radio notifications as the sample music  [Download SD Card files](https://www.dropbox.com/sh/ojqjugozk2s4e9e/AADaXwY6DARqot-Jig9Xvx3Pa?dl=0) The Model file contains 1 model showing the use of the program.   

The “[Example](Example)” folder contains an example of the Taranis’ SD card structure. 
You currently need to have at least 5 songs in each directory for the script to work.  

1. On your computer:
	1. Edit both `main.lua` and `itunes.lua` to have your desired amount of playlists. Detailed instructions are in the file(s) comments. Place both `main.lua` and `iTunes.lua` in `/SCRIPT/TELEMETRY` on your SD card.  

	2. Create a folder "lists" under /SOUNDS
	
	3. Create seperate folders for each desired plylist on your SD card. The folder names should pertain to the music played.
Examples >> `/SOUNDS/lists/3dflying`, `/SOUNDS/lists/practice`, `/SOUNDS/lists/hardrock`, `/SOUNDS/lists/competition`

2. Create a "playlist.lua" file in each of those directories.
	1. I recommend using [`Mp3tag`](https://www.mp3tag.de/en/index.html) to create your playlists. It will automatically add the required informations in TaraniTunes’ format. *Please look at the instructions in [`Auto_Playlist`](/Auto_Playlist)*.

	2.  If you prefer to manually create the playlist files. Each line must be formatted like this:   
	`{"Song name", "SONG_FILENAME", duration},` 
		1. `Song name` is the full name, with artist if you want.
		2. `SONG_FILENAME` must be 6 characters or less. 
		3. `duration` is your song’s duration in seconds. *EXAMPLE - Your song is 3:45 long you would enter 225. For a 4:52 song enter 292. Simply calculate `minutes × 60 + seconds` to get your song’s duration. Song length can usually be found in the file’s properties.*  
		Look at “[Example/SOUNDS/lists/3dflying/playlist.lua](Example/SOUNDS/lists/3dflying/playlist.lua)” for an example of formatting.

	3. Put your corresponding songs `SONG_FILENAME.wav` in `/SOUNDS/en` if your radio is in English (otherwise replace `en` with your language). They must be converted to mono, preferably normalized, and encoded in Microsoft WAV 16-bits signed PCM at a 32 kHz sampling rate, you can use [Audacity](http://www.audacityteam.org) to do that, it works great. Remember the filename must be 6 characters or less or else it will not play.

3. On your Taranis (I’m going to explain how I setup my radio):
	1. Under Telementry “DISPLAY” Choose to display `Script iTunes`  
	![Display settings](Screenshots/DisplaySettings.png)
	2. Set “LOGICAL SWITCHES” settings as follows:  
	![Logical switch settings](Screenshots/LogicalSwitchSettings.PNG) 
	3. Set “FLIGHT MODES” model’s rudder trims as follows:     
	![Flight modes settings](Screenshots/FlightModesSettings.png)  
	In fact, put every rudder trim to “`--`” for every flight mode you use.
	4. Set “TIMER3” as follows:      
	![Timer settings](Screenshots/TaraniTunesTimer.PNG)   

There you go! Next section will explain how to use TaraniTunes.

### Usage

From the main screen, hold “Page” to access TaraniTunes.
1. Use the rotary encoder (Q X7) or the “+”/“-” (Taranis) buttons to sweep through songs.
2. Press “Enter” to choose a song to play.
3. Put the “SB” switch in the middle position to start playing. Put it back in the up position to stop/pause the song.
4. Put “SB” in the up position to select a random song from your playlist.
5. You can press throttle trims down and up to play next and previous song respectively.
6. When the song ends, the next song will automatically play and “Timer3” will be reset.
7. “Timer3” will also automatically resets if you change songs.

#### Changing Playlists

1. To change playlists press “MENU”.
2. A “Change Playlist Screen” will appear:  
![Change Playlist](Screenshots/ChangeList.png)     
3. Using **Rotary Switch S2**, select the playlist you want to play.
4. Press “ENTER”, your new playlist is loaded and begins playing.

Enjoy it as much as I do.
