;~ Далее всё с правами администратора, ориентацыя по окну, лог.
#RequireAdmin
#include <File.au3>
AutoItSetOption('mousecoordmode',0)

;~ Процедура авторизации усовершенствованная.
Local $Way = '\Лог выполнения теста\Тесты промо программ.log'

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

;~ Тест 1 Сумма чека/Чек/Скидка сумма на чек
_FileWriteLog(@ScriptDir & $Way, 'Тест 1 Сумма чека/Чек/Скидка сумма на чек')
Sleep(2000)

;~ Процедура добавления дисконтной карты

Send('{F3}')
Sleep(300)
Send('T159874')
Send('{enter}')
Sleep(3000)

if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось добавить диконтную карту. Тест завершился ошибкой')
Exit
EndIf
if WinActive('','Карточка не найдена') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти диконтную карту. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлена тестовая дисконтная карта T159874')

;~ добавление товара 1

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Ливазо п/о 4мг №30')
Sleep(300)
send('{enter}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

Send(10)
Send('{tab}')
Send(0)
send('{enter}')
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из базового набора')

;~ добавление товара 2

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Тилда № 200 таб')
Sleep(300)
send('{enter}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

Send(10)
Send('{tab}')
Send(0)
send('{enter}')
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из базового набора')

;~ отработка кнопки промо

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)
_FileWriteLog(@ScriptDir & $Way, 'Отработана кнопка промо')

;~ Проверка отработки программы

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')

Local $NAME_PROG = "Тестовая программа IT  СЧ_Ч_ССНЧ"
Local $TEST_PROG = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:7]')
if $TEST_PROG == $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа ' & $TEST_PROG & ' отработала')

ControlClick("ЦО Тест", '','[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]')
ControlSend('ЦО Тест', '', '[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]', '{down}')

Local $TEST_PROG_RES = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:2]')
if $TEST_PROG_RES <> 0 Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа отработала, скидка равна: ' & $TEST_PROG_RES)
EndIf

if $TEST_PROG_RES == 0 or $TEST_PROG_RES == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не дала скидку, скидка = ' & $TEST_PROG_RES)
EndIf

EndIf

if $TEST_PROG == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не отработала')
EndIf

if $TEST_PROG <> $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: отработала другая программа: ' & $TEST_PROG)
EndIf

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

;~ Тест 2 Сумма чека/Чек/Скидка % на чек
_FileWriteLog(@ScriptDir & $Way, 'Тест 2 Сумма чека/Чек/Скидка % на чек')
Sleep(3000)

;~ Процедура добавления дисконтной карты

Send('{F3}')
Sleep(300)
Send('T159874')
Send('{enter}')
Sleep(3000)

if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось добавить диконтную карту. Тест завершился ошибкой')
Exit
EndIf
if WinActive('','Карточка не найдена') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти диконтную карту. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлена тестовая дисконтная карта T159874')

;~ добавление товара 1

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('ВАГЕТТА')
Sleep(300)
send('{enter}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

Send(4)
Send('{tab}')
Send(0)
send('{enter}')
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из базового набора')

;~ отработка кнопки промо

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)
_FileWriteLog(@ScriptDir & $Way, 'Отработана кнопка промо')

;~ Проверка отработки программы

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')

Local $NAME_PROG = "Тестовая программа IT  СЧ_Ч_СНЧ"
Local $TEST_PROG = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:7]')
if $TEST_PROG == $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа ' & $TEST_PROG & ' отработала')

ControlClick("ЦО Тест", '','[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]')
ControlSend('ЦО Тест', '', '[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]', '{down}')

Local $TEST_PROG_RES = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:2]')
if $TEST_PROG_RES <> 0 Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа отработала, скидка равна: ' & $TEST_PROG_RES)
EndIf

if $TEST_PROG_RES == 0 or $TEST_PROG_RES == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не дала скидку, скидка = ' & $TEST_PROG_RES)
EndIf

EndIf

