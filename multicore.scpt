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

set NUMBERofinstances to the text returned of (display dialog "Render instances (Max 10)" default answer "1" with icon note buttons {"Cancel", "Continue"} default button "Continue")



-- //////////////////////////////////////// ▼ YOU MIGHT WANT TO CHANGE THIS ▼

set AErenderengine to quoted form of POSIX path of "Applications:Adobe After Effects 2020:aerender"

-- //////////////////////////////////////// ▲ YOU MIGHT WANT TO CHANGE THIS ▲



set MAINCODE to (AErenderengine & space & "-project" & space & inputFilePath & space & "-comp" & space & quoted form of AEPname & space & "-RStemplate 'Multi-Machine Settings' -OMtemplate 'Multi-Machine Sequence' -output" & space & quoted form of (RENDERfolder & "/" & "_OUTPUT" & "/[#####].psd"))

set P1carpetaRENDER to ("mkdir -p " & "'" & RENDERfolder & "/" & "_OUTPUT" & "'")
do shell script P1carpetaRENDER

if NUMBERofinstances = "1" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text MAINCODE
			
		end tell
	end tell
end if

if NUMBERofinstances = "2" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text MAINCODE
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text MAINCODE
			end tell
			
		end tell
	end tell
end if

if NUMBERofinstances = "3" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text MAINCODE
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S3 to split vertically with profile "aftereffects"
			
			tell S3
				set name to (AEPname)
				write text MAINCODE
			end tell
			
		end tell
	end tell
end if

if NUMBERofinstances = "4" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text MAINCODE
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S3 to split vertically with profile "aftereffects"
			
			tell S3
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S4 to split vertically with profile "aftereffects"
			
			tell S4
				set name to (AEPname)
				write text MAINCODE
			end tell
			
		end tell
	end tell
end if

if NUMBERofinstances = "5" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text MAINCODE
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S3 to split vertically with profile "aftereffects"
			
			tell S3
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S4 to split vertically with profile "aftereffects"
			
			tell S4
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S5 to split vertically with profile "aftereffects"
			
			tell S5
				set name to (AEPname)
				write text MAINCODE
			end tell
			
		end tell
	end tell
end if

if NUMBERofinstances = "6" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text MAINCODE
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S3 to split vertically with profile "aftereffects"
			
			tell S3
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S4 to split vertically with profile "aftereffects"
			
			tell S4
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S5 to split vertically with profile "aftereffects"
			
			tell S5
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S6 to split vertically with profile "aftereffects"
			
			tell S6
				set name to (AEPname)
				write text MAINCODE
			end tell
			
		end tell
	end tell
end if

if NUMBERofinstances = "7" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text MAINCODE
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S3 to split vertically with profile "aftereffects"
			
			tell S3
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S4 to split vertically with profile "aftereffects"
			
			tell S4
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S5 to split vertically with profile "aftereffects"
			
			tell S5
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S6 to split vertically with profile "aftereffects"
			
			tell S6
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S7 to split vertically with profile "aftereffects"
			
			tell S7
				set name to (AEPname)
				write text MAINCODE
			end tell
			
		end tell
	end tell
end if

if NUMBERofinstances = "8" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text MAINCODE
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S3 to split vertically with profile "aftereffects"
			
			tell S3
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S4 to split vertically with profile "aftereffects"
			
			tell S4
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S5 to split vertically with profile "aftereffects"
			
			tell S5
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S6 to split vertically with profile "aftereffects"
			
			tell S6
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S7 to split vertically with profile "aftereffects"
			
			tell S7
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S8 to split vertically with profile "aftereffects"
			
			tell S8
				set name to (AEPname)
				write text MAINCODE
			end tell
			
		end tell
	end tell
end if

if NUMBERofinstances = "9" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text MAINCODE
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S3 to split vertically with profile "aftereffects"
			
			tell S3
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S4 to split vertically with profile "aftereffects"
			
			tell S4
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S5 to split vertically with profile "aftereffects"
			
			tell S5
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S6 to split vertically with profile "aftereffects"
			
			tell S6
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S7 to split vertically with profile "aftereffects"
			
			tell S7
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S8 to split vertically with profile "aftereffects"
			
			tell S8
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S9 to split vertically with profile "aftereffects"
			
			tell S9
				set name to (AEPname)
				write text MAINCODE
			end tell
			
		end tell
	end tell
end if

if NUMBERofinstances = "10" then
	tell application "iTerm"
		
		set S1 to create window with profile "aftereffects"
		tell current session of S1
			set name to (AEPname)
			write text MAINCODE
			
			set S2 to split vertically with profile "aftereffects"
			
			tell S2
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S3 to split vertically with profile "aftereffects"
			
			tell S3
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S4 to split vertically with profile "aftereffects"
			
			tell S4
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S5 to split vertically with profile "aftereffects"
			
			tell S5
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S6 to split vertically with profile "aftereffects"
			
			tell S6
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S7 to split vertically with profile "aftereffects"
			
			tell S7
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S8 to split vertically with profile "aftereffects"
			
			tell S8
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S9 to split vertically with profile "aftereffects"
			
			tell S9
				set name to (AEPname)
				write text MAINCODE
			end tell
			
			set S10 to split vertically with profile "aftereffects"
			
			tell S10
				set name to (AEPname)
				write text MAINCODE
			end tell
			
		end tell
	end tell
end if
