USE online_clinic;

#ЗАПРОСЫ

# Возраст пациентов
SELECT FLOOR((TO_DAYS(NOW()) - TO_DAYS(birthday_at))/365.25) AS age FROM patients_info;

#Персонал по офисам
SELECT s.id , s.lastname, o.name 
FROM staff s
	JOIN offices o ON s.office_id = o.id 
ORDER BY s.office_id ;

# Стоимость услуг специалистов
SELECT s.name , spl.price , p.name, d.name
FROM services_price_list spl
	JOIN services s ON s.id = spl.service_id 
	JOIN posts p ON p.id = s.post_id 
	JOIN departments d ON d.id = p.department_id  ;  

#Все отзывы (оценки) пациента № 3
SELECT s.id, firstname, lastname, m.mark 
	FROM staff s 
		JOIN reviews r ON s.id = r.staff_id  
		JOIN marks m ON r.mark_id = m.id 
	WHERE r.patient_id = 3;


# ПРЕДСТАВЛЕНИЯ
# Персонал по отделениям
CREATE OR REPLACE VIEW staff_offices AS
	SELECT 
#		d.name AS `department`, 
		s.lastname , 
		s.firstname  , 
		p.id AS `post_id` ,
		p.name AS `post`,
		o.name AS `office`
	FROM medical_staff_info msi
		JOIN posts p ON msi.post_id = p.id 
		JOIN departments d ON msi.department_id = d.id 
		JOIN staff s ON msi.staff_id = s.id
		JOIN offices o ON s.office_id = o.id 
	ORDER BY s.lastname ;

SELECT * FROM staff_departments LIMIT 5;

# Рейтинг персонала по оценкам пациентов (средний балл) и количество отзывов
CREATE OR REPLACE VIEW staff_rating AS
	SELECT 
		r.staff_id, 
		s.lastname, 
		COUNT(r.staff_id) AS 'n_reviews', 
		AVG(r.mark_id) as 'avg_mark'
	FROM reviews r 
		JOIN staff s ON r.staff_id = s.id 
	GROUP BY r.staff_id
	ORDER BY 'avg_mark' DESC;

SELECT * FROM staff_rating LIMIT 5;

#ПРОЦЕДУРА/ТРИГГЕР
# Процедура для вывода сообщения пациенту списка офисов, в которых предоставляется заказанная услуга
# (хотела сделать посложнее - на случай если офиса нет, но не срабатывало)
# И триггер для срабатывания этой функции после вставки новой записи в таблицу patients_services
# (триггер почему-то выдает ошибку, что у него после insert'a больше 1 строки, - но срабатывает , обновляет переменную )

DROP PROCEDURE IF EXISTS services_message;
DELIMITER //

CREATE PROCEDURE services_message (service_id BIGINT)
BEGIN
	SELECT DISTINCT office AS 'Выбранная услуга доступна в офисах:' FROM staff_offices WHERE post_id = (SELECT post_id FROM services s WHERE s.id = service_id);
END//

#Я ЗАКОММЕНТИРОВАЛА ТРИГГЕР, ЧТОБЫ СРАБОТАЛ Alt+X, а так он работает, если на ошибку нажать "пропустить" :)

/*DROP TRIGGER IF EXISTS new_service_offices//
CREATE TRIGGER new_service_offices AFTER INSERT ON patients_services
FOR EACH ROW
BEGIN
	SELECT NEW.service_id INTO @s_id FROM patients_services ps ;
END//


DELIMITER ;

INSERT INTO patients_services (patient_id, service_id) VALUES (1,4);

SELECT @s_id;

CALL services_message(@s_id);*/

DELIMITER ;

CALL services_message(4);
