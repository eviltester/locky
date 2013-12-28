; locked_file_manager

#include "APIFileReadWrite.au3"

; a psuedo class for the lockedFiles
global $maxFiles=64
Global $locked_files[$maxFiles+1][2] ; [i][0] = filename, [i][1] = handle
global $currFiles = 0
		
func lfm_clear_file_collection()
	for $i = 1 to $maxFiles
			lfm_set_locked_file_path($i,"")
			lfm_set_locked_file_handle($i,0)
	next
EndFunc

func lfm_number_of_fileslots()
	return $maxFiles
EndFunc

func lfm_lockedFileNames()
	$locked_text = ""
	
		for $i = 1 to $maxFiles
			$pathName = lfm_get_locked_file_path($i)
			if $pathName <> "" Then
				$locked_text = $locked_text & $pathName & @lf
			endif 
		next
	
	if $locked_text = "" Then
		$locked_text = "No Files Locked" & @lf
	EndIf
	
	return $locked_text
endfunc 

func lfm_get_locked_file_path($fileIndex)
	return $locked_files[$fileIndex][0]
endfunc 

func lfm_get_locked_file_handle($fileIndex)
	return $locked_files[$fileIndex][1]
endfunc 

func lfm_set_locked_file_path_and_handle($fileIndex,$thePath,$theHandle)
	 lfm_set_locked_file_path($fileIndex,$thePath)
	 lfm_set_locked_file_handle($fileIndex,$theHandle)
 endfunc
 
func lfm_set_locked_file_path($fileIndex,$thePath)
	 $locked_files[$fileIndex][0] = $thePath
endfunc 

func lfm_set_locked_file_handle($fileIndex,$theHandle)
	$locked_files[$fileIndex][1] = $theHandle
endfunc 

func lfm_unlock_all_files()
		for $i = 1 to $maxFiles
				if lfm_get_locked_file_path($i) <> "" Then
					lfm_unlockThisFileID($i)
				endif 
		next	
endfunc 
	
; utility functions to lock and unlock


func lfm_lockThisFile($aFileName)
	consolewrite("LOCK FILE " & $aFileName & @lf)
	
	; if the file does not exist then display a message box saying - file does not exist - return -2
	if not fileexists($aFileName) then
		consolewrite("Could not find file to lock " & $aFileName)
		return -2
	EndIf
	
	; run through all the files, check if name exists, and find first blank slot
	$foundIt=0
	$firstBlank = -1
	for $i = 1 to $maxFiles
		consolewrite("LOCKED FILES: " & $i & " " & lfm_get_locked_file_path($i) & @lf)
		if lfm_get_locked_file_path($i) = $aFileName Then	
			consolewrite("FOUND FILE @ " & $i & " " & lfm_get_locked_file_path($i) & " - " & $aFileName & @lf)
			$foundIt = 1
		endif 
		if $firstBlank = -1 then
			if lfm_get_locked_file_path($i) = "" Then
				$firstBlank = $i
			endif
		endif 
	next
	
	;check if aFileName is already locked, if it is do nothing - return 1
	if $foundIt = 1 then 
		consolewrite("ALREADY LOCKED FILE " & $aFileName & @lf)
		return 1
	endif 
	
	if $firstBlank = -1 then
		; if there are too many files then display a message box saying - too many files - return -1
		consolewrite("Maximum Number of Locks Exceeded " & $aFileName)
		return -1
	endif 
		
	$handle = _APIFileLock($aFileName)
	if $handle = 0 Then
		; if lock failed then return 0
		consolewrite("Could not lock file " & $aFileName)
		return 0
	else
		; if it is not locked then add it to the list and lock it - return 1
		consolewrite("FILE " & $firstBlank & " # " & $handle & " LOCKED " & $aFileName & @lf)
		lfm_set_locked_file_path_and_handle($firstBlank, $aFileName,$handle)
		
		return 1
	EndIf
	
endfunc 

func lfm_unlockThisFileID($anArrayPosition)
	consolewrite("UNLOCK FILE ID" & $anArrayPosition & @lf)
	
	; unlock the file which is at this position in the array
	_APIFileClose($locked_files[$anArrayPosition][1])
	
	; clear out this position in the array
	lfm_set_locked_file_path_and_handle($anArrayPosition, "",0)
		
endfunc 

func lfm_unlockThisFileName($aFileName)
	consolewrite("UNLOCK FILE " & $aFileName & @lf)
	
	; run through all the files, check if name exists, and unlock it
	$foundIt=0
	$firstBlank = -1
	for $i = 1 to $maxFiles
		if lfm_get_locked_file_path($i) = $aFileName Then	
			return lfm_unlockThisFileID($i)
		endif 
	next
	
	consolewrite("UNLOCK FILE NOT FOUND " & $aFileName & @lf)
endfunc 