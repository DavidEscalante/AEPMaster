--------------------------------------------------------------------------------------------

set LOADdesktop to POSIX path of (path to desktop as text)
set strPath to POSIX file LOADdesktop
set AEPfile to choose file with prompt "Selecciona un archivo .aep" of type {"AEP"} ¬
	default location strPath
tell (info for AEPfile) to set {Nm, Ex} to {name, name extension}
set AEPname to text 1 thru ((get offset of "." & Ex in Nm) - 1) of Nm
set inputFilePath to quoted form of (POSIX path of AEPfile)
tell application "System Events" to set RENDERfolder to POSIX path of container of AEPfile
--------------------------------------------------------------------------------------------

set AEPfps to the text returned of (display dialog "OUTPUT FPS" default answer "24" with icon note buttons {"Cancel", "Continue"} default button "Continue")

set ShutdownTriggerOptions to {yes, no}
set SHUTDOWNtrigger to choose from list ShutdownTriggerOptions with prompt "Shutdown system after completion?" default items {no}

set NUMBERofinstances to the text returned of (display dialog "Render instances (Max 10)" default answer "1" with icon note buttons {"Cancel", "Continue"} default button "Continue")






-- //////////////////////////////////////// ▼ YOU MIGHT WANT TO CHANGE THIS ▼

set AErenderengine to quoted form of POSIX path of "Applications:Adobe After Effects 2020:aerender"

-- //////////////////////////////////////// ▲ YOU MIGHT WANT TO CHANGE THIS ▲









set SAVEFINAL to POSIX path of (choose folder with prompt "Where do you want to save the .mp4 file?")

-- LISTA DE SCRIPS
set P1carpetaRENDER to ("mkdir -p " & "'" & RENDERfolder & "/" & "_OUTPUT" & "'")

-- AERENDER
set P2renderAIFF to (AErenderengine & space & "-project" & space & inputFilePath & space & "-comp" & space & quoted form of AEPname & space & "-RStemplate 'Best Settings' -OMtemplate 'AIFF 48kHz' -output" & space & quoted form of (RENDERfolder & "/" & "_OUTPUT" & "/audio.aif"))
set P3renderPSD to (AErenderengine & space & "-project" & space & inputFilePath & space & "-comp" & space & quoted form of AEPname & space & "-RStemplate 'Multi-Machine Settings' -OMtemplate 'Multi-Machine Sequence' -output" & space & quoted form of (RENDERfolder & "/" & "_OUTPUT" & "/[#####].psd"))

-- FMPEG
set P4renderMOV to (LOADdesktop & "ae_multicore/ffmpeg -f image2 -r" & space & AEPfps & space & "-i" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "/%05d.psd" & "'" & space & "-i" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "/audio.aif" & "'" & space & "-shortest -c:v prores_ks -profile:v 3 -r" & space & AEPfps & space & "'" & RENDERfolder & "/" & AEPname & ".mov" & "'" & space & "-y")
-- MP4:PRE
set P5MP4 to (LOADdesktop & "ae_multicore/ffmpeg -f image2 -r" & space & AEPfps & space & "-i" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "/%05d.psd" & "'" & space & "-i" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "/audio.aif" & "'" & space & "-pix_fmt yuv420p -c:v libx264 -preset veryslow -crf 12 -r" & space & AEPfps & space & "'" & RENDERfolder & "/" & AEPname & ".mp4" & "'" & space & "-y")
-- MP4:POST
set P5MP4consonido to (LOADdesktop & "ae_multicore/ffmpeg -i" & space & "'" & RENDERfolder & "/" & AEPname & ".mp4" & "'" & space & "-i" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "/audio.aif" & "'" & space & "-c:v copy -map 0:v:0 -map 1:a:0" & space & "'" & SAVEFINAL & "/" & AEPname & ".mp4" & "'" & space & "-y")
-- display dialog P2renderAIFF as text

-- CREA: Carpetas de contenidos
do shell script P1carpetaRENDER

-- INICIA RENDER
-- do shell script "afplay " & AUFXstart
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
			
			set S1 to create window with profile "aftereffects"
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


-- ==========================================================================================================================================================================
if NUMBERofinstances = "1" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text P3renderPSD
			
		end tell
	end tell
end if

if NUMBERofinstances = "2" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text P3renderPSD
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
		end tell
	end tell
end if

if NUMBERofinstances = "3" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text P3renderPSD
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S3 to split vertically with profile "aftereffects"
			
			tell S3
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
		end tell
	end tell
end if

if NUMBERofinstances = "4" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text P3renderPSD
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S3 to split vertically with profile "aftereffects"
			
			tell S3
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S4 to split vertically with profile "aftereffects"
			
			tell S4
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
		end tell
	end tell
end if

if NUMBERofinstances = "5" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text P3renderPSD
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S3 to split vertically with profile "aftereffects"
			
			tell S3
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S4 to split vertically with profile "aftereffects"
			
			tell S4
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S5 to split vertically with profile "aftereffects"
			
			tell S5
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
		end tell
	end tell
end if

if NUMBERofinstances = "6" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text P3renderPSD
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S3 to split vertically with profile "aftereffects"
			
			tell S3
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S4 to split vertically with profile "aftereffects"
			
			tell S4
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S5 to split vertically with profile "aftereffects"
			
			tell S5
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S6 to split vertically with profile "aftereffects"
			
			tell S6
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
		end tell
	end tell
end if

