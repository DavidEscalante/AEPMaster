tell application "aep_master"
	activate
end tell

-- //////////////////////////////////////// ▼ IF YOU HAVE A DIFERENT AE VERSION, YOU MIGHT WANT TO CHANGE THIS ▼

set AErenderengine to quoted form of POSIX path of "Applications:Adobe After Effects 2020:aerender"

-- //////////////////////////////////////// ▲ IF YOU HAVE A DIFERENT AE VERSION, YOU MIGHT WANT TO CHANGE THIS ▲

tell application "System Events" to set myAPPpath to POSIX path of (path to me)

-- CHECK IF AFTER EFFECTS IS MISSING
set ffmpegexists to do shell script "
#!/bin/bash
if [ -e" & space & AErenderengine & space & "]
then
    echo \"yes\"
else
    echo \"no\"
fi
"
if (ffmpegexists contains yes) then
	-- continue
else
	display dialog "ERROR: couldnt find After Effects CC 2020, you might need to change the code" as text with icon note buttons {"=("}
	error number -128 -- user canceled
end if

-- CHECK IF FFMPEG IS MISSING
set ffmpegexists to do shell script "
#!/bin/bash
if [ -e" & space & quoted form of (myAPPpath & "/Contents/Resources/ffmpeg") & space & "]
then
    echo \"yes\"
else
    echo \"no\"
fi
"
if (ffmpegexists contains yes) then
	-- continue
else
	display dialog "ERROR: ffmpeg file is missing" as text with icon note buttons {"=("}
	error number -128 -- user canceled
end if

-- CHECK IF MEDIAINFO IS MISSING
set ffmpegexists to do shell script "
#!/bin/bash
if [ -e" & space & quoted form of (myAPPpath & "/Contents/Resources/mediainfo") & space & "]
then
    echo \"yes\"
else
    echo \"no\"
fi
"
if (ffmpegexists contains yes) then
	-- continue
else
	display dialog "ERROR: mediainfo file is missing" as text with icon note buttons {"=("}
	error number -128 -- user canceled
end if

--------------------------------------------------------------------------------------------
set LOADdesktop to POSIX path of (path to desktop as text)
set strPath to POSIX file LOADdesktop
set AEPfile to choose file with prompt "Choose an .aep file" of type {"AEP"} ¬
	default location strPath
tell (info for AEPfile) to set {Nm, Ex} to {name, name extension}
set AEPname to text 1 thru ((get offset of "." & Ex in Nm) - 1) of Nm
set inputFilePath to quoted form of (POSIX path of AEPfile)
tell application "System Events" to set RENDERfolder to POSIX path of container of AEPfile
--------------------------------------------------------------------------------------------



-- //////////////////////////////////////// ▼ USER INPUT ▼
set AEPfps to the text returned of (display dialog "OUTPUT FPS" default answer "24" with icon note buttons {"Cancel", "Continue"} default button "Continue")

set ShutdownTriggerOptions to {yes, no}
set SHUTDOWNtrigger to choose from list ShutdownTriggerOptions with prompt "Shutdown system after completion?" default items {no}

set aerender_clone to 0
set NUMBERofinstances to 0

repeat until NUMBERofinstances is greater than 0
	set NUMBERofinstances to the text returned of (display dialog "Render instances" default answer "1" with icon note buttons {"Cancel", "Continue"} default button "Continue")
	if NUMBERofinstances is less than 1 then
		display dialog "Atleast 1 instance must be selected" with icon note buttons {"sure, ok"} default button "sure, ok"
	else if NUMBERofinstances is greater than 32 then
		display dialog "We recomend a maximum of 32, still want to continue?" with icon note buttons {"No", "Yes"} default button "No"
		set NUMBERofinstances to 0
	else
		set aerender_clone to NUMBERofinstances
	end if
end repeat

set SAVEFINAL to POSIX path of (choose folder with prompt ¬
	"Where do you want to save the .mp4 file?" default location strPath)
-- //////////////////////////////////////// ▲ USER INPUT ▲


-- //////////////////////////////////////// ▼ THE NERDY STUFF ▼
-- LISTA DE SCRIPS
set P1carpetaRENDER to ("mkdir -p " & "'" & RENDERfolder & "/" & "_OUTPUT" & "'")

