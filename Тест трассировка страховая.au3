;~ Далее всё с правами администратора, ориентацыя по окну, лог.
#RequireAdmin
#include <File.au3>
AutoItSetOption('mousecoordmode',0)

;~ Процедура авторизации усовершенствованная.
Local $Way = '\Лог выполнения теста\тест трассировка страховая.log'

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

;~ добавление товара 1 на 6 строчек ниже.

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Аладин 10мг')
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

_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар в чек. Клавиатура на 6 строк ниже.')

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
if WinActive('','Карточка не найдена')<>0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти диконтную карту. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлена тестовая дисконтная карта T159874')

;~ добавление товара 2 просто товар клавиатура

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Корвалмент капс')
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

send('{enter}')
Sleep(1000)
WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
	EndIf

_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар в чек. Клавиатура')

;~ добавление товара 3 просто товар клавиатура

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('Фармацитрон')
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

Send(0)
Send('{tab}')
Send(1)
send('{enter}')
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf

_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар в чек. Дробное количество')

;~ добавление товара 4 с маской _

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Send('{INS}')
Send('_бупрофен')
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

send('{enter}')
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf

_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар в чек. Поиск по маске')

;~ добавление товара 5 просто товар мышь

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',75,190,1,1)
Send('Торсид 5мг ')
Sleep(300)
MouseClick('primary',1243,190,1,1)
Sleep(2000)
MouseClick('primary',65,290,2,1)

WinWaitActive('Дробное количество', '', 10)
if WinActive ('Дробное количество') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Дробное количество')

MouseClick('primary',191,326,1,1)
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf

_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар в чек. Мышь')

;~ отработка кнопки промо

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)

_FileWriteLog(@ScriptDir & $Way, 'Отработана кнопка промо')

;~ Процедура добавления карты и заполнения информации по страховой.

Send('{F3}')
Sleep(300)
Send('ff001',1)
Send('{enter}')
Sleep(1000)


if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось добавить  карту страховой. Тест завершился ошибкой')
Exit
EndIf
if WinActive('','Карточка не найдена')<>0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти карту Страховой. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавлена карта страховой ff001')

MouseClick('primary',1773,634,1,1)
Sleep(300)
MouseClick('primary',1246,665,1,1)
Local $zaavka = ('147852369')
Local $family = ('Иванов')
Local $name = ('Иван')
Local $soname = ('Иванович')
Local $polis = ('369852147')
Local $stavka = (10)
Local $doc = ('100500')
Local $prim2 = ('Примечание 2')
Local $prim1 = ('Примечание 1')
Local $prim = ('Примечание')
Local $diagnoz = ('Меломания')
Local $nameLPY = ('Феофания')
Local $docname = ('Турмагамбиев Аслан Зубекович')
Local $SK = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:34]')

Send($zaavka)
send('{tab}')
Send($family)
send('{tab}')
Send($name)
send('{tab}')
Send($soname)
send('{tab}')
Send($polis)
send('{tab 2}')
Send($stavka)
_FileWriteLog(@ScriptDir & $Way, 'Заполнена франшиза ' & $stavka)
send('{tab}')
Send($doc)
send('{tab}')
Send($prim2)
send('{tab}')
Send($prim1)
send('{tab}')
Send($prim)
send('{tab}')
Send($diagnoz)
send('{tab}')
Send($nameLPY)
send('{tab 2}')
Send($docname)
Send('{enter}')
_FileWriteLog(@ScriptDir & $Way, 'Заполнена данные: '& $zaavka &' '& $family &' '& $name &' '& $soname &' '& $polis &' '& $doc &' '& $prim2 &' '& $prim1 &' '& $prim &' '& $diagnoz &' '& $nameLPY &' '& $docname)
Local $SK = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:34]')
_FileWriteLog(@ScriptDir & $Way, 'Страховая компания: '& $SK)


if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось заполнить данные покупателя. Тест завершился ошибкой')
Exit
EndIf

_FileWriteLog(@ScriptDir & $Way, 'Заполнены данные покупателя')