if NUMBERofinstances = "7" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text P3renderPSD
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S3 to split vertically with profile "aftereffects"
			
			tell S3
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S4 to split vertically with profile "aftereffects"
			
			tell S4
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S5 to split vertically with profile "aftereffects"
			
			tell S5
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S6 to split vertically with profile "aftereffects"
			
			tell S6
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S7 to split vertically with profile "aftereffects"
			
			tell S7
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
		end tell
	end tell
end if

if NUMBERofinstances = "8" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text P3renderPSD
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S3 to split vertically with profile "aftereffects"
			
			tell S3
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S4 to split vertically with profile "aftereffects"
			
			tell S4
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S5 to split vertically with profile "aftereffects"
			
			tell S5
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S6 to split vertically with profile "aftereffects"
			
			tell S6
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S7 to split vertically with profile "aftereffects"
			
			tell S7
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S8 to split vertically with profile "aftereffects"
			
			tell S8
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
		end tell
	end tell
end if

if NUMBERofinstances = "9" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text P3renderPSD
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S3 to split vertically with profile "aftereffects"
			
			tell S3
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S4 to split vertically with profile "aftereffects"
			
			tell S4
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S5 to split vertically with profile "aftereffects"
			
			tell S5
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S6 to split vertically with profile "aftereffects"
			
			tell S6
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S7 to split vertically with profile "aftereffects"
			
			tell S7
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S8 to split vertically with profile "aftereffects"
			
			tell S8
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S9 to split vertically with profile "aftereffects"
			
			tell S9
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
		end tell
	end tell
end if

if NUMBERofinstances = "10" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text P3renderPSD
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S3 to split vertically with profile "aftereffects"
			
			tell S3
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S4 to split vertically with profile "aftereffects"
			
			tell S4
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S5 to split vertically with profile "aftereffects"
			
			tell S5
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S6 to split vertically with profile "aftereffects"
			
			tell S6
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S7 to split vertically with profile "aftereffects"
			
			tell S7
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S8 to split vertically with profile "aftereffects"
			
			tell S8
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S9 to split vertically with profile "aftereffects"
			
			tell S9
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
			set S10 to split vertically with profile "aftereffects"
			
			tell S10
				set name to (AEPname)
				write text P3renderPSD
			end tell
			
		end tell
	end tell
end if
-- ==========================================================================================================================================================================





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
	set AUDIOseconds to do shell script ("/usr/local/bin/mediainfo --Inform=\"Audio;%Duration%\" " & "'" & RENDERfolder & "/" & "_OUTPUT" & "/audio.aif" & "'")
on error
	-- skip
end try

set VIDEOseconds to 0

repeat until VIDEOseconds ≥ AUDIOseconds -- LOOP UNTIL FILE IS CORRECT
	
	try
		display notification (AEPname & ": Rendering MOV...")
		do shell script P4renderMOV
	on error
		try
			tell application "iTerm"
				
				set S1 to create window with profile "ffmpeg"
				tell current session of S1
					set name to (AEPname & space & "RENDER MOV")
					write text P4renderMOV
					
				end tell
			end tell
		on error
			beep 1
			display notification (AEPname & ": ERROR (MOV)")
			error number -128 -- user canceled
		end try
	end try
	
	delay 5
	
	try
		set AUDIOseconds to do shell script ("/usr/local/bin/mediainfo --Inform=\"Audio;%Duration%\" " & "'" & RENDERfolder & "/" & "_OUTPUT" & "/audio.aif" & "'")
	on error
		-- skip
	end try
	
	set AUDIOseconds to (round (AUDIOseconds / 1000)) -- ROUND OUTPUT
	try
		set VIDEOseconds to do shell script ("/usr/local/bin/mediainfo --Inform=\"Video;%Duration%\" " & "'" & RENDERfolder & "/" & AEPname & ".mov" & "'")
	on error
		-- skip
	end try
	set VIDEOseconds to (round (VIDEOseconds / 1000)) -- ROUND OUTPUT
	
	if VIDEOseconds < AUDIOseconds then
		display notification ("ERROR: " & AEPname & ", Audio y Video no son iguales")
		
		try
			do shell script P2renderAIFF
			do shell script P3renderPSD
		on error
			display notification (AEPname & ": aerendercore crashed")
		end try
		
		do shell script ("find" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "'" & space & "-size 0 -delete") -- delete all size 0 files
		do shell script ("find" & space & "'" & RENDERfolder & "/" & "_OUTPUT" & "'" & space & "-iname *AEtemp* | xargs -I {} rm -rf {}") -- delete aditional after effects garbage
	else
		display notification (AEPname & ": Iniciando MP4s...")
	end if
	
end repeat

-- =============================================================================================================== [      MP4 CODES     ]


try
	do shell script P5MP4
on error
	try
		tell application "iTerm"
			
			set S1 to create window with profile "ffmpeg"
			tell current session of S1
				set name to (AEPname & space & "MP4 sin sonido")
				write text P5MP4
				
			end tell
		end tell
	on error
		beep 1
		display notification (AEPname & ": ERROR (MP4 sin sonido)")
		error number -128 -- user canceled
	end try
end try

delay 5

try
	do shell script P5MP4consonido
on error
	try
		tell application "iTerm"
			
			set S1 to create window with profile "ffmpeg"
			tell current session of S1
				set name to (AEPname & space & "MP4 con sonido")
				write text P5MP4consonido
				
			end tell
		end tell
	on error
		beep 1
		display notification (AEPname & ": ERROR (MP4 con sonido)")
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