if $TEST_PROG == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не отработала')
EndIf

if $TEST_PROG <> $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: отработала другая программа: ' & $TEST_PROG)
EndIf

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

;~ Тест 3 Сумма чека/Чек/Начисление бонусы % на чек
_FileWriteLog(@ScriptDir & $Way, 'Тест 3 Сумма чека/Чек/Начисление бонусы % на чек')
Sleep(3000)

;~ Процедура добавления дисконтной карты

Send('{F3}')
Sleep(300)
Send('T159874')
Send('{enter}')
Sleep(3000)

if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось добавить диконтную карту. Тест завершился ошибкой')
Exit
EndIf
if WinActive('','Карточка не найдена') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти диконтную карту. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлена тестовая дисконтная карта T159874')

;~ добавление товара

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Карбоплатин Медак конц_д/п інф_р-ну 15мг')
Sleep(300)
send('{enter}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

Send(3)
Send('{tab}')
Send(0)
send('{enter}')
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из базового набора')

;~ отработка кнопки промо

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)
_FileWriteLog(@ScriptDir & $Way, 'Отработана кнопка промо')

;~ Проверка отработки программы

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')

Local $NAME_PROG = "Тестовая программа IT  СЧ_Ч_НБНЧ"

Local $TEST_PROG = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:7]')
if $TEST_PROG == $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа ' & $TEST_PROG & ' отработала')

ControlClick("ЦО Тест", '','[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]')
ControlSend('ЦО Тест', '', '[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]', '{down}')

Local $TEST_PROG_RES = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:5]')
if $TEST_PROG_RES <> 0 Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа отработала, насчитано бонусов: ' & $TEST_PROG_RES)
EndIf

if $TEST_PROG_RES == 0 or $TEST_PROG_RES == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не начислила бонусы, бонусы = ' & $TEST_PROG_RES)
EndIf

EndIf

if $TEST_PROG == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не отработала')
EndIf

if $TEST_PROG <> $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: отработала другая программа: ' & $TEST_PROG)
EndIf

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

;~ Тест 4 Полный набор/Базовый/Цена
_FileWriteLog(@ScriptDir & $Way, 'Тест 4 Полный набор/Базовый/Цена')
Sleep(3000)

;~ добавление товара 1

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Тор-Луп 10мг №30 тб')
Sleep(300)
send('{enter}')
Send('{down 6}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

send('{enter}')
Sleep(1000)
WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
	EndIf

_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из базового набора')

;~ Процедура добавления дисконтной карты

Send('{F3}')
Sleep(300)
Send('T159874')
Send('{enter}')
Sleep(3000)

if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось добавить диконтную карту. Тест завершился ошибкой')
Exit
EndIf
if WinActive('','Карточка не найдена') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти диконтную карту. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлена тестовая дисконтная карта T159874')

;~ добавление товара 2

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Парацетамол 200мг №10')
Sleep(300)
send('{enter}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

Send(2)
Send('{tab}')
Send(0)
send('{enter}')
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из базового набора')

;~ добавление товара 2

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Аналергін 10мг №30 таб')
Sleep(300)
send('{enter}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

Send(2)
Send('{tab}')
Send(0)
send('{enter}')
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из базового набора')

;~ отработка кнопки промо

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)
_FileWriteLog(@ScriptDir & $Way, 'Отработана кнопка промо')

;~ Проверка отработки программы

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')

Local $NAME_PROG = "Тестовая программа IT ПН_1_Ц"

Local $TEST_PROG = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:7]')
if $TEST_PROG == $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа ' & $TEST_PROG & ' отработала')

ControlClick("ЦО Тест", '','[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]')
ControlSend('ЦО Тест', '', '[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]', '{down}')

Local $TEST_PROG_RES = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:2]')
if $TEST_PROG_RES <> 0 Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа отработала, скидка равна: ' & $TEST_PROG_RES)
EndIf

