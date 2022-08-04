# MyTableApp 

v 0.1.0 

- ветка branch_for_Usov_version будет переименована в формат v 0.1.XXX. Здесь и далее будет описание реализации экранов и их взаимодействие друг с другом

v 0.1.1
Переработан экран StartTableViewController
- секции больше не используются
- добавлено удаление ячейки по свайпу влево
- добавлен метод getEventHolderAndEventArray() в класс EventStorage

v 0.1.2 
- добавлен класс CustomDate позволяющий работать в объектом класса Date и вычислять в свойстве daysCountBeforeEvent количество дней до события
- внесены правки в StartTableViewController для отображения daysCountBeforeEvent в ячейке StartControllerCustomCell