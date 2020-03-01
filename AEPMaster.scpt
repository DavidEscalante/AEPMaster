-- //////////////////////////////////////// ▼ IF YOU HAVE A DIFERENT AE VERSION, YOU MIGHT WANT TO CHANGE THIS ▼

set AErenderengine to quoted form of POSIX path of "Applications:Adobe After Effects 2020:aerender"

-- //////////////////////////////////////// ▲ IF YOU HAVE A DIFERENT AE VERSION, YOU MIGHT WANT TO CHANGE THIS ▲

set LOADdesktop to POSIX path of (path to desktop as text)
tell application "System Events" to set myAPPpath to POSIX path of (path to me)

-- CHECK IF TERMINAL HAVE ACCESSIBILITY PRIVILEGES 
set createdummytext to ("touch" & space & quoted form of (LOADdesktop & "8CxsDP3m3XH8kuyrMhPocUGwboZbJd4.txt") & ";" & space & "exit")

tell application "Terminal"
	activate
	reopen
	delay 0.5
	set checkAccesibility to do script "osascript -e 'tell application \"System Events\" to tell process \"Terminal\" to keystroke \"n\" using command down'" & space & "&&" & space & createdummytext
	delay 0.5
	do script "exit" in selected tab of the front window
end tell

-- CHECK IF THE TEXT FILE MADE BY TERMINAL EXISTS

set checktextfile to do shell script "
#!/bin/bash
if [ -e" & space & quoted form of (LOADdesktop & "8CxsDP3m3XH8kuyrMhPocUGwboZbJd4.txt") & space & "]
then
    echo \"yes\"
else
    echo \"no\"
fi
"
delay 0.5
if (checktextfile contains yes) then
	do shell script "/bin/rm " & quoted form of (LOADdesktop & "8CxsDP3m3XH8kuyrMhPocUGwboZbJd4.txt")
	tell application "Terminal"
		do script "exit" in selected tab of the front window
	end tell
else
	tell application "aep_master"
		activate
		display dialog "Grant permission to Terminal to Accesibility: See video" as text with icon stop buttons {"OK"} default button "OK"
	end tell
	error number -128 -- user canceled
end if

tell application "aep_master"
	activate
end tell

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
set strPath to POSIX file LOADdesktop
set AEPfile to choose file with prompt "Choose an .aep file" of type {"AEP"} ¬
	default location strPath
tell (info for AEPfile) to set {Nm, Ex} to {name, name extension}
set AEPname to text 1 thru ((get offset of "." & Ex in Nm) - 1) of Nm
set inputFilePath to quoted form of (POSIX path of AEPfile)
tell application "System Events" to set RENDERfolder to POSIX path of container of AEPfile
--------------------------------------------------------------------------------------------



-- //////////////////////////////////////// ▼ USER INPUT ▼
set CompName to the text returned of (display dialog "Name of the comp to render" default answer AEPname with icon note buttons {"Cancel", "Continue"} default button "Continue")
set AEPfps to the text returned of (display dialog "OUTPUT FPS" default answer "24" with icon note buttons {"Cancel", "Continue"} default button "Continue")

set UserOptions to {yes, no}
set instancesmaxlimit to 20 as number
set aerender_clone to 0 as number
set USER_instances to 0 as number
set USERcanContinue to no

repeat until USERcanContinue contains yes
	repeat until USER_instances is greater than 0
		set USER_instances to (the text returned of (display dialog "Render instances" default answer 1 with icon note buttons {"Cancel", "Continue"} default button "Continue")) as number
		if USER_instances is less than 1 then
			display dialog "Atleast 1 instance must be selected" with icon note buttons {"sure, ok"} default button "sure, ok"
		else
			-- skip
		end if
	end repeat
	
	if USER_instances is greater than instancesmaxlimit then
		
		display dialog "We recomend a maximum of" & space & instancesmaxlimit & ", still want to continue?" with icon note buttons {"No, go back", "Yes, my computer can handle anything"} default button "No, go back"
		if button returned of result = "No, go back" then
			set USERcanContinue to no
			set USER_instances to 0 as number
		else
			if button returned of result = "Yes, my computer can handle anything" then
				set USERcanContinue to yes
			end if
		end if
	else
		set USERcanContinue to yes
	end if
end repeat

set aerender_clone to USER_instances

set SAVEFINAL to POSIX path of (choose folder with prompt ¬
	"Where do you want to save the .mp4 file?" default location strPath)

set SHUTDOWNtrigger to choose from list UserOptions with prompt "Shutdown system after completion?" default items {no}
-- //////////////////////////////////////// ▲ USER INPUT ▲