if $TEST_PROG_RES == 0 or $TEST_PROG_RES == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не дала скидку, скидка = ' & $TEST_PROG_RES)
EndIf

EndIf

if $TEST_PROG == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не отработала')
EndIf

if $TEST_PROG <> $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: отработала другая программа: ' & $TEST_PROG)
EndIf

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

;~ Тест 5 Количество товара из набора/Вторичный/Цена
_FileWriteLog(@ScriptDir & $Way, 'Тест 5 Количество товара из набора/Вторичный/Цена')
Sleep(3000)

;~ добавление товара 1

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Готові окуляри Alise')
Sleep(300)
send('{enter}')
Send('{down 6}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

send('{enter}')
Sleep(1000)
WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
	EndIf

_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из вторичного набора')

;~ Процедура добавления дисконтной карты

Send('{F3}')
Sleep(300)
Send('T159874')
Send('{enter}')
Sleep(3000)

if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось добавить диконтную карту. Тест завершился ошибкой')
Exit
EndIf
if WinActive('','Карточка не найдена') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти диконтную карту. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлена тестовая дисконтная карта T159874')

;~ добавление товара 2

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Бинт еластичний сетч р1')
Sleep(300)
send('{enter}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

Send(2)
Send('{tab}')
Send(0)
send('{enter}')
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из базового набора')

;~ отработка кнопки промо

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)
_FileWriteLog(@ScriptDir & $Way, 'Отработана кнопка промо')

;~ Проверка отработки программы

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')

Local $NAME_PROG = "Тестовая программа IT  КТН_2_Ц"
Local $TEST_PROG = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:7]')
if $TEST_PROG == $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа ' & $TEST_PROG & ' отработала')

ControlClick("ЦО Тест", '','[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]')
ControlSend('ЦО Тест', '', '[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]', '{down}')

Local $TEST_PROG_RES = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:2]')
if $TEST_PROG_RES <> 0 Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа отработала, скидка равна: ' & $TEST_PROG_RES)
EndIf

if $TEST_PROG_RES == 0 or $TEST_PROG_RES == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не дала скидку, скидка = ' & $TEST_PROG_RES)
EndIf

EndIf

if $TEST_PROG == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не отработала')
EndIf

if $TEST_PROG <> $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: отработала другая программа: ' & $TEST_PROG)
EndIf


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

;~ Тест 6 Количество товара из набора/Вторичный/Скидка
_FileWriteLog(@ScriptDir & $Way, 'Тест 6 Количество товара из набора/Вторичный/Скидка')
Sleep(3000)

;~ добавление товара 1

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Аладин 10мг №50 тб')
Sleep(300)
send('{enter}')
Send('{down 6}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

send('{enter}')
Sleep(1000)
WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
	EndIf

_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из вторичного набора')

;~ Процедура добавления дисконтной карты

Send('{F3}')
Sleep(300)
Send('T159874')
Send('{enter}')
Sleep(3000)

if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось добавить диконтную карту. Тест завершился ошибкой')
Exit
EndIf
if WinActive('','Карточка не найдена') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти диконтную карту. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлена тестовая дисконтная карта T159874')

;~ добавление товара 2

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Парацетамол 200мг №10')
Sleep(300)
send('{enter}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

Send(2)
Send('{tab}')
Send(0)
send('{enter}')
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из базового набора')

;~ отработка кнопки промо

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)
_FileWriteLog(@ScriptDir & $Way, 'Отработана кнопка промо')

;~ Проверка отработки программы

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')

Local $NAME_PROG = "Тестовая программа IT  КТН_2_СК"
Local $TEST_PROG = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:7]')
if $TEST_PROG == $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа ' & $TEST_PROG & ' отработала')

ControlClick("ЦО Тест", '','[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]')
ControlSend('ЦО Тест', '', '[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]', '{down}')

Local $TEST_PROG_RES = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:2]')
if $TEST_PROG_RES <> 0 Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа отработала, скидка равна: ' & $TEST_PROG_RES)
EndIf

