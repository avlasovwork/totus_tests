;~ Далее всё с правами администратора, ориентацыя по окну, лог.
#RequireAdmin
#include <File.au3>
AutoItSetOption('mousecoordmode',0)

;~ Процедура авторизации усовершенствованная.
Local $Way = '\Лог выполнения теста\Проверка анкеты.log'

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


;~ Проверка анкеты
WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
ControlClick("ЦО Тест", '','[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:13]')
WinWaitActive('Возможность снятия бонусов по вашей карте')

WinWaitActive('Возможность снятия бонусов по вашей карте', '', 10)
if WinActive ('Возможность снятия бонусов по вашей карте') == 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не получилось открыть анкету. Тест завершился ошибкой')
Exit
	EndIf
WinActivate('Возможность снятия бонусов по вашей карте')

;~ Фамилия
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:18]')
Send('{BACKSPACE 10}')
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:15]')
if WinActive('','ОШИБКА:ORA-20002:  Заполните фамилию покупателя') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, анкета работает не корректно. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Отработал контроль Фамилии: "Заполните фамилию покупателя"')
Send('{enter}')
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:18]')
Send('Корнеев')

;~ Имя
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:17]')
Send('{BACKSPACE 10}')
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:15]')
if WinActive('','ОШИБКА:ORA-20002:  Заполните имя покупателя') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, анкета работает не корректно. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Отработал контроль Имя: "Заполните имя покупателя"')
Send('{enter}')
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:17]')
Send('Андрей')

;~ Отчество
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:16]')
Send('{BACKSPACE 10}')
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:15]')
if WinActive('','ОШИБКА:ORA-20002:  Заполните правильно отчество покупателя') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, анкета работает не корректно. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Отработал контроль Отчество: "Заполните правильно отчество покупателя"')
Send('{enter}')
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:16]')
Send('Иванович')

;~ Дата рождения меньше 18
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:9]')
Send(10)
Send('{right}')
Send(10)
Send('{right}')
Send(1920)
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:15]')
if WinActive('','ОШИБКА:ORA-20002: Укажите дату рождения ПРАВИЛЬНУЮ') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, анкета работает не корректно. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Отработал контроль дата рождения: "Укажите дату рождения ПРАВИЛЬНУЮ, Возраст больше 90 лет"')
Send('{enter}')
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:9]')
Send(12)
Send('{right}')
Send(12)
Send('{right}')
Send(1990)

;~ Дата рождения больше 90
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:9]')
Send(10)
Send('{right}')
Send(10)
Send('{right}')
Send(2012)
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:15]')
if WinActive('','ОШИБКА:ORA-20002: Укажите дату рождения ПРАВИЛЬНУЮ') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, анкета работает не корректно. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Отработал контроль дата рождения: "Укажите дату рождения ПРАВИЛЬНУЮ, Возраст меньше 18 лет"')
Send('{enter}')
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:9]')
Send(12)
Send('{right}')
Send(12)
Send('{right}')
Send(1990)

;~ Телефон
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:12]')
Send('{BACKSPACE 10}')
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:15]')
if WinActive('','ОШИБКА:ORA-20002: Заполните мобильный телефон или домашний') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, анкета работает не корректно. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Отработал контроль Телефона: "Заполните мобильный телефон или домашний"')
Send('{enter}')
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.EDIT.app.0.378734a; INSTANCE:12]')
Send('{BACKSPACE 10}')
Send(6252811)

;~ Соотвецтвие отчества полу
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.COMBOBOX.app.0.378734a; INSTANCE:1]')
Send('{up}')
Send('{enter}')
;~ ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:15]')
MouseClick('primary',701,580,1,1)
if WinActive('','ОШИБКА:ORA-20002: Отчество несоотвествует полу') <> 0 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, анкета работает не корректно. Тест завершился ошибкой')
Exit
EndIf
_FileWriteLog(@ScriptDir & $Way, 'Отработал контроль Отчество: "Отчество несоотвествует полу покупателя"')
Send('{enter}')
ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.COMBOBOX.app.0.378734a; INSTANCE:1]')
Send('{down}')
Send('{enter}')
Sleep(5000)

ControlClick("Возможность снятия бонусов по вашей карте", '','[CLASS:WindowsForms10.BUTTON.app.0.378734a; INSTANCE:15]')

if WinActive ('Возможность снятия бонусов по вашей карте') == 1 Then
WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Ошибка, не удалось закрыть анкету. Тест завершился ошибкой')
Exit
EndIf

_FileWriteLog(@ScriptDir & $Way, 'Тест анкеты завершен успешно.')

Sleep(5000)

;~ отработка кнопки промо

WinWaitActive('ЦО Тест')
WinActivate('ЦО Тест')
MouseClick('primary',1574,835,1,1)
Sleep(1000)

_FileWriteLog(@ScriptDir & $Way, 'Отработана кнопка промо')

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

;~ Закрытие программы.

WinClose('ПО ТОТУС-ФРОНТ')
_FileWriteLog(@ScriptDir & $Way, 'Тест завершен успешно.')


Exit