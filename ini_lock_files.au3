
Global $iniFilePath = ""
Global $iniLockFiles

func ini_set_ini_file_name($aPath)
	$iniFilePath = $aPath
endfunc 

func ini_get_ini_file_name()
	return $iniFilePath
endfunc 

func ini_ini_file_exists()
	return fileexists($iniFilePath)
endfunc 

func ini_open_the_ini_file()
	$iniLockFiles = IniReadSection($iniFilePath,"LOCK_FILES")
EndFunc

func ini_get_number_of_files_to_lock()
	return $iniLockFiles[0][0]
EndFunc

func ini_get_filename_for_file_at_index($anIndex)
	return $iniLockFiles[$anIndex][0]
EndFunc