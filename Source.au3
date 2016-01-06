#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Imgs\Icon.ico
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Fileversion=1.2.0.0
#AutoIt3Wrapper_Res_LegalCopyright=R.S.S.
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; *** Start added by AutoIt3Wrapper ***
#include <WinAPIConstants.au3>
; *** End added by AutoIt3Wrapper ***
;~ #AutoIt3Wrapper_Icon=Imgs\Icon.ico

#include <GUIConstantsEx.au3>

#include ".\Skins\Axis.au3"
#include "_UskinLibrary.au3"

_Uskin_LoadDLL()
_USkin_Init(_Axis(True))

Opt("GUIOnEventMode", 1)
Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)

Dim $Keys[33] = [32, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, "-", "=", "`", "[", "]", ";", "'", ",", ".", "/", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12"]
Dim $Alphabet[27] = [26, "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

Global $Modifier = "", $AltModifier, $CtrlModifier, $ShiftModifier, $HotKeyList, $CurrentHotKey = "", $HotKeyGui

$CurrentHotKey = IniRead(@ScriptDir & "/Data/Settings.ini", "Settings", "Hotkey", "NA")
HotKeySet($CurrentHotKey, "_Test")

$TrayMenuExit = TrayCreateItem("Exit...")
TrayItemSetOnEvent(-1, "_Exit")

$TrayMenuShowGui = TrayCreateItem("Show GUI...")
TrayItemSetOnEvent(-1, "_ShowGui")

_ShowGui()

Func _ShowGui()
	$HotKeyGui = GuiCreate("Hotkey selection...", 400, 200)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_CloseGui")

	GuiCtrlCreateLabel("Modifiers", 140, 50, 200, 40)
	GuiCtrlSetFont(-1, 18)

	$HotKeyList = GuiCtrlCreateCombo("", 10, 10, 380, 30)
	GuiCtrlSetFont(-1, 11)

	For $i = 1 To $Keys[0]
		GuiCtrlSetData($HotKeyList, $Keys[$i])
	Next

	For $i = 1 To $Alphabet[0]
		GuiCtrlSetData($HotKeyList, $Alphabet[$i])
	Next

	$AltModifier = GuiCtrlCreateCheckBox("Alt", 20, 60, 80, 80)
	GUICtrlSetOnEvent(-1, "_AltModifierSelected")
	GuiCtrlSetFont(-1, 15)

	$CtrlModifier = GuiCtrlCreateCheckBox("Ctrl", 335, 60, 80, 80)
	GUICtrlSetOnEvent(-1, "_CtrlModifierSelected")
	GuiCtrlSetFont(-1, 15)

	$SubmitButton = GuiCtrlCreateButton("Submit", 100, 140, 200, 50)
	GUICtrlSetOnEvent(-1, "_Submit")
	GuiCtrlSetFont(-1, 15)


	GuiSetState()
EndFunc

Func _AltModifierSelected()
	If $Modifier = "!" Then
		GuiCtrlSetState($CtrlModifier, $GUI_UNCHECKED)
		GuiCtrlSetState($AltModifier, $GUI_UNCHECKED)
		$Modifier = ""
	Else
		$Modifier = "!"
		GuiCtrlSetState($CtrlModifier, $GUI_UNCHECKED)
	EndIf
EndFunc

Func _CtrlModifierSelected()
	If $Modifier = "^" Then
		GuiCtrlSetState($CtrlModifier, $GUI_UNCHECKED)
		GuiCtrlSetState($AltModifier, $GUI_UNCHECKED)
		$Modifier = ""
	Else
		$Modifier = "^"
		GuiCtrlSetState($AltModifier, $GUI_UNCHECKED)
	EndIf
EndFunc


Func _Submit()
	HotKeySet($CurrentHotKey)
	$HotKeySelected = GuiCtrlRead($HotKeyList)
	$CurrentHotKey = $Modifier & $HotKeySelected
	HotKeySet($CurrentHotKey, "_Test")
	IniWrite(@ScriptDir & "/Data/Settings.ini", "Settings", "Hotkey", $CurrentHotKey)
EndFunc

Func _Test()
	$Window = WinGetTitle("[ACTIVE]")
	$CheckCancel = MsgBox(4, "Kill...", "Do you wish to kill the following process?" & @CRLF & @CRLF & $Window)
	If $CheckCancel = 6 Then
		$Process = WinGetProcess($Window)
		ProcessClose($Process)
	Else
		Sleep(200)
	EndIf
EndFunc

Func _CloseGui()
	GuiDelete($HotKeyGui)
EndFunc

Func _Exit()
	Exit
EndFunc


While 1
	Sleep(10)
WEnd