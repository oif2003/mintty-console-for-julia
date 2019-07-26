/*
Requires Autohotkey v2
Tested with Autohotkey v2 H 2.0-alpha on 25 Jul 2019
*/

#SingleInstance force

;Setup paths and commands
cygwin64bin  := A_ScriptDir "\CygwinPortable\App\Runtime\Cygwin\bin" ;https://github.com/MachinaCore/CygwinPortable

;rename user directory otherwise windows emojis will not load										
Loop Files, A_ScriptDir "\CygwinPortable\App\Runtime\Cygwin\home\*", "D" {						
	folderpath := A_LoopFileFullPath															
} DirMove(folderpath, A_ScriptDir "\CygwinPortable\App\Runtime\Cygwin\home\" A_UserName, "R")	 							

;find latest version of Julia installed
UninstallKeys := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall"
Loop Reg, UninstallKeys, "RKV" {
	InStr(A_LoopRegName, "julia 1.") && (A_LoopRegName > currJulia) && (currJulia := A_LoopRegName)
} SplitPath(RegRead(UninstallKeys "\" currJulia, "DisplayIcon"), , juliabin)	;you can also set juliabin yourself

;mintty will be unstable if we don't set path to cygwin bin
commands := "set PATH=%PATH%;" cygwin64bin "`n`n" "mintty.exe " juliabin "\julia.exe"
shell := ComObjCreate("WScript.Shell")
exec := shell.Exec(A_ComSpec " /Q /K echo off")
exec.StdIn.WriteLine("set PATH=%PATH%;" cygwin64bin "`n`n" "mintty.exe " juliabin "\julia.exe`nexit")

  
