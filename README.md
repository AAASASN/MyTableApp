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
