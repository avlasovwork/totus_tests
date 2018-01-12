;~ Далее всё с правами администратора, ориентацыя по окну, лог.

#RequireAdmin
#include <File.au3>
AutoItSetOption('mousecoordmode',0)

;~ Процедура авторизации усовершенствованная.

Local $Way = '\Лог выполнения теста\изятие и закрытие.log'

Run('C:\TOTUS_FRONT\bin\Totus_Front.exe')
_FileWriteLog(@ScriptDir & $Way, 'Старт программы')

Local $Login = 'vlasovan'
Local $Pass = '72896'
WinWaitActive('Вход в системы')
WinActivate('Вход в системы')
ControlSend('Вход в системы', '', '[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:4]', '{DEL 20}')
ControlSend("Вход в системы", '', '[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:4]', $Login)
ControlSend("Вход в системы", '', '[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:3]', $Pass)
ControlClick("Вход в системы", '','[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:1]')
Send('{up 10}')
Send('{down 4}')
send('{enter}')
_FileWriteLog(@ScriptDir & $Way, 'Вход в программу под логином '  & $Login & ' и паролем ' & $Pass)

;~ Процедура подключения к КА и открытия формы внесение/изъятие

WinWaitActive('ПО ТОТУС-ФРОНТ','',5)
Sleep(2000)
ControlSend("ПО ТОТУС-ФРОНТ", "", "[CLASS:WindowsForms10.MDICLIENT.app.0.378734a; INSTANCE:1]", "^{c}")
Sleep(2000)
ControlSend("ПО ТОТУС-ФРОНТ", "", "[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:2]", "{f7}")

WinWaitActive('Служебное внесение/изъятие денег', '', 5)
WinActivate('Служебное внесение/изъятие денег')

Local $in_out = 0
if WinActive ('Служебное внесение/изъятие денег') Then
$in_out = 1 & _FileWriteLog(@ScriptDir & $Way,"Подключение к КА без ошибок")
EndIf

If $in_out == 0 Then
Sleep(500)
MouseClick('primary',37,50,1,1)
Sleep(300)
MouseClick('primary',93,225,1,1)
Sleep(1000)
send('{f7}')
WinWaitActive('Служебное внесение/изъятие денег', '', 20)
if WinActive ('Служебное внесение/изъятие денег') Then
$in_out = 1 & _FileWriteLog(@ScriptDir & $Way,"Подключение к КА при помощи мыши")
EndIf
EndIf

If $in_out = 0 or WinActive('Ошибка') Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way,"Критическая ошибка не удалось открыть форму")
Exit
EndIf

;~ изятие остатка
Sleep(3000)
Local $money
$money = ControlGetText('Служебное внесение/изъятие денег','','[CLASS:WindowsForms10.STATIC.app.0.378734a; INSTANCE:2]')
ControlSend("Служебное внесение/изъятие денег", '', '[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:1]', $money)
ControlClick("Служебное внесение/изъятие денег", '', '[CLASS:WindowsForms10.COMBOBOX.app.0.378734a; INSTANCE:1]')
ControlSend("Служебное внесение/изъятие денег", '', '[CLASS:WindowsForms10.COMBOBOX.app.0.378734a; INSTANCE:1]', '{down 2}')
ControlClick("Служебное внесение/изъятие денег", '', '[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:4]')

WinWaitActive('подтверждение', '', 3)
if WinActive ('подтверждение') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не открылось окно подтверждения. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('подтверждение')

Send('{enter}')

if WinActive ('Служебное внесение/изъятие денег') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось изять деньги. Тест завершился ошибкой')
Exit
EndIf
if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, Во время изятия произошла ошибка. Тест завершился ошибкой')
Exit
EndIf


;~ Х отчёт
Send('{f8}')

WinWaitActive('Печать отчетов', '', 10)
if WinActive ('Печать отчетов') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось открыть печать отчётов. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Печать отчетов')

ControlClick("Печать отчетов", '', '[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:5]')
ControlClick("Печать отчетов", '', '[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:7]')

WinActivate('ПО ТОТУС-ФРОНТ')
if WinActive ('Печать отчетов') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось напечатать Х тчёт. Тест завершился ошибкой')
Exit
EndIf
if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, Во время пробития произошла ошибка. Тест завершился ошибкой')
Exit
EndIf

;~ Z отчёт
Send('{f8}')

WinWaitActive('Печать отчетов', '', 10)
if WinActive ('Печать отчетов') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось открыть печать отчётов. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Печать отчетов')

ControlClick("Печать отчетов", '', '[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:4]')
ControlClick("Печать отчетов", '', '[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:7]')


WinWaitActive('Печать Z-отчета', '', 10)
if WinActive ('Печать Z-отчета') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось напечатать z отчёт. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Печать Z-отчета')

Send('{enter}')
Sleep (1000)

WinActivate('ПО ТОТУС-ФРОНТ')
if WinActive ('Печать отчетов') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось напечатать Х тчёт. Тест завершился ошибкой')
Exit
EndIf
if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, Во время пробития произошла ошибка. Тест завершился ошибкой')
Exit
EndIf
;~ Закрытие программы.

WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Тест завершен успешно.')

Exit

