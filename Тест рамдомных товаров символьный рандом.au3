;~ Далее всё с правами администратора, ориентацыя по окну, лог.
#RequireAdmin
#include <File.au3>
AutoItSetOption('mousecoordmode',0)

;~ Процедура авторизации усовершенствованная.

Local $Way = '\Лог выполнения теста\Тест рандомного товара банк.log'

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

;~ Процедура подключения к КА с  отработкой ошибок и исключений

WinWaitActive('ПО ТОТУС-ФРОНТ','',5)
ControlSend("ПО ТОТУС-ФРОНТ", "", "[CLASS:WindowsForms10.MDICLIENT.app.0.378734a; INSTANCE:1]", "^{c}")
Sleep(2000)
ControlSend("ПО ТОТУС-ФРОНТ", "", "[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:2]", "{f6}")

WinWaitActive('ЦО Тест', '', 5)
WinActivate('ЦО Тест')
Local $SOTEST = 0
if WinActive ('ЦО Тест') Then
$SOTEST = 1 & _FileWriteLog(@ScriptDir & $Way,"Подключение к КА без ошибок")
EndIf

If $SOTEST == 0 Then
Sleep(500)
MouseClick('primary',37,50,1,1)
Sleep(300)
MouseClick('primary',93,225,1,1)
Sleep(1000)
send('{f6}')
WinWaitActive('ЦО Тест', '', 20)
if WinActive ('ЦО Тест') Then
$SOTEST = 1 & _FileWriteLog(@ScriptDir & $Way,"Подключение к КА при помощи мыши")
EndIf
EndIf

If $SOTEST == 0 or WinActive('Ошибка') Then
send('{enter}')
Sleep(500)
send('{enter}')
Sleep(500)
MouseClick('primary',37,50,1,1)
Sleep(500)
send('{down 7}')
Sleep(300)
send('{right}')
Sleep(300)
send('{down}')
Sleep(300)
send('{enter}')
WinWaitActive('Кассовые аппараты')
WinActivate('Кассовые аппараты')
Sleep(500)
MouseClick('primary',165,91,1,1)
Sleep(500)
send('Виртуальный ФР')
Sleep(300)
send('{down}')
Sleep(300)
send('{enter}')
WinWaitActive('ПО ТОТУС-ФРОНТ')
MouseClick('primary',37,50,1,1)
Sleep(300)
MouseClick('primary',93,225,1,1)
Sleep(1000)
send('{f6}')
WinWaitActive('ЦО Тест', '', 20)
if WinActive ('ЦО Тест') Then
$SOTEST = 1 & _FileWriteLog(@ScriptDir & $Way,"Перевыбран и подключен виртуальный КА")
EndIf
EndIf

If $SOTEST = 0 or WinActive('Ошибка') Then
WinClose('')
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way,"Критическая ошибка не удалось открыть форму чек")
Exit
EndIf

;~ добавление рандомного  товара

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
;~ поиск буквы с исключениями
Local $Letter
$Letter = Chr(Random(Asc("а"), Asc("я"), 1))
Local $noLetter1 = "ь"
Local $noLetter2 = "ъ"
Local $noLetter3 = "ы"
if $Letter == $noLetter1 Then $Letter = "a"
if $Letter == $noLetter2 Then $Letter = "b"
if $Letter == $noLetter3 Then $Letter = "c"
Send($Letter)
send('{enter}')
Sleep(3000)
;~ лог
_FileWriteLog(@ScriptDir & $Way, $Letter & ' - на эту букву искали препарат')

;~ рандомное число вниз
Example()
Func Example()
Local $randomVar
$randomVar = Random(1,40,1)

Select
	Case $randomVar == 1
Send('{down 1}')
	Case $randomVar == 2
Send('{down 2}')
	Case $randomVar == 3
Send('{down 3}')
	Case $randomVar == 4
Send('{down 4}')
	Case $randomVar == 5
Send('{down 5}')
	Case $randomVar == 6
Send('{down 6}')
	Case $randomVar == 7
Send('{down 7}')
	Case $randomVar == 8
Send('{down 8}')
	Case $randomVar == 9
Send('{down 9}')
	Case $randomVar == 10
Send('{down 10}')
	Case $randomVar == 11
Send('{down 11}')
	Case $randomVar == 12
Send('{down 12}')
	Case $randomVar == 13
Send('{down 13}')
	Case $randomVar == 14
Send('{down 14}')
	Case $randomVar == 15
Send('{down 15}')
	Case $randomVar == 16
Send('{down 16}')
	Case $randomVar == 17
Send('{down 17}')
	Case $randomVar == 18
Send('{down 18}')
	Case $randomVar == 19
Send('{down 19}')
	Case $randomVar == 20