if $TEST_PROG_RES == 0 or $TEST_PROG_RES == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не дала скидку, скидка = ' & $TEST_PROG_RES)
EndIf

EndIf

if $TEST_PROG == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не отработала')
EndIf

if $TEST_PROG <> $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: отработала другая программа: ' & $TEST_PROG)
EndIf


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

;~ Тест 7 Количество товара из набора/Базовый/Цена
_FileWriteLog(@ScriptDir & $Way, 'Тест 7 Количество товара из набора/Базовый/Цена')
Sleep(3000)

;~ Процедура добавления дисконтной карты

Send('{F3}')
Sleep(300)
Send('T159874')
Send('{enter}')
Sleep(3000)

if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось добавить диконтную карту. Тест завершился ошибкой')
Exit
EndIf
if WinActive('','Карточка не найдена') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти диконтную карту. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлена тестовая дисконтная карта T159874')

;~ добавление товара 2

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Тизанідин-ратіофарм 2 мг №30')
Sleep(300)
send('{enter}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

Send(1)
Send('{tab}')
Send(0)
send('{enter}')
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из базового набора')

;~ отработка кнопки промо

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)
_FileWriteLog(@ScriptDir & $Way, 'Отработана кнопка промо')

;~ Проверка отработки программы

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')

Local $NAME_PROG = "Тестовая программа IT  КТН_1_Ц"
Local $TEST_PROG = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:7]')
if $TEST_PROG == $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа ' & $TEST_PROG & ' отработала')

ControlClick("ЦО Тест", '','[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]')
ControlSend('ЦО Тест', '', '[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]', '{down}')

Local $TEST_PROG_RES = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:2]')
if $TEST_PROG_RES <> 0 Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа отработала, скидка равна: ' & $TEST_PROG_RES)
EndIf

if $TEST_PROG_RES == 0 or $TEST_PROG_RES == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не дала скидку, скидка = ' & $TEST_PROG_RES)
EndIf

EndIf

if $TEST_PROG == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не отработала')
EndIf

if $TEST_PROG <> $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: отработала другая программа: ' & $TEST_PROG)
EndIf

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

;~ Тест 8 Количество товара из набора/Базовый/Скидка сумма на базовый набор
_FileWriteLog(@ScriptDir & $Way, 'Тест 8 Количество товара из набора/Базовый/Скидка сумма на базовый набор')
Sleep(3000)

;~ Процедура добавления дисконтной карты

Send('{F3}')
Sleep(300)
Send('T159874')
Send('{enter}')
Sleep(3000)

if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось добавить диконтную карту. Тест завершился ошибкой')
Exit
EndIf
if WinActive('','Карточка не найдена') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти диконтную карту. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлена тестовая дисконтная карта T159874')

;~ добавление товара 2

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Торасемид Сандоз 10мг №100 тб')
Sleep(300)
send('{enter}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

Send(1)
Send('{tab}')
Send(0)
send('{enter}')
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из базового набора')

;~ отработка кнопки промо

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)
_FileWriteLog(@ScriptDir & $Way, 'Отработана кнопка промо')

;~ Проверка отработки программы

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')

Local $NAME_PROG = "Тестовая программа IT  КТН_1_ССБН"
Local $TEST_PROG = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:7]')
if $TEST_PROG == $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа ' & $TEST_PROG & ' отработала')

ControlClick("ЦО Тест", '','[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]')
ControlSend('ЦО Тест', '', '[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]', '{down}')

Local $TEST_PROG_RES = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:2]')
if $TEST_PROG_RES <> 0 Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа отработала, скидка равна: ' & $TEST_PROG_RES)
EndIf

if $TEST_PROG_RES == 0 or $TEST_PROG_RES == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не дала скидку, скидка = ' & $TEST_PROG_RES)
EndIf

EndIf

if $TEST_PROG == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не отработала')
EndIf

if $TEST_PROG <> $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: отработала другая программа: ' & $TEST_PROG)
EndIf


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

