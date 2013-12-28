#comments-start

 Locky
  given an ini file with [LOCK_FILES] and [UNLOCK_FILES]
  lock the files in the [LOCK_FILES] list if not already locked
  show a button that has [refresh from file]

-stories
- basic GUI Flow - done
- create a basic ini file - done
- create lock file function - done
- create unlock file function - done
- lock a file - done
- unlock a file - done

- further stories
create dynamic array of files rather than max out at 64
create a proper GUI which displays the files locked and has buttons to refresh and unlock/exit
drag file onto app, if file, add to list



list: 
Lock exclusive
lock read write
Lock write
Lock read
unlocked
temporarily delete

button to explore file folder path

only 64 files can be managed by AutoIT so use an array of size 64 and find the next empty slot - 64 limit may not be a problem if we use the API






for locky

shows calling a kernel dll call
http://www.autoitscript.com/forum/index.php?showtopic=22056&hl=createfile


here is createFile API
http://msdn2.microsoft.com/en-us/library/aa363858.aspx

here is lockfileex
http://msdn2.microsoft.com/en-us/library/aa365203.aspx

here is lockfile
http://msdn2.microsoft.com/en-us/library/aa365202.aspx

autoit fileAPI commands

http://www.autoitscript.com/forum/index.php?showtopic=12604&hl=File+API

drag and drop files
http://www.autoitscript.com/forum/index.php?showtopic=28062&hl=drag+file


This might show how to lock a folder (ala winpooch)
http://www.planet-source-code.com/vb/scripts/ShowCode.asp?txtCodeId=61212&lngWId=1


#comments-end


#include "ini_lock_files.au3"

ini_set_ini_file_name(@ScriptDir & "\" & "locky.ini")

#include "locked_file_manager.au3"

lfm_clear_file_collection()
		
;get the ini file in the path of the executable
if not ini_ini_file_exists() Then
	msgbox(4096,"Missing Config File for Locky", "Could not find " & ini_get_ini_file_name())
EndIf






; INI FILE HANDLING FUNCTIONS

func process_iniFile()
	
; can use iniReadSectionNames to get all the section names to allow us to run some Scripts
	
ini_open_the_ini_file()

$errorReport = ""
$reportErrors = 0
		
if @error Then
	; start section does not exist
	$errorReport = "LOCK_FILES section does not exist or is empty" & @lf
	$reportErrors = 1
	;unlock any locked files
	lfm_unlock_all_files()
	
Else
	$numberOfFiles = ini_get_number_of_files_to_lock()
	
	;find any locked files that are not in the inifile and unlock them
	; unlock first to free up any space needed

		$number_of_locked_files = lfm_number_of_fileslots()
		for $i = 1 to $number_of_locked_files
			$foundFile = 0
			if lfm_get_locked_file_path($i) <> "" then
				for $ff = 1 to $numberOfFiles
					if ini_get_filename_for_file_at_index($ff)=lfm_get_locked_file_path($i) Then
						$foundFile = 1
						ExitLoop
					endif 
				next 
				if $foundFile = 0 then 
					consolewrite("unlocking " & lfm_get_locked_file_path($i) & @lf)
					lfm_unlockThisFileID($i)
				endif
			endif
		next	
	
	; lock the files in the ini file
		for $i = 1 to $numberOfFiles
			$lockThisFileName = ini_get_filename_for_file_at_index($i)
			consolewrite("locking " & $lockThisFileName & @lf)
			$retLockCode = lfm_lockThisFile($lockThisFileName)
			select 
				case $retLockCode = -2 
					$errorReport = $errorReport & "Could not FIND file: " & $lockThisFileName & @lf
					$reportErrors = 1
					; an error occured during the lock for this file
					; could not find file
				case $retLockCode = -1
					; maximum files exceeded - do not try any more
					$errorReport = $errorReport & "Maximum Files Locked - not all files locked." & @lf
					$reportErrors = 1
					ExitLoop
				case $retLockCode = 0
					; general error locking file
					$errorReport = $errorReport & "Could not LOCK file: " & $lockThisFileName & @lf
					$reportErrors = 1
			endselect
		next
		

endif 
	
	if $reportErrors = 1 Then
		msgbox(4096,"Errors encountered locking files", $errorReport)
	endif 

EndFunc



#include "lockygui.au3"

; The GUI Main Process
process_iniFile()
GUI_simpleGUI()

;GUI_createLockyGUI()
;GUI_processGUIEvents()