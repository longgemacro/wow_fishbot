;+--------------------------------+----------------------------------+
;| Luvmachine's Fishbot GUI & All | Original design by Pantless Krab |
;+-------------------------+------+-------+--------------------------+
;                          |Version 1.11.2|
;    +---------------------+--------------+----------------------+
; +--+By using this in conjunction with ħ������ you are+--+
; |violating your EULA and TOS.  Using this bot can result in a temp|
; |or even a permanent ban.  The creator takes no responsibility for|
; +-----+what may happen to anyone who uses this original code.+----+
;     +-+------------------------------------------------------+--+
;     | Written for my friends at http://rpg-exploiters.shoq.net/ |
;     +-----------------------------------------------------------+

#include <GUIConstants.au3>
#include <ScreenCapture.au3>
#Include <WinAPI.au3>
#include <Date.au3>
#include "soundDetect.au3"

Opt("WinTitleMatchMode", 3)

Global $tolerance = IniRead("hex.ini", "Variables", "Tolerance", 20)
Global $sear_step = IniRead("hex.ini", "Variables", "Step", 2)
Global $ProgressBar = 0
Global $idLogEdit = 0

; ������Ŀ
Global $CONFIG_WAIT_TIME_CHECK_FLOAT = 30000
Global $CONFIG_MAX_SOUND_LEVEL = 15
Global $CONFIG_MOUSE_STEP_FIND_FLOAT = 20
Global $CONFIG_HOT_KEY = "1"

; ȫ�ֲ���
Global $g_v_float_x, $g_v_float_y
Global $isRunning = 0

HotKeySet("{F11}", "End")

GUI_Gene()

Func GUI_Gene()
   GUICreate(Random(0,9999), 300, 200, @DesktopWidth - 400, 300)

   Local $menu_menu = GUICtrlCreateMenu("Menu")
   Local $menu_abou = GUICtrlCreateMenuItem("About",$menu_menu)
   Local $menu_line = GUICtrlCreateMenuItem("",$menu_menu)
   Local $menu_exit = GUICtrlCreateMenuItem("Exit",$menu_menu)

   Local $start = GUICtrlCreateButton("��ʼ",220,10,70,40)
   ; ����������
   GUICtrlCreateLabel("����ǿ��", 10, 10)
   $ProgressBar = GUICtrlCreateProgress(10, 30, 200, 20)
   ; ��־��
   $idLogEdit = GUICtrlCreateEdit("������־" & @CRLF, 10, 60, 280, 100, $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_READONLY)

   GUISetState()

   GUICtrlSetData($idLogEdit, "�����ݼ���1������ѡ���У�ȥ����Ч��", 1)

   While 1
      Local  $mess = GUIGetMsg()

      If $mess = $start Then Start_Bot()
      If $mess = $GUI_EVENT_CLOSE or $mess = $menu_exit Then Exit
      If $mess = $menu_abou Then MsgBox(0,"About","Written by spyman1802@hotmail.com" & @CRLF & "Original design Pantless Krab")
   WEnd
EndFunc

Func Start_Bot()
   PrintLog("Hello...");
   ;GUIDelete()

   If Not WinExists("ħ������") Then
      MsgBox(0, Random(0, 9999), "û�з���ħ�����磡")
      Exit
   EndIf

   WinActivate("ħ������")
   WinSetOnTop("ħ������", "", 0)
   Sleep(500)
   Set_Size()

   WinSetOnTop("ħ������", "", 1)

   ; ��������ⷶΧ
   MouseMove($wind_left, $wind_top, 5)
   MouseMove($wind_righ, $wind_top, 5)
   MouseMove($wind_righ, $wind_bott, 5)
   MouseMove($wind_left, $wind_bott, 5)

   ; ��ѭ��
   $isRunning = 1
   Local $found = false;
   While 1
      ; ˦��
      Cast_Pole()

	  if $isRunning = 0 then ExitLoop

      ; �ӳ�һ���
      Sleep(2000)

      ; ������Ư
      $found = Find_Float()

	  if $isRunning = 0 then ExitLoop

      ; ����ҵ����͵ȴ��Ϲ����������ѭ��
      If $found = 0 Then ContinueLoop

      ; �ȴ��Ϲ�
      CheckFloat()

	  if $isRunning = 0 then ExitLoop

      ; �ӳ�һ���
      Sleep(2000)

   wend

EndFunc