;~ Тест 9 Количество товара из набора/Базовый/Скидка % на количество из базового набора
_FileWriteLog(@ScriptDir & $Way, 'Тест 9 Количество товара из набора/Базовый/Скидка % на количество из базового набора')
Sleep(3000)

;~ Процедура добавления дисконтной карты

Send('{F3}')
Sleep(300)
Send('T159874')
Send('{enter}')
Sleep(3000)

if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось добавить диконтную карту. Тест завершился ошибкой')
Exit
EndIf
if WinActive('','Карточка не найдена') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти диконтную карту. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлена тестовая дисконтная карта T159874')

;~ добавление товара 2

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Кадует 5мг/10мг таб')
Sleep(300)
send('{enter}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

Send(3)
Send('{tab}')
Send(0)
send('{enter}')
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из базового набора')

;~ отработка кнопки промо

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)
_FileWriteLog(@ScriptDir & $Way, 'Отработана кнопка промо')

;~ Проверка отработки программы

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')

Local $NAME_PROG = "Тестовая программа IT  КТН_1_СКБН"
Local $TEST_PROG = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:7]')
if $TEST_PROG == $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа ' & $TEST_PROG & ' отработала')

ControlClick("ЦО Тест", '','[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]')
ControlSend('ЦО Тест', '', '[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]', '{down}')

Local $TEST_PROG_RES = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:2]')
if $TEST_PROG_RES <> 0 Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа отработала, скидка равна: ' & $TEST_PROG_RES)
EndIf

if $TEST_PROG_RES == 0 or $TEST_PROG_RES == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не дала скидку, скидка = ' & $TEST_PROG_RES)
EndIf

EndIf

if $TEST_PROG == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не отработала')
EndIf

if $TEST_PROG <> $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: отработала другая программа: ' & $TEST_PROG)
EndIf


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

;~ Тест 10 Количество товара из набора/Базовый/Начисление бонусы % на базовый набор 
_FileWriteLog(@ScriptDir & $Way, 'Тест 10 Количество товара из набора/Базовый/Начисление бонусы % на базовый набор ')
Sleep(3000)

;~ добавление товара 1

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Юніензим з МПС №20 таб')
Sleep(300)
send('{enter}')
Send('{down 6}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

send('{enter}')
Sleep(1000)
WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
	EndIf

_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из вторичного набора')

;~ Процедура добавления дисконтной карты

Send('{F3}')
Sleep(300)
Send('T159874')
Send('{enter}')
Sleep(3000)

if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось добавить диконтную карту. Тест завершился ошибкой')
Exit
EndIf
if WinActive('','Карточка не найдена') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти диконтную карту. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлена тестовая дисконтная карта T159874')

;~ отработка кнопки промо

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)
_FileWriteLog(@ScriptDir & $Way, 'Отработана кнопка промо')

;~ Проверка отработки программы

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')

Local $NAME_PROG = "Тестовая программа IT  КТН_1_НББН"

Local $TEST_PROG = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:7]')
if $TEST_PROG == $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа ' & $TEST_PROG & ' отработала')

ControlClick("ЦО Тест", '','[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]')
ControlSend('ЦО Тест', '', '[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]', '{down}')

Local $TEST_PROG_RES = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:5]')
if $TEST_PROG_RES <> 0 Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа отработала, насчитано бонусов: ' & $TEST_PROG_RES)
EndIf

if $TEST_PROG_RES == 0 or $TEST_PROG_RES == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не начислила бонусы, бонусы = ' & $TEST_PROG_RES)
EndIf

EndIf

if $TEST_PROG == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не отработала')
EndIf

if $TEST_PROG <> $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: отработала другая программа: ' & $TEST_PROG)
EndIf


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

