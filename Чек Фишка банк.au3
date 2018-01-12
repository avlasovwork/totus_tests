;~ Далее всё с правами администратора, ориентацыя по окну, лог.

#RequireAdmin
#include <File.au3>
AutoItSetOption('mousecoordmode',0)

;~ Процедура авторизации усовершенствованная.

Local $Way = '\Лог выполнения теста\Чек фишка банк.log'

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

;~ Процедура добавления дисконтной карты Фишка

Send('{F3}')
Sleep(500)
Send(1000000015898)
Send('{enter}')

WinWaitActive('', 'Чек переключился в тип', 10)
if WinActive('','Чек переключился в тип') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way,'Ошибка, не получилось найти карту фишка. Тест завершился ошибкой')
Exit
	EndIf
WinWaitActive('','Чек переключился в тип')
Send('{enter}')
WinActivate('ЦО Тест')
if WinActive ('','Чек переключился в тип') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось добавить карту фишка в чек. Тест завершился ошибкой')
Exit
	EndIf
_FileWriteLog(@ScriptDir & $Way, 'Добавленакарта фишка 1000000015898 в чек.')

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

;~ Пробитие чека. Фишка

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Sleep(1000)
Send('{esc}')

WinWaitActive('Отчет по фишка', '', 10)
if WinActive ('Отчет по фишка') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось получить ответ от фишки. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Отчет по фишка')

Send('{tab}')
Sleep(500)
Send('{enter}')

WinWaitActive('Оплата по чеку', '', 10)
if WinActive ('Оплата по чеку') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось открыть окно оплаты по чеку. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Оплата по чеку')

Sleep(500)
send('{f3}')
Send('{enter}')

WinActivate('ЦО Тест')
if WinActive ('Дробное количество') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось пробить чек. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Пробит чек фишка по банку')

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

;~ Пробитие чека возврата. фишка

WinWaitActive('', 'Чек переключился в тип', 10)
if WinActive('','Чек переключился в тип') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось открыть чек возврата фишка. Тест завершился ошибкой')
Exit
	EndIf
WinWaitActive('','Чек переключился в тип')
Send('{enter}')
Sleep(500)

WinWaitActive('ЦО Тест', '', 10)
if WinActive ('ЦО Тест') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось открыть чек возврата фишка. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('ЦО Тест')

Sleep(800)
Send('{esc}')

WinWaitActive('Данные покупателя', '', 10)
if WinActive ('Данные покупателя') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не удалось открыть форму данные покупателя. Тест завершился ошибкой')
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

WinWaitActive('Отчет по фишка', '', 10)
if WinActive ('Отчет по фишка') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось получить ответ от фишки. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Отчет по фишка')

send('{tab}')
Sleep(500)
Send('{enter}')

WinWaitActive('Оплата по чеку', '', 10)
if WinActive ('Оплата по чеку') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось открыть окно оплаты по чеку. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Оплата по чеку')

Send('{enter}')

WinActivate('ПО ТОТУС-ФРОНТ')
if WinActive ('ЦО Тест') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, Не удалось пробить чек возврата. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Возврат. Пробит последний пробитый чек фишка')

;~ Закрытие программы.

WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Тест завершен успешно.')

Exit