-- AERENDER
set P2renderAIFF to (AErenderengine & space & "-project" & space & inputFilePath & space & "-comp" & space & quoted form of AEPname & space & "-RStemplate 'Best Settings' -OMtemplate 'AIFF 48kHz' -output" & space & quoted form of (RENDERfolder & "/" & "_OUTPUT" & "/audio.aif") & "; exit")
set P3renderPSD to (AErenderengine & space & "-project" & space & inputFilePath & space & "-comp" & space & quoted form of AEPname & space & "-RStemplate 'Multi-Machine Settings' -OMtemplate 'Multi-Machine Sequence' -output" & space & quoted form of (RENDERfolder & "/" & "_OUTPUT" & "/[#####].psd") & space & "&& sleep 5s; exit")

-- FMPEG
set P4renderMOV to (quoted form of (myAPPpath & "/Contents/Resources/ffmpeg") & space & "-f image2 -r" & space & AEPfps & space & "-i" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "/%05d.psd" & "'" & space & "-i" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "/audio.aif" & "'" & space & "-shortest -c:v prores_ks -profile:v 3 -r" & space & AEPfps & space & "'" & RENDERfolder & "/" & AEPname & ".mov" & "'" & space & "-y" & "&& sleep 5s; exit")
-- MP4:PRE
set P5MP4 to (quoted form of (myAPPpath & "/Contents/Resources/ffmpeg") & space & "-f image2 -r" & space & AEPfps & space & "-i" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "/%05d.psd" & "'" & space & "-i" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "/audio.aif" & "'" & space & "-pix_fmt yuv420p -c:v libx264 -preset veryslow -crf 12 -r" & space & AEPfps & space & "'" & RENDERfolder & "/" & AEPname & ".mp4" & "'" & space & "-y" & "&& sleep 5s; exit")
-- MP4:POST
set P5MP4consonido to (quoted form of (myAPPpath & "/Contents/Resources/ffmpeg") & space & "-i" & space & "'" & RENDERfolder & "/" & AEPname & ".mp4" & "'" & space & "-i" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "/audio.aif" & "'" & space & "-c:v copy -map 0:v:0 -map 1:a:0" & space & "'" & SAVEFINAL & "/" & AEPname & ".mp4" & "'" & space & "-y" & "&& sleep 5s; exit")

-- CREA: Carpetas de contenidos
do shell script P1carpetaRENDER

-- INICIA RENDER
display notification "Renderizando " & AEPname & "..." -- OSX NOTIFICATION 
do shell script ("find" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "'" & space & "-size 0 -delete") -- delete all size 0 files
do shell script ("find" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "'" & space & "-iname *AEtemp* | xargs -I {} rm -rf {}") -- delete aditional after effects garbage

-- RENDER AIFF
try
	do shell script P2renderAIFF
on error
	beep 1
	display notification (AEPname & ": aerendercore crashed")
	try
		tell application "iTerm"
			
			set S1 to create window with profile "Default"
			tell current session of S1
				set name to (AEPname & space & "RENDER AIFF")
				write text P2renderAIFF
				
			end tell
		end tell
	on error
		error number -128 -- user canceled
	end try
end try

-- RENDER PSD's

-- ===============================================
repeat until aerender_clone = 0
	tell application "Terminal"
		tell application "Terminal" to activate
		tell application "System Events" to tell process "Terminal" to keystroke "t" using command down
		delay 0.5
		do script P3renderPSD in selected tab of the front window
	end tell
	set aerender_clone to aerender_clone - 1
end repeat
-- ===============================================
set aerender_clone to NUMBERofinstances

try
	do shell script P3renderPSD
on error
	display notification (AEPname & ": aerendercore crashed")
end try

delay 1

do shell script ("find" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "'" & space & "-size 0 -delete") -- delete all size 0 files
do shell script ("find" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "'" & space & "-iname *AEtemp* | xargs -I {} rm -rf {}") -- delete aditional after effects garbage

delay 1

-- ======================================== CHECK .MOV INTEGRITY AGASINT AUDIO AIF FILE

try
	set AUDIOseconds to do shell script (quoted form of (myAPPpath & "/Contents/Resources/mediainfo") & space & "--Inform=\"Audio;%Duration%\" " & "'" & RENDERfolder & "/" & "_OUTPUT" & "/audio.aif" & "'")
on error
	-- skip
end try

set VIDEOseconds to 0