;~ Тест 11 Количество товара из набора/Базовый/Скидка % на базовый набор 
_FileWriteLog(@ScriptDir & $Way, 'Тест 11 Количество товара из набора/Базовый/Скидка % на базовый набор')
Sleep(3000)
;~ добавление товара 1

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Тiнi для очей LYSEE тріо №03')
Sleep(300)
send('{enter}')
Send('{down 6}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

send('{enter}')
Sleep(1000)
WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
	EndIf

_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из вторичного набора')

;~ Процедура добавления дисконтной карты

Send('{F3}')
Sleep(300)
Send('T159874')
Send('{enter}')
Sleep(3000)

if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось добавить диконтную карту. Тест завершился ошибкой')
Exit
EndIf
if WinActive('','Карточка не найдена') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти диконтную карту. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлена тестовая дисконтная карта T159874')

;~ добавление товара 2

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Кислота янтарна 0_25 г N80')
Sleep(300)
send('{enter}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

Send(1)
Send('{tab}')
Send(0)
send('{enter}')
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из базового набора')

;~ отработка кнопки промо

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)
_FileWriteLog(@ScriptDir & $Way, 'Отработана кнопка промо')

;~ Проверка отработки программы

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')

Local $NAME_PROG = "Тестовая программа IT  КТН_1_ВБН"
Local $TEST_PROG = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:7]')
if $TEST_PROG == $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа ' & $TEST_PROG & ' отработала')

ControlClick("ЦО Тест", '','[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]')
ControlSend('ЦО Тест', '', '[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]', '{down}')

Local $TEST_PROG_RES = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:2]')
if $TEST_PROG_RES <> 0 Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа отработала, скидка равна: ' & $TEST_PROG_RES)
EndIf

if $TEST_PROG_RES == 0 or $TEST_PROG_RES == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не дала скидку, скидка = ' & $TEST_PROG_RES)
EndIf

EndIf

if $TEST_PROG == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не отработала')
EndIf

if $TEST_PROG <> $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: отработала другая программа: ' & $TEST_PROG)
EndIf

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

;~ Тест 12 Количество однотипного товара из набора/Базовый/Скидка % на N-й базовый товар 
_FileWriteLog(@ScriptDir & $Way, 'Тест 12 Количество однотипного товара из набора/Базовый/Скидка % на N-й базовый товар')
Sleep(3000)

;~ Процедура добавления дисконтной карты

Send('{F3}')
Sleep(300)
Send('T159874')
Send('{enter}')
Sleep(3000)

if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось добавить диконтную карту. Тест завершился ошибкой')
Exit
EndIf
if WinActive('','Карточка не найдена') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти диконтную карту. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлена тестовая дисконтная карта T159874')

;~ добавление товара 2

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Сойфем 100мг №60 тб')
Sleep(300)
send('{enter}')
Sleep(2000)
send('{enter}')

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

Send(2)
Send('{tab}')
Send(0)
send('{enter}')
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар из базового набора')

;~ отработка кнопки промо

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)
_FileWriteLog(@ScriptDir & $Way, 'Отработана кнопка промо')

;~ Проверка отработки программы

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')

Local $NAME_PROG = "Тестовая программа IT КОТ_1_СКNБТ"

Local $TEST_PROG = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:7]')
if $TEST_PROG == $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа ' & $TEST_PROG & ' отработала')

ControlClick("ЦО Тест", '','[CLASS:WindowsForms10.Window.8.app.0.378734a; INSTANCE:12]')


Local $TEST_PROG_RES = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:2]')
if $TEST_PROG_RES <> 0 Then
	_FileWriteLog(@ScriptDir & $Way, 'Программа отработала, скидка равна: ' & $TEST_PROG_RES)
EndIf

if $TEST_PROG_RES == 0 or $TEST_PROG_RES == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не дала скидку, скидака = ' & $TEST_PROG_RES)
EndIf

EndIf

if $TEST_PROG == Null Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Программа не отработала')
EndIf

if $TEST_PROG <> $NAME_PROG Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: отработала другая программа: ' & $TEST_PROG)
EndIf

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

;~ Закрытие программы.

WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Тест завершен успешно.')

Exit