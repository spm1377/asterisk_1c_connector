﻿

// Процедура позволяет открыть карточку клиента.
// 
Процедура ОткрытьКарточкуКлиента(Параметры) Экспорт

	

КонецПроцедуры

// Обработка ошибочной ситуации. К примеру ошибка соединения.
// 
Процедура ОбработкаОшибкиСервераВзаимодействий(ДополнительныеПараметры, п2, п3) Экспорт
	Сообщить("Ошибка");	
КонецПроцедуры

// Получение и обработка оповещений полученных через канал уведомлений.
// 
Процедура ОбработкаОповещенийСервераВзаимодействий(Сообщение, ДополнительныеПараметры) Экспорт
	Событие = Неопределено;
	Если ТипЗнч(Сообщение.Данные) = Тип("Структура") И Сообщение.Данные.Свойство("Event",Событие) Тогда		
		Оповестить("МИКО_ВнешнееСобытие", Сообщение, Событие);
	КонецЕсли;
КонецПроцедуры
 
// Отсекает плечо в канале
// Local/04@internal-caller-transfer-000001f0;2
// Local/04@internal-caller-transfer-000001f0
Функция ОтсечьПлечоВLocal(Знач Канал, Врег=Истина) Экспорт
	Канал = СтрЗаменить(Канал,"<ZOMBIE>", "");
	
	ПозицияТочки = Найти(Канал, ";");
	Если ПозицияТочки > 0 Тогда
		Канал = Лев(Канал, ПозицияТочки - 1);
	КонецЕсли; 
	
	Если Врег=Истина Тогда
	    Возврат Врег(Канал);
	Иначе		
	    Возврат Канал;
	КонецЕсли; 
КонецФункции // ОтсечьПлечоВLocal()

// Открывает карточку нового события.
// 
Функция ОткрытьЗаполнитьДокументСобытие(ПараметрыВызова) Экспорт

	Если СтрДлина(ПараметрыВызова.ЗначениеКИ) < 5 Тогда
	
	Иначе	
		// Соединение с внешним номером.
		ФормаДокумента = ОткрытьФорму("Документ.Событие.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ПараметрыВызова));		
		докСобытие 	= ФормаДокумента.Объект;
		
		ДанныеЗаполнения = Новый Структура;
		ДанныеЗаполнения.Вставить("Тема", "Телефонный звонок, т. " + ПараметрыВызова.ЗначениеКИ);
		
		ЗаполнитьЗначенияСвойств(докСобытие, 	 ДанныеЗаполнения);
		ЗаполнитьЗначенияСвойств(ФормаДокумента, ДанныеЗаполнения);
		
		докСобытие.ВходящееИсходящееСобытие = ?(ПараметрыВызова.Входящий, 
								ПредопределенноеЗначение("Перечисление.ВходящееИсходящееСобытие.Входящее"), 
								ПредопределенноеЗначение("Перечисление.ВходящееИсходящееСобытие.Исходящее"));
		Контакт = ?(ЗначениеЗаполнено(ПараметрыВызова.Контакт), ПараметрыВызова.Контакт, "Неизвестный клиент"); 
		
		Если НЕ ЗначениеЗаполнено(ПараметрыВызова.Контакт) Тогда
			клДанныеЗаполнения = Новый Структура;
			клДанныеЗаполнения.Вставить("КонтактноеЛицо", 		ПараметрыВызова.Контакт);
			клДанныеЗаполнения.Вставить("Контакт", 		  		ПараметрыВызова.Контакт);
			клДанныеЗаполнения.Вставить("КакСвязаться",   		ПараметрыВызова.ЗначениеКИ);
			клДанныеЗаполнения.Вставить("ПредставлениеКонтакта",ПараметрыВызова.ЗначениеКИ);
			ЗаполнитьЗначенияСвойств( ФормаДокумента.Контакты.Добавить(), клДанныеЗаполнения);
		КонецЕсли;
		
		// Определим имя реквизита ID_Звонок и запишем в него ID текущего звонка.
		ID_Звонок = МИКО_тИнтеграция1СТелефонияСервер.ПолучитьСсылкуНаID_Звонок();
		Если ЗначениеЗаполнено(ID_Звонок) Тогда
			ИмяКоллекции = "Свойства_ОписаниеДополнительныхРеквизитов";
			РезультатПоиска = ФормаДокумента[ИмяКоллекции].НайтиСтроки(Новый Структура("Свойство", ID_Звонок));
			Если РезультатПоиска.Количество() > 0 Тогда
				ИмяРеквизита = РезультатПоиска[0].ИмяРеквизитаЗначение;
				ФормаДокумента[ИмяРеквизита] = ПараметрыВызова.linkedid;
			КонецЕсли;

			врСвойства = докСобытие.ДополнительныеРеквизиты.НайтиСтроки(Новый Структура("Свойство", ID_Звонок));
			Если врСвойства.Количество()=0 Тогда
				СвойствоID_Звонок = докСобытие.ДополнительныеРеквизиты.Добавить();
				СвойствоID_Звонок.Свойство = ID_Звонок
			Иначе
				СвойствоID_Звонок = врСвойства[1];
			КонецЕсли;                                             
			СвойствоID_Звонок.Значение 		  = ПараметрыВызова.linkedid;
			СвойствоID_Звонок.ТекстоваяСтрока = ПараметрыВызова.linkedid;

		КонецЕсли;

	КонецЕсли; 

КонецФункции // ОткрытьКарточкуКлиентаИлиСобытие()
 