Func Set_Size()
   PrintLog("[Set_Size] ==> run")
   Local $bord_vert = 23
   Local $bord_hori = 4
   Local $wind_size = WinGetClientSize("ħ������")
   ;PrintList($wind_size)
   Local $wind_posi = WinGetPos("ħ������")
   ;PrintList($wind_posi)
   Local $wind_x = $wind_posi[0] + $bord_hori
   Local $wind_y = $wind_posi[1] + $bord_vert
   global $wind_top = $wind_y + (.25 * $wind_size[1])
   global $wind_bott = $wind_top + (.35 * $wind_size[1]) - 1
   global $wind_left = $wind_x + (.15 * $wind_size[0])
   global $wind_righ = $wind_left + $wind_size[0] - (.3 * $wind_size[0]) - 1
   PrintLog("[Set_Size] ==> " & $wind_top & "," & $wind_bott & "," & $wind_left & "," & $wind_righ)
EndFunc

Func Cast_Pole()
   PrintLog("[Cast_Pole] ==> Start")
   WinActivate("ħ������")
   Send($CONFIG_HOT_KEY)
EndFunc

; ������Ư
; ��һ��û���ҵ���������һ��
Func Find_Float()
   PrintLog("[Find_Float] ==> Start")

   $g_v_float_x = 0
   $g_v_float_y = 0
   local $hCursor, $hOldCursor = 0
   Local $scanCount = 0

   While $scanCount <= 1
      $hCursor = 0
      $hOldCursor = 0

      ; ѭ���ƶ���ֱ꣬���������ָ���ֵ�����仯
      For $Y = $wind_top to $wind_bott step $CONFIG_MOUSE_STEP_FIND_FLOAT
         For $X = $wind_left to $wind_righ step $CONFIG_MOUSE_STEP_FIND_FLOAT
            MouseMove($X, $Y, 1)
            $hCursor = _WinAPI_GetCursorInfo()

            ; ���Ե�һ���ƶ�
            if $hOldCursor = 0 Then
               ;PrintLog("First ... ")
               $hOldCursor = $hCursor[2]
               ContinueLoop
            EndIf

            ; ����һ����Ƚϣ������˱仯
            If $hOldCursor <> $hCursor[2] Then
               PrintLog("DONE!!" & $X & ":" & $Y)
               $g_v_float_x = $X
               $g_v_float_y = $Y
               Return 1
            EndIf

            $hOldCursor = $hCursor[2]
         Next
      Next

      Sleep(10)
      $scanCount = $scanCount + 1
   WEnd

EndFunc

Func CheckFloat()
   Local $star_time = TimerInit()
   While TimerDiff($star_time) < $CONFIG_WAIT_TIME_CHECK_FLOAT
      Local $peakLevel = getApplicationPeakLevel()
      GUICtrlSetData($ProgressBar, $peakLevel)
      if $peakLevel > $CONFIG_MAX_SOUND_LEVEL Then
         PrintLog("FOUND !!!!!")
         Sleep(500)
         MouseClick("right", $g_v_float_x, $g_v_float_y, 1, 2)
         ExitLoop
      EndIf
      Sleep(10)
   WEnd
EndFunc

Func End()
   WinSetOnTop("ħ������", "", 0)
   $isRunning = 0
   ;Exit
EndFunc

Func MyErrFunc($iLineNumer, $iError)
    $iLineNumer = $iLineNumer - 1
    ConsoleWriteError("ERROR GENERATED ON SCRIPT LINE: " & $iLineNumer & @CRLF & "ERROR CODE: " & $iError)
 EndFunc


Func PrintList($List)
    If IsArray($List) Then
        Local $txt = ""
        For $i = 0 to UBound($List) -1
            $txt = $txt & "," & $List[$i]
        Next
        Local $out = StringMid($txt,2)
        Global $Result = "[" & $out & "]" & @CRLF
        ConsoleWrite($Result)
        Return $Result
    Else
        MsgBox(0, "List Error", "Variable is not an array or a list")
    EndIf
EndFunc

Func PrintLog($msg)
   Local $m = _Now() & " " & $msg & @CRLF
   ConsoleWrite($m)
   GUICtrlSetData($idLogEdit, $m, 1)
EndFunc

Func getApplicationPeakLevel()
   $aApp = _GetAppsPlayingSound()
   If (UBound($aApp)>1) then
      For $i= 0 to UBound($aApp)-1
         If ($aApp[$i][0] == "Wow.exe") then
            return Int($aApp[$i][1]*100)
         EndIf
      Next
   EndIf
   return 0
EndFunc