;~ Пробитие чека.

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Sleep(1000)
Send('{esc}')
WinWaitActive('Оплата по чеку', '', 10)
if WinActive ('Оплата по чеку') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Открыть форму оплаты чека. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Оплата по чеку')
Sleep(500)
Local $Oplata = ControlGetText('Оплата по чеку','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:3]')
send($Oplata)
_FileWriteLog(@ScriptDir & $Way, 'Введена сумма оплаты: ' & $Oplata)

Send('{enter}')
WinActivate('ЦО Тест')
if WinActive ('Оплата по чеку') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось пробить чек. Тест завершился ошибкой')
Exit
EndIf


_FileWriteLog(@ScriptDir & $Way,"Пробитие чека наличка")

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

;~ Открытие пробитого чека

MouseClick('primary',99,43,1,1)
Sleep(300)
MouseClick('primary',107,70,1,1)
Sleep(3000)
send('{tab 10}')
send('{down 500}')
Send('{enter}')
_FileWriteLog(@ScriptDir & $Way, 'Открыт последний побитый чек')

WinWaitActive('ЦО Тест', '', 5)
if WinActive ('ЦО Тест') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, Закрыть форму чек. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('ЦО Тест')

;~ 1
Local $zaavka_pr = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:14]')

if $zaavka_pr == $zaavka Then
	_FileWriteLog(@ScriptDir & $Way, 'Данные поля ЗАЯВКА на месте,  исходная строка: '& $zaavka &' после пробития: '& $zaavka_pr)
EndIf
if $zaavka_pr <> $zaavka Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Данные поля ЗАЯВКА изменились, исходная строка: '& $zaavka &' после пробития: '& $zaavka_pr)
EndIf
;~ 2
Local $family_pr = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:13]')
if $family_pr == $family Then
	_FileWriteLog(@ScriptDir & $Way, 'Данные поля ФАМИЛИЯ на месте,  исходная строка: '& $family &' после пробития: '& $family_pr)
EndIf
if $family_pr <> $family Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Данные поля ФАМИЛИЯ изменились, исходная строка: '& $family &' после пробития: '& $family_pr)
EndIf
;~ 3
Local $name_pr = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:12]')
if $name_pr == $name Then
	_FileWriteLog(@ScriptDir & $Way, 'Данные поля ИМЯ на месте,  исходная строка: '& $name &' после пробития: '& $name_pr)
EndIf
if $name_pr <> $name Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Данные поля ИМЯ изменились, исходная строка: '& $name &' после пробития: '& $name_pr)
EndIf
;~ 4
Local $soname_pr = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:9]')
if $soname_pr == $soname Then
	_FileWriteLog(@ScriptDir & $Way, 'Данные поля ОТЧЕСТВО на месте,  исходная строка: '& $soname &' после пробития: '& $soname_pr)
EndIf
if $soname_pr <> $soname Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Данные поля ОТЧЕСТВО изменились, исходная строка: '& $soname &' после пробития: '& $soname_pr)
EndIf
;~ 5
Local $polis_pr = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:10]')
if $polis_pr == $polis Then
	_FileWriteLog(@ScriptDir & $Way, 'Данные поля № ПОЛИСА на месте,  исходная строка: '& $polis &' после пробития: '& $polis_pr)
EndIf
if $polis_pr <> $polis Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Данные поля № ПОЛИСА изменились, исходная строка: '& $polis &' после пробития: '& $polis_pr)
EndIf
;~ 6
Local $stavka_pr = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:8]')
if $stavka_pr == $stavka Then
	_FileWriteLog(@ScriptDir & $Way, 'Данные поля % ФРАНШИЗЫ на месте,  исходная строка: '& $stavka &' после пробития: '& $stavka_pr)
EndIf
if $stavka_pr <> $stavka Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Данные поля % ФРАНШИЗЫ изменились, исходная строка: '& $stavka &' после пробития: '& $stavka_pr)
EndIf
;~ 7
Local $doc_pr = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:3]')
if $doc_pr == $doc Then
	_FileWriteLog(@ScriptDir & $Way, 'Данные поля ДОКУМЕНТ на месте,  исходная строка: '& $doc &' после пробития: '& $doc_pr)
