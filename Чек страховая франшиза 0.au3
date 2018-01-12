
#cs
Далее всё с правами администратора, ориентацыя по окну, лог.
#ce
#RequireAdmin
#include <File.au3>
AutoItSetOption('mousecoordmode',0)

#cs
Процедура авторизации усовершенствованная.
#ce
Local $Way = '\Лог выполнения теста\Чек страховая франшиза 0.log'

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

#cs
Процедура подключения к КА с  отработкой ошибок и исключений
#ce

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

#cs
добавление товара 1 на 6 строчек ниже.
#ce

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

#cs
Процедура добавления дисконтной карты
#ce

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

#cs
добавление товара 2 просто товар клавиатура
#ce

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

#cs
добавление товара 3 просто товар клавиатура
#ce

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

Send(2)
Send('{tab}')
Send(3)
send('{enter}')
Sleep(500)

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Добавить товар в чек. Тест завершился ошибкой')
Exit
EndIf

_FileWriteLog(@ScriptDir & $Way, 'Добавлен товар в чек. Дробное количество')

#cs
добавление товара 4 с маской _

#ce

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
#cs
добавление товара 5 просто товар мышь
#ce

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

#cs
отработка кнопки промо
#ce

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)

_FileWriteLog(@ScriptDir & $Way, 'Отработана кнопка промо')

#cs
Процедура добавления карты и заполнения информации по страховой.
#ce

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
Send('147852369')
send('{tab}')
Send('Иванов')
send('{tab}')
Send('Иван')
send('{tab}')
Send('Иванович')
send('{tab}')
Send('369852147')
send('{tab 2}')
Send(0)
_FileWriteLog(@ScriptDir & $Way, 'Заполнена франшиза 0%')
send('{tab}')
Send(0)
send('{tab}')
Send(0)
send('{tab}')
Send(0)
send('{tab}')
Send(0)
send('{tab}')
Send(0)
send('{tab}')
Send(0)
send('{tab 2}')
Send('Турмагамбиев Аслан Зубекович')
Send('{enter}')

if WinActive('Ошибка') <> 0 or WinActive('','Контроль')<> 0 or WinActive('','ОШИБКА:ORA-')<> 0  Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось заполнить данные покупателя. Тест завершился ошибкой')
Exit
EndIf

_FileWriteLog(@ScriptDir & $Way, 'Заполнены данные покупателя')

#cs
Пробитие чека.

#ce

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Sleep(1000)
Send('{esc}')
#cs
MouseClick('primary',318,54,1,1)
#ce
WinWaitActive('Оплата по чеку', '', 10)
if WinActive ('Оплата по чеку') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось Открыть форму оплаты чека. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Оплата по чеку')
Sleep(500)
send(1000)
Send('{enter}')
WinActivate('ЦО Тест')
if WinActive ('Оплата по чеку') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось пробить чек. Тест завершился ошибкой')
Exit
EndIf


_FileWriteLog(@ScriptDir & $Way,"Пробитие чека наличка")

#cs
Закрытие окна чека
#ce

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

#cs
Открытие чека возврата, последнего пробитого.
#ce

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

#cs
Пробитие чека возврата.
#ce

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

#cs
Закрытие программы.
#ce

WinClose('ПО ТОТУС-ФРОНТ')

_FileWriteLog(@ScriptDir & $Way, 'Тест завершен успешно.')

Exit