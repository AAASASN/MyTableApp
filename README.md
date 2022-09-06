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
