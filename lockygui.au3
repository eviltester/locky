;locky GUI


#include "..\..\AutoIt3\Include\GUIConstants.au3"

global $GUI_lockedFileList
global $button

func GUI_simpleGUI()
	local $reDisplay=1
	while $redisplay
		; 4 = retry
		 if msgbox(5+16+4096,"Locky", "Has Locked:" & @lf & lfm_lockedFileNames()) = 4 then 
			 ;reload the details
			 process_iniFile()
		 Else
			;close all the open files
			$reDisplay = 0
		endif
	wend
EndFunc

func GUI_createLockyGUI()
	GUICreate("Locky",220,250, 100,200,-1,$WS_EX_ACCEPTFILES)
	GUISetBkColor (0x00E0FFFF)  ; will change background color
	
	$GUI_lockedFileList = GUICtrlCreateListView ("Path",10,10,200,150);,$LVS_SORTDESCENDING)

	
	$button = GUICtrlCreateButton ("Process Ini File",75,170,70,20)

	GUI_redisplayFileList()
;	$input1=GUICtrlCreateInput("",20,200, 150)
	GUICtrlSetState(-1,$GUI_ACCEPTFILES)   ; to allow drag and dropping
	GUISetState()
;	GUICtrlSetData($item2,"ITEM1",)
;	GUICtrlSetData($item3,"||COL33",)
;	GUICtrlDelete($item1)
EndFunc

func GUI_clearLockedFileList()
	GUICtrlDelete($GUI_lockedFileList)
	$GUI_lockedFileList = GUICtrlCreateListView ("Path",10,10,200,150);,$LVS_SORTDESCENDING)	
endfunc 

func GUI_addFilesToLockedFileList()
	Local $itemToAdd
	local $number_of_locked_files
	
		$number_of_locked_files = lfm_number_of_fileslots()
		for $i = 1 to $number_of_locked_files
			$itemToAdd=GUICtrlCreateListViewItem(lfm_get_locked_file_path($i),$GUI_lockedFileList)
		Next
endfunc 

func GUI_redisplayFileList()
	GUI_clearLockedFileList()
	GUI_addFilesToLockedFileList()
EndFunc

func GUI_processGUIEvents()
	Do
	  $msg = GUIGetMsg ()
		 
	   Select
		  Case $msg = $button
			 process_iniFile()
		  Case $msg = $GUI_lockedFileList
			 MsgBox(0,"listview", "clicked="& GUICtrlGetState($GUI_lockedFileList),2)
	   EndSelect
   Until $msg = $GUI_EVENT_CLOSE
EndFunc