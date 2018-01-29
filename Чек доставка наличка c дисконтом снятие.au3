;~ Далее всё с правами администратора, ориентацыя по окну, лог.
#RequireAdmin
#include <File.au3>
AutoItSetOption('mousecoordmode',0)

;~ Процедура авторизации усовершенствованная
Local $Way = '\Лог выполнения теста\Чек доставка наличка c дисконтом снятие.log'

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
if WinActive('','Карточка не найдена') <> 0 Then
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

;~ списание бонусов.

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)
MouseClick('primary',1670,194,2,1)
Sleep(1000)
Send(100)
send('{enter}')
Sleep(3000)

if WinActive('Ошибка') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось списать бонусы. Тест завершился ошибкой')
Exit
EndIf
if WinActive('','Сумма списания бонусов не может быть больше суммы розничной')== 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, сумма списания бонусов больше суммы розничной. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Списано 200 бонусов')

;~ отработка кнопки промо

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)
_FileWriteLog(@ScriptDir & $Way, 'Отработана кнопка промо')

;~ Меняем тип чека на доставка

Send('{F2}')
WinWaitActive('Тип чеков', '', 10)
if WinActive ('Тип чеков') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось найти товар. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Тип чеков')
send('{down}')
send('{enter}')
WinActivate('ЦО Тест')
if WinActive ('Тип чеков') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось изменить тип чека. Тест завершился ошибкой')
Exit
	EndIf
_FileWriteLog(@ScriptDir & $Way, 'Тип чека изменился на доставка')

;~ Заполнение информации по доставке

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
Sleep(1000)
ControlSend("ЦО Тест", "", "[CLASS:WindowsForms10.SysTabControl32.app.0.378734a; INSTANCE:2]", "^{tab}")
Sleep(400)
ControlSend("ЦО Тест", "", "[CLASS:WindowsForms10.SysTabControl32.app.0.378734a; INSTANCE:2]", "^{tab}")
Sleep(400)
ControlSend("ЦО Тест", "", "[CLASS:WindowsForms10.SysTabControl32.app.0.378734a; INSTANCE:2]", "^{tab}")
Sleep(400)
ControlSend("ЦО Тест", "", "[CLASS:WindowsForms10.SysTabControl32.app.0.378734a; INSTANCE:2]", "^{tab}")
Sleep(400)
ControlSend("ЦО Тест", "", "[CLASS:WindowsForms10.SysTabControl32.app.0.378734a; INSTANCE:2]", "^{tab}")
Sleep(400)
Local $FIO = "Власов Андрей Николаевич"
ControlSend("ЦО Тест", "", "[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:54]", $FIO)
_FileWriteLog(@ScriptDir & $Way, 'Заполнена данные ФИО: '& $FIO)
Sleep(400)
Local $PHONE = "0642508571"
ControlSend("ЦО Тест", "", "[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:53]", $PHONE)
_FileWriteLog(@ScriptDir & $Way, 'Заполнена данные ТЕЛЕФОН: '& $PHONE)
Sleep(400)
Local $ADDRESS = "г. Луганск ул. Будённого 59ж"
ControlSend("ЦО Тест", "", "[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:52]", $ADDRESS)
_FileWriteLog(@ScriptDir & $Way, 'Заполнена данные АДРЕС: '& $ADDRESS)
Sleep(400)
Local $TIME = "12 00"
ControlSend("ЦО Тест", "", "[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:50]", $TIME)
_FileWriteLog(@ScriptDir & $Way, 'Заполнена данные ВРЕМЯ: '& $TIME)
Sleep(400)
Local $COMMENT =  "Доставить в назначенное время"
ControlSend("ЦО Тест", "", "[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:51]", $COMMENT)
_FileWriteLog(@ScriptDir & $Way, 'Заполнена данные КОММЕНТАРИЙ: '& $COMMENT)
Sleep(400)
ControlClick("ЦО Тест", "","[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:19]")
Sleep(400)
ControlClick("ЦО Тест", "","[CLASS:WindowsForms10.COMBOBOX.app.0.378734a; INSTANCE:2]")
send('{down 4}')
send('{enter}')
Sleep(400)
ControlClick("ЦО Тест", "","[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:17]")
Sleep(400)
ControlClick("ЦО Тест", "","[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:16]")
Sleep(400)
ControlClick("ЦО Тест", "","[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:14]")
Sleep(400)
Local $TTN = "87654321"
ControlSend("ЦО Тест", "", "[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:49]", $TTN)
_FileWriteLog(@ScriptDir & $Way, 'Заполнена данные ТТН: '& $TTN)
Sleep(400)
Local $PAY = "1000"
ControlSend("ЦО Тест", "", "[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:48]", $PAY)
_FileWriteLog(@ScriptDir & $Way, 'Заполнена данные СУММА: '& $PAY)
Sleep(400)
ControlClick("ЦО Тест", "","[CLASS:WindowsForms10.COMBOBOX.app.0.378734a; INSTANCE:1]")
send('{down}')
send('{enter}')

_FileWriteLog(@ScriptDir & $Way, 'Успешно заполнена информация о доставке')

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
send(1000)
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
_FileWriteLog(@ScriptDir & $Way, 'Тест завершен успешно.')

Exit