-- //////////////////////////////////////// ▼ THE NERDY STUFF ▼
-- LISTA DE SCRIPS
set P1carpetaRENDER to ("mkdir -p " & "'" & RENDERfolder & "/" & "_OUTPUT" & "_" & CompName & "'")

-- AERENDER
set P2renderAIFF to (AErenderengine & space & "-project" & space & inputFilePath & space & "-comp" & space & quoted form of CompName & space & "-RStemplate 'Best Settings' -OMtemplate 'AIFF 48kHz' -output" & space & quoted form of (RENDERfolder & "/" & "_OUTPUT" & "_" & CompName & "/audio.aif") & "; exit")
set P3renderPSD to (AErenderengine & space & "-project" & space & inputFilePath & space & "-comp" & space & quoted form of CompName & space & "-RStemplate 'Multi-Machine Settings' -OMtemplate 'Multi-Machine Sequence' -output" & space & quoted form of (RENDERfolder & "/" & "_OUTPUT" & "_" & CompName & "/[#####].psd") & space & "&& sleep 5s; exit")

-- FMPEG
set P4renderMOV to (quoted form of (myAPPpath & "/Contents/Resources/ffmpeg") & space & "-f image2 -r" & space & AEPfps & space & "-i" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "_" & CompName & "/%05d.psd" & "'" & space & "-i" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "_" & CompName & "/audio.aif" & "'" & space & "-shortest -c:v prores_ks -profile:v 3 -r" & space & AEPfps & space & "'" & RENDERfolder & "/" & CompName & ".mov" & "'" & space & "-y" & "&& sleep 5s; exit")
-- MP4:PRE
set P5MP4 to (quoted form of (myAPPpath & "/Contents/Resources/ffmpeg") & space & "-f image2 -r" & space & AEPfps & space & "-i" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "_" & CompName & "/%05d.psd" & "'" & space & "-i" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "_" & CompName & "/audio.aif" & "'" & space & "-pix_fmt yuv420p -c:v libx264 -preset veryslow -crf 12 -r" & space & AEPfps & space & "'" & RENDERfolder & "/" & CompName & ".mp4" & "'" & space & "-y" & "&& sleep 5s; exit")
-- MP4:POST
set P5MP4consonido to (quoted form of (myAPPpath & "/Contents/Resources/ffmpeg") & space & "-i" & space & "'" & RENDERfolder & "/" & CompName & ".mp4" & "'" & space & "-i" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "_" & CompName & "/audio.aif" & "'" & space & "-c:v copy -map 0:v:0 -map 1:a:0" & space & "'" & SAVEFINAL & "/" & CompName & ".mp4" & "'" & space & "-y" & "&& sleep 5s; exit")

-- CREA: Carpetas de contenidos
do shell script P1carpetaRENDER

-- INICIA RENDER
display notification "Renderizando " & CompName & "..." -- OSX NOTIFICATION 
do shell script ("find" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "_" & CompName & "'" & space & "-size 0 -delete") -- delete all size 0 files
do shell script ("find" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "_" & CompName & "'" & space & "-iname *AEtemp* | xargs -I {} rm -rf {}") -- delete aditional after effects garbage

-- RENDER AIFF
try
	do shell script P2renderAIFF
on error
	beep 1
	display notification (CompName & ": aerendercore crashed")
	try
		tell application "Terminal"
			activate
			set aedebbugaiff to do script (P2renderAIFF & "; exit")
			repeat while aedebbugaiff exists
				delay 1
			end repeat
		end tell
	on error
		error number -128 -- user canceled
	end try
end try

-- RENDER PSD's
(*
tell application "Terminal"
	activate
	do script P3renderPSD
	tell application "Terminal" to set custom title of tab 1 of front window to ("Rendering:" & space & CompName)
end tell

set aerender_clone to aerender_clone - 1
*)

tell application "Terminal"
	activate
	reopen
end tell
-- ===============================================
repeat until aerender_clone = 0
	tell application "Terminal"
		activate
		do script "osascript -e 'tell application \"System Events\" to tell process \"Terminal\" to keystroke \"t\" using command down'" & ";" & space & P3renderPSD in selected tab of the front window
		tell application "Terminal" to set custom title of tab 1 of front window to ("Rendering:" & space & CompName)
		delay 0.5
	end tell
	set aerender_clone to aerender_clone - 1
end repeat
-- ===============================================
tell application "Terminal"
	do script "exit" in selected tab of the front window
	delay 0.5
end tell
set aerender_clone to USER_instances

try
	do shell script P3renderPSD
