﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Попытка
		ФормаПанелиТелефонии = Вычислить("МИКО_Телефония");
	Исключение
	КонецПопытки;
	
	Если ФормаПанелиТелефонии <> Неопределено Тогда
		Если ФормаПанелиТелефонии.Открыта() Тогда
			ФормаПанелиТелефонии.Активизировать(); 
		Иначе
			ФормаПанелиТелефонии.Открыть();
		КонецЕсли;	
		Возврат;
	Иначе
		МИКО_Телефония = ОткрытьФорму("Обработка.МИКО_тПодсистемаУведомлений.Форма");
	КонецЕсли; 
		
КонецПроцедуры