Send('{down 20}')
	Case $randomVar == 21
Send('{down 21}')
	Case $randomVar == 22
Send('{down 22}')
	Case $randomVar == 23
Send('{down 23}')
	Case $randomVar == 24
Send('{down 24}')
	Case $randomVar == 25
Send('{down 25}')
	Case $randomVar == 26
Send('{down 26}')
	Case $randomVar == 27
Send('{down 27}')
	Case $randomVar == 28
Send('{down 28}')
	Case $randomVar == 29
Send('{down 29}')
	Case $randomVar == 30
Send('{down 30}')
	Case $randomVar == 31
Send('{down 31}')
	Case $randomVar == 32
Send('{down 32}')
	Case $randomVar == 33
Send('{down 33}')
	Case $randomVar == 34
Send('{down 34}')
	Case $randomVar == 35
Send('{down 35}')
	Case $randomVar == 36
Send('{down 36}')
	Case $randomVar == 37
Send('{down 37}')
	Case $randomVar == 38
Send('{down 38}')
	Case $randomVar == 39
Send('{down 39}')
Case $randomVar == 40
Send('{down 40}')

EndSelect
;~ лог
_FileWriteLog(@ScriptDir & $Way, $randomVar & ' - товар из списка добавлен в чек')
EndFunc
Sleep(2000)
send('{enter}')
;~ добавление в чек

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

send('{enter}')
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf

;~ отработка кнопки промо

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)

_FileWriteLog(@ScriptDir & $Way, 'Отработана кнопка промо')

;~ Пробитие чека. Банк.

WinActivate('ЦО Тест')
Send('{esc}')
WinWaitActive('Оплата по чеку', '', 10)
if WinActive ('Оплата по чеку') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Открыть форму оплаты чека. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Оплата по чеку')

send('{F3}')
Sleep(1000)
Send('{enter}')
Sleep(1000)

WinActivate('ЦО Тест')
if WinActive ('Оплата по чеку') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось пробить чек. Тест завершился ошибкой')
Exit
EndIf

_FileWriteLog(@ScriptDir & $Way, 'Чек пробит по банковской карте')

;~ Закрытие окна чека

Sleep(500)
Send('{f10}')
WinWaitActive('Чек', '', 10)
if WinActive ('Чек') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, Закрыть форму чек. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Чек')
Send('{enter}')
Sleep(500)
if WinActive ('ЦО Тест') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, Закрыть форму чек. Тест завершился ошибкой')
Exit
EndIf

_FileWriteLog(@ScriptDir & $Way, 'Закрыта форма чек')

;~ Открытие чека возврата, последнего пробитого.

WinWaitActive('ПО ТОТУС-ФРОНТ')
WinActivate('ПО ТОТУС-ФРОНТ')

MouseClick('primary',37,50,1,1)
Sleep(300)
MouseClick('primary',77,274,1,1)
Sleep(500)

WinWaitActive('Выбор чека по фискальному номеру', '', 10)
if WinActive ('Выбор чека по фискальному номеру') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, Не удалось открыть форму выбора чека возврата. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Выбор чека по фискальному номеру')

MouseClick('primary',239,87,1,1)
Sleep(300)
Send('{enter}')
Sleep(300)
MouseClick('primary',310,80,1,1)
Sleep(500)
Send('{enter}')

if WinActive ('Выбор чека по фискальному номеру') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, Не удалось открыть форму чека возврата. Тест завершился ошибкой')
Exit
EndIf

_FileWriteLog(@ScriptDir & $Way, 'Возврат. Открыт последний пробитый чек')

;~ Пробитие чека возврата.

WinWaitActive('ЦО Тест', '', 10)
if WinActive ('ЦО Тест') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, Не удалось открыть форму чека возврата. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('ЦО Тест')

Sleep(800)
Send('{esc}')

WinWaitActive('Данные покупателя', '', 10)
if WinActive ('Данные покупателя') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не открывается форма данных о покупателе. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Данные покупателя')

Sleep(300)
Send('Иванов')
send('{tab}')
Send('Иван')
send('{tab}')
Send('Иванович')
send('{tab}')
Send('Ивановская область город Иваново улица Ивановская')
Send('{enter}')
WinWaitActive('Оплата по чеку')
Send('{enter}')
Sleep(500)

WinActivate('ПО ТОТУС-ФРОНТ')
if WinActive ('ЦО Тест') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, Не удалось открыть форму чека возврата. Тест завершился ошибкой')
Exit
EndIf

_FileWriteLog(@ScriptDir & $Way, 'Возврат. Пробит последний пробитый чек')

;~ Закрытие программы.

WinClose('ПО ТОТУС-ФРОНТ')

Exit