on error
	display notification (CompName & ": aerendercore crashed")
	error number -128 -- user canceled
end try

delay 1

do shell script ("find" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "_" & CompName & "'" & space & "-size 0 -delete") -- delete all size 0 files
do shell script ("find" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "_" & CompName & "'" & space & "-iname *AEtemp* | xargs -I {} rm -rf {}") -- delete aditional after effects garbage

delay 1

-- ======================================== CHECK .MOV INTEGRITY AGASINT AUDIO AIF FILE

try
	set AUDIOseconds to do shell script (quoted form of (myAPPpath & "/Contents/Resources/mediainfo") & space & "--Inform=\"Audio;%Duration%\" " & "'" & RENDERfolder & "/" & "_OUTPUT" & "_" & CompName & "/audio.aif" & "'")
on error
	-- skip
end try

set VIDEOseconds to 0

repeat until VIDEOseconds ≥ AUDIOseconds -- LOOP UNTIL FILE IS CORRECT
	
	try
		display notification (CompName & ": Creating MOV...")
		do shell script P4renderMOV
	on error
		try
			tell application "Terminal"
				activate
				set ffmpegdebbug to do script P4renderMOV
				repeat while ffmpegdebbug exists
					delay 1
				end repeat
			end tell
		on error
			beep 1
			display notification (CompName & ": ERROR creating the .mov file)")
			error number -128 -- user canceled
		end try
	end try
	
	delay 1
	
	try
		set AUDIOseconds to do shell script (quoted form of (myAPPpath & "/Contents/Resources/mediainfo") & space & "--Inform=\"Audio;%Duration%\" " & "'" & RENDERfolder & "/" & "_OUTPUT" & "_" & CompName & "/audio.aif" & "'")
	on error
		-- skip
	end try
	
	set AUDIOseconds to (round (AUDIOseconds / 1000)) -- ROUND OUTPUT
	try
		set VIDEOseconds to do shell script (quoted form of (myAPPpath & "/Contents/Resources/mediainfo") & space & "--Inform=\"Video;%Duration%\" " & "'" & RENDERfolder & "/" & CompName & ".mov" & "'")
	on error
		-- skip
	end try
	set VIDEOseconds to (round (VIDEOseconds / 1000)) -- ROUND OUTPUT
	
	if VIDEOseconds < AUDIOseconds then
		display notification ("ERROR: " & CompName & ", AIFF and MOV dont match")
		
		try
			do shell script P2renderAIFF
			
			tell application "Terminal"
				activate
				reopen
			end tell
			-- ===============================================
			repeat until aerender_clone = 0
				tell application "Terminal"
					activate
					do script "osascript -e 'tell application \"System Events\" to tell process \"Terminal\" to keystroke \"t\" using command down'" & ";" & space & P3renderPSD in selected tab of the front window
					tell application "Terminal" to set custom title of tab 1 of front window to ("Rendering:" & space & CompName)
					delay 0.5
				end tell
				set aerender_clone to aerender_clone - 1
			end repeat
			-- ===============================================
			tell application "Terminal"
				do script "exit" in selected tab of the front window
				delay 0.5
			end tell
			
			do shell script P3renderPSD
		on error
			display notification (CompName & ": aerendercore crashed, trying again...")
		end try
		
		do shell script ("find" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "_" & CompName & "'" & space & "-size 0 -delete") -- delete all size 0 files
		do shell script ("find" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "_" & CompName & "'" & space & "-iname *AEtemp* | xargs -I {} rm -rf {}") -- delete aditional after effects garbage
	else
		display notification (CompName & ": Creating MP4...")
	end if
	
end repeat

-- =============================================================================================================== [      MP4 CODES     ]

try
	do shell script P5MP4
on error
	try
		tell application "Terminal"
			activate
			set ffmpegdebbugMP4 to do script P5MP4
			repeat while ffmpegdebbugMP4 exists
				delay 1
			end repeat
		end tell
	on error
		beep 1
		display notification (CompName & ": ERROR creating the .mp4 file")
		error number -128 -- user canceled
	end try
end try

delay 1

try
	do shell script P5MP4consonido
on error
	try
		tell application "Terminal"
			activate
			set ffmpegdebbugSound to do script P5MP4consonido
			repeat while ffmpegdebbugSound exists
				delay 1
			end repeat
		end tell
	on error
		beep 1
		display notification (CompName & ": ERROR merging the .mp4 with the sound file")
		error number -128 -- user canceled
	end try
end try

try
	do shell script ("rm -rf" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "_" & CompName & "'")
on error
	display notification (CompName & ":" & space & "ERROR TEMP_RENDER FOLDER")
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
