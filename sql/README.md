# SQL-анализ

Скрипты предназначены для MySQL 8+ и запускаются через MySQL Workbench.

1. Создайте схему `alihan_analytics` в MySQL Workbench и сделайте её активной.
2. Запустите `schema.sql`.
3. Импортируйте `../data/sales_data.csv` в таблицу `sales` через Table Data Import Wizard.
4. Выполните `validation_queries.sql` и сверьте контрольные показатели.
5. Запускайте запросы из `analysis_queries.sql` по разделам.

После импорта должно быть 1 000 строк, 442 510 380 ₸ выручки и 31 466 проданных единиц. Поле `sale_id` создаётся автоматически и не включается в импорт CSV.

