locky
=====

A simple file locking test tool written in AutoIt

create a locky.ini file

files to be locked are put in a [LOCK_FILES] section
any other sections are ignored

files are on the left hand side of the .ini list e.g.

c:\filetolock.txt =

the value on the right hand side of the .ini file (after the = ) is ignored
if the filename does not have an = after it then it will be ignored

file paths can be
- full paths e.g. c:\program files\someprogram\somedatafile.dat
- filenames e.g. locky.ini (the file has to be in the same dir as the locky program)
- relative e.g. ..\afile_in_the_directory_above.txt (relative to the locky program location)

run locky
[retry] reloads the ini file and locks any new files in the init section
[cancel] closes the program and releases the locks

if a file is locked and [retry] is pressed then the lock is not released 

a maximum of 64 files can be locked 


FAQ
===
If a file is locked and I press retry then is the lock temporarily lost?
- no the lock is not temporarily lost

If I just close the window is the lock retained?
- no the lock is lost when locky is closed