EndIf
if $doc_pr <> $doc Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Данные поля ДОКУМЕНТ изменились, исходная строка: '& $doc &' после пробития: '& $doc_pr)
EndIf
;~ 8
Local $prim2_pr = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:7]')
if $prim2_pr == $prim2 Then
	_FileWriteLog(@ScriptDir & $Way, 'Данные поля ПРИМЕР 2 на месте,  исходная строка: '& $prim2 &' после пробития: '& $prim2_pr)
EndIf
if $prim2_pr <> $prim2 Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Данные поля ПРИМЕР 2 изменились, исходная строка: '& $prim2 &' после пробития: '& $prim2_pr)
EndIf
;~ 9
Local $prim1_pr = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:6]')
if $prim1_pr == $prim1 Then
	_FileWriteLog(@ScriptDir & $Way, 'Данные поля ПРИМЕР 1 на месте,  исходная строка: '& $prim1 &' после пробития: '& $prim1_pr)
EndIf
if $prim1_pr <> $prim1 Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Данные поля ПРИМЕР 1 изменились, исходная строка: '& $prim1 &' после пробития: '& $prim1_pr)
EndIf
;~ 10
Local $prim_pr = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:5]')
if $prim_pr == $prim Then
	_FileWriteLog(@ScriptDir & $Way, 'Данные поля ПРИМЕР на месте,  исходная строка: '& $prim &' после пробития: '& $prim_pr)
EndIf
if $prim_pr <> $prim Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Данные поля ПРИМЕР изменились, исходная строка: '& $prim &' после пробития: '& $prim_pr)
EndIf
;~ 11
Local $diagnoz_pr = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:4]')
if $diagnoz_pr == $diagnoz Then
	_FileWriteLog(@ScriptDir & $Way, 'Данные поля ДИАГНОЗ на месте,  исходная строка: '& $diagnoz &' после пробития: '& $diagnoz_pr)
EndIf
if $diagnoz_pr <> $diagnoz Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Данные поля ДИАГНОЗ изменились, исходная строка: '& $diagnoz &' после пробития: '& $diagnoz_pr)
EndIf
;~ 12
Local $nameLPY_pr = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:2]')
if $nameLPY_pr == $nameLPY Then
	_FileWriteLog(@ScriptDir & $Way, 'Данные поля НАЗВАНИЕ ЛПУ на месте,  исходная строка: '& $nameLPY &' после пробития: '& $nameLPY_pr)
EndIf
if $nameLPY_pr <> $nameLPY Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Данные поля НАЗВАНИЕ ЛПУ изменились, исходная строка: '& $nameLPY &' после пробития: '& $nameLPY_pr)
EndIf
;~ 13
Local $docname_pr = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:1]')
if $docname_pr == $docname Then
	_FileWriteLog(@ScriptDir & $Way, 'Данные поля ДОКТОР на месте,  исходная строка: '& $docname &' после пробития: '& $docname_pr)
EndIf
if $docname_pr <> $docname Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Данные поля ДОКТОР изменились, исходная строка: '& $docname &' после пробития: '& $docname_pr)
EndIf
;~ 14
Local $SK_pr = ControlGetText('ЦО Тест','','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:11]')
if $SK_pr == $SK Then
	_FileWriteLog(@ScriptDir & $Way, 'Данные поля СТРАХОВАЯ на месте,  исходная строка: '& $SK &' после пробития: '& $SK_pr)
EndIf
if $SK_pr <> $SK Then
	_FileWriteLog(@ScriptDir & $Way, 'Ошибка: Данные поля СТРАХОВАЯ изменились, исходная строка: '& $SK &' после пробития: '& $SK_pr)
EndIf


Sleep(3000)

;~ Закрытие программы.

WinClose('ПО ТОТУС-ФРОНТ')

_FileWriteLog(@ScriptDir & $Way, 'Тест завершен успешно.')

Exit