repeat until VIDEOseconds ≥ AUDIOseconds -- LOOP UNTIL FILE IS CORRECT
	
	try
		display notification (AEPname & ": Creating MOV...")
		do shell script P4renderMOV
	on error
		try
			tell application "iTerm"
				activate
				set ffmpegdebbug to create window with profile "Default"
				tell ffmpegdebbug
					tell current session of ffmpegdebbug
						set name to (AEPname & space & "RENDER MOV")
						write text P4renderMOV
					end tell
					repeat while (exists ffmpegdebbug)
						delay 1
					end repeat
				end tell
			end tell
		on error
			beep 1
			display notification (AEPname & ": ERROR creating the .mov file)")
			error number -128 -- user canceled
		end try
	end try
	
	delay 5
	
	try
		set AUDIOseconds to do shell script (quoted form of (myAPPpath & "/Contents/Resources/mediainfo") & space & "--Inform=\"Audio;%Duration%\" " & "'" & RENDERfolder & "/" & "_OUTPUT" & "/audio.aif" & "'")
	on error
		-- skip
	end try
	
	set AUDIOseconds to (round (AUDIOseconds / 1000)) -- ROUND OUTPUT
	try
		set VIDEOseconds to do shell script (quoted form of (myAPPpath & "/Contents/Resources/mediainfo") & space & "--Inform=\"Video;%Duration%\" " & "'" & RENDERfolder & "/" & AEPname & ".mov" & "'")
	on error
		-- skip
	end try
	set VIDEOseconds to (round (VIDEOseconds / 1000)) -- ROUND OUTPUT
	
	if VIDEOseconds < AUDIOseconds then
		display notification ("ERROR: " & AEPname & ", AIFF and MOV dont match")
		
		try
			do shell script P2renderAIFF
			
			tell application "Terminal"
				activate
				reopen
			end tell
			-- ===============================================
			repeat until aerender_clone = 0
				tell application "Terminal"
					tell application "System Events"
						keystroke "t" using {command down}
					end tell
					do script P3renderPSD in selected tab of the front window
				end tell
				set aerender_clone to aerender_clone - 1
			end repeat
			-- ===============================================
			set aerender_clone to NUMBERofinstances
			
			
			do shell script P3renderPSD
		on error
			display notification (AEPname & ": aerendercore crashed, trying again...")
		end try
		
		do shell script ("find" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "'" & space & "-size 0 -delete") -- delete all size 0 files
		do shell script ("find" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "'" & space & "-iname *AEtemp* | xargs -I {} rm -rf {}") -- delete aditional after effects garbage
	else
		display notification (AEPname & ": Creating MP4...")
	end if
	
end repeat

-- =============================================================================================================== [      MP4 CODES     ]

try
	do shell script P5MP4
on error
	try
		tell application "iTerm"
			activate
			set ffmpegdebbugMP4 to create window with profile "Default"
			tell ffmpegdebbugMP4
				tell current session of ffmpegdebbugMP4
					set name to (AEPname & space & "MP4, no sound")
					write text P5MP4
				end tell
				repeat while (exists ffmpegdebbugMP4)
					delay 1
				end repeat
			end tell
		end tell
	on error
		beep 1
		display notification (AEPname & ": ERROR creating the .mp4 file")
		error number -128 -- user canceled
	end try
end try

delay 5

try
	do shell script P5MP4consonido
on error
	try
		tell application "iTerm"
			activate
			set ffmpegdebbugSound to create window with profile "Default"
			tell ffmpegdebbugSound
				tell current session of ffmpegdebbugSound
					set name to (AEPname & space & "MP4, merge with sound file")
					write text P5MP4consonido
				end tell
				repeat while (exists ffmpegdebbugSound)
					delay 1
				end repeat
			end tell
		end tell
	on error
		beep 1
		display notification (AEPname & ": ERROR merging the .mp4 with the sound file")
		error number -128 -- user canceled
	end try
end try

try
	do shell script ("rm -rf" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "'")
on error
	display notification (AEPname & ":" & space & "ERROR TEMP_RENDER FOLDER")
end try

-- ///////// SHUTDOWN COMPUTER IF...
if (SHUTDOWNtrigger contains no) then
	-- do nothing
else
	display notification ("shuting down in 30 seconds, CLOSE App to abort...")
	delay 30
	do shell script "osascript -e 'tell app \"System Events\" to shut down'"
end if
-- //////////////////////////////////////// ▲ THE NERDY STUFF ▲
