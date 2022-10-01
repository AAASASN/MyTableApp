# MyTableApp 

v 0.1.0 Создание новой ветки для реализации функционала приложения на основе UINavigationController и UITableViewController
- ветка branch_for_Usov_version будет переименована в формат v 0.1.XXX. Здесь и далее будет описание реализации экранов и их взаимодействие друг с другом

v 0.1.1 Переработан экран StartTableViewController
- секции больше не используются
- добавлено удаление ячейки по свайпу влево
- добавлен метод getEventHolderAndEventArray() в класс EventStorage

v 0.1.2 Добавлен класс CustomDate
- добавлен класс CustomDate позволяющий работать в объектом класса Date и вычислять в свойстве daysCountBeforeEvent количество дней до события
- внесены правки в StartTableViewController для отображения daysCountBeforeEvent в ячейке StartControllerCustomCell

v 0.1.3 Изменены ChangeEventHolderStatusCustomTableViewCell и ChangeEventHolderSexTableViewController
- доработана логика установки галочки на экранах выбора пола и статуса 

v 0.1.4 Проработка экрана AddEventHolderTableViewController
- добавлена кнопка Сохранить
- доработана логика активации кнопки Сохранить при заполнении полей, выбора Статуса и Пола
- создание и отображение события по умолчанию (это ДР) после нажания кнопки сохранить - добавление еще одной секции
- добавлена кнопка "Добавить событие" в третьей секции

v 0.1.5 Проработка экрана AddEventHolderTableViewController, добавлен экран ShowAllEventsOfSomeHolderTableViewController
- с экрана AddEventHolderTableViewController убрана кнопка Сохранить
- на экране AddEventHolderTableViewController в отдельной ячейке просто указывается количество событий пользователя, при нажатии на эту ячейку отображается экран ShowAllEventsOfSomeHolderTableViewController, в нем отображаются все события пользователя через динамическую таблицу а так же в отдельной секции отображается кнопка "Добавить событие"
- на экране ShowAllEventsOfSomeHolderTableViewController при нажатии на кнопку "Добавить событие" открывается экран AddEventTableViewController на нем можно добавить новое событие
- между экранами AddEventTableViewController , ShowAllEventsOfSomeHolderTableViewController и AddEventHolderTableViewController данные передаются при помощи self.navigationController?.viewControllers.forEach{

v 0.1.6 Добавлено сохранение данных в память устройства при помощи UserDafaults, протокола Codable и классов JSONEncoder() и JSONDecoder()
- все классы модели подписаны на протокол Codable
- для возможности работы с массивом значений [EventHolder] посредством JSONEncoder() и JSONDecoder(), массив упакован в класс EventHolderArrayAsClass()
- в моделе EventStorage созданы приватные методы для работы с UserDafaults и открытые методы для работы с хранилищем из Контроллера

v 0.1.7 Доработаны связи между экранами
- все экраны между собой обмениваются данными о EventHolder и Events через хранилище модели EventStorage

v 0.1.8 Экран добавления Юбиляра сменил контроллер AddEventHolderTableViewController на базе TableViewController со статической таблицей на AddEventHolderViewController на базе ViewController с TableView с динамическими ячейками
- созданы пять кастомных ячеек FirstNameTextFieldTableViewCell, LastNameTextFieldTableViewCell, DateTextFiedTableViewCell, PhoneNumberTextFieldTableViewCell с UITextField для ввода данных и SexAndStatusTableViewCell для отображения и выбора пола и статуса
- настроены клавиатуры ввода для каждого типа данных в текстовые поля
- настроен NavigationBar
- настроена передача данных(с использованием замыкания) и выбор пола и статуса между AddEventHolderViewController и ChangeEventHolderSexTableViewController, AddEventHolderViewController и ChangeEventHolderStatusTableViewController

v 0.1.9 Некоторые доработки связанные с переходом с контроллера AddEventHolderTableViewController  на контроллер AddEventHolderViewController
- доработана модель EventHolder добавлено свойство ID для более удобного учета и операций в хранилище
- добавлена кнопка "Добывить событие" в виде кастомной ячейки-кнопки во второй секции 
- доработано сохраненение в хранилище EventHolder и сохранение Event, а также изменение полей AddEventHolderViewController и свойств EventHolder


v 0.2.1 С этого коммита будет изменена работа с ветками. Будет существовать основная ветка main, от нее будет создано ответвление develop, от develop будут создаваться ветки для новых фич и потом вливаться develop. При достижении стабильного кода в ветке develop код периодически будет сливаться с main.
- настроен переход с кнопки "Добывить событие" на новый экран с полями для добавления события
- создание и передача созданного события на AddEventHolderViewController с последущей передачей в хранилище и отображением во второй секции и на о сновном экране

v 0.2.2 Добавлен DetailedEventViewController и Nib файлOneEventSomeHolderTableViewCell_xib - ячейка на его основе которой реализованы ячейки на экранах DetailedEventViewController AddEventHolderViewController
