/*База данных для онлайн-клиники.
 * 
 * Содержит данные о структуре отделений, адресах офисов, оказываемых медицинских услугах,
 * персонале (в каких офисах работают и какие услуги входят в компетенцию) и пациентах.*/

DROP DATABASE IF EXISTS online_clinic;
CREATE DATABASE online_clinic;
USE online_clinic;

#1'Медицинские отделения клиники'
DROP TABLE IF EXISTS departments;
CREATE TABLE departments(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) COMMENT 'Название отделения',
	email VARCHAR(100) UNIQUE,
	phone BIGINT UNSIGNED UNIQUE
	);

INSERT INTO `departments` 
VALUES 
(1, 'Отделение лабораторной диагностики', 'pri@hospital.ru', '1234567890'),
(2, 'Отделение функциональной диагностики', 'aro@hospital.ru', '1234567891'),
(3, 'Терапевтическое отделение','therapy@hospital.ru', '1234567892'),
(4, 'Хирургическое отделение', 'sergery_1@hospital.ru', '1234567893'),
(5, 'ЛОР отделение', 'sergery_2@hospital.ru', '1234567894'),
(6, 'Неврологическое отделение', 'neurology_1@hospital.ru', '1234567895'),
(7, 'Офтальмологическое', 'neurology_2@hospital.ru', '1234567896'),
(8, 'Эндокринологическое отделение', 'pathan@hospital.ru', '1234567897'),
(9, 'Акушерско-гинекологическое отделение', 'pharmacy@hospital.ru', '1234567898'),
(100, 'Немедицинский персонал', 'hospatal@hospital.ru', '1234567811');

#2'Офисы клиники'
DROP TABLE IF EXISTS offices;
CREATE TABLE offices(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) COMMENT 'Название офиса',
	address VARCHAR(100) UNIQUE,
	email VARCHAR(100) UNIQUE,
	phone BIGINT UNSIGNED UNIQUE
	);

INSERT INTO offices
VALUES
(1, 'Офис на Пятницкой', 'Пятницкая ул., д.1', 'pyatn@clinic.cl','1111111111'),
(2, 'Офис на Тверской', 'Тверская ул., д.2', 'tver@clinic.cl','2222222222'),
(3, 'Офис на Мясницкой', 'Мясницкая ул., д.3', 'myasn@clinic.cl','3333333333');

#3 Должности
DROP TABLE IF EXISTS posts;
CREATE TABLE posts(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) COMMENT 'Название должности',
	department_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (department_id) REFERENCES departments(id)
	);

INSERT INTO posts (name, department_id)
VALUES
('главврач', 1),
('врач-невролог (специалист)', 6),
('врач-невролог (КМН)', 6),
('медсестра процедурная', 1),
('врач-терапевт (специалист)', 3),
('врач-терапевт (КМН)', 3),
('врач-терапевт (профессор)',3),
('электрик',100),
('уборщица',100),
('инженер',100);

#4 Услуги
DROP TABLE IF EXISTS services;
CREATE TABLE services(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) COMMENT 'Название услуги',
	post_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (post_id) REFERENCES posts(id)
);

INSERT INTO services (name, post_id)
VALUES
('Анализ крови общий', 4),
('Анализ мочи общий', 1),
('Анализ крови биохимический', 4),
('Консультация врача-невролога (специалист)',2),
('Консультация врача-невролога (КМН)',3),
('Консультация врача-терапевта (специалист)',5),
('Консультация врача-терапевта (КМН)',6),
('Консультация врача-терапевта (профессор)',7),
('Анализ крови бактерологический',4),
('Вакцинация от гриппа',4);

#5 Сотрудники
DROP TABLE IF EXISTS staff;
CREATE TABLE staff(
	id SERIAL PRIMARY KEY,
	lastname VARCHAR(100),
	firstname VARCHAR(100),
	middlename VARCHAR(100),
	department_id BIGINT UNSIGNED NOT NULL DEFAULT '100',
	office_id BIGINT UNSIGNED NOT NULL DEFAULT '1',
	FOREIGN KEY (department_id) REFERENCES departments(id),
	FOREIGN KEY (office_id) REFERENCES offices(id),
	INDEX idx_users_username(firstname, lastname )
) COMMENT 'сотрудники';

INSERT INTO `staff` 
VALUES 
(1,'Иванов','Иван','Иванович','3', 3),
(2,'Петров','Петр','Петрович','100', 2),
(3,'Сидоров','Сидор','Сидорович','6',1),
(4,'Васильев','Василий','Васильеьвич','4',2),
(5,'Аннова','Анна','Акимовна','5',3),
(6,'Ольгина','Ольга','Олеговна','6',3),
(7,'Александрова','Александра','Александровна', '100',2),
(8,'Кутаисова','Таисия','Тимофеевна','6',1),
(9,'Эпилептов','Эдуард','Эльдарович','6',2),
(10,'Зиновьев','Зиновий','Зенонович','2',1);

#6 Информация о медицинских работниках
DROP TABLE IF EXISTS medical_staff_info;
CREATE TABLE medical_staff_info(
	staff_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	department_id BIGINT UNSIGNED NOT NULL,
	post_id bigint(20) unsigned NOT NULL,
	is_head_of_department BIT,
	gender CHAR(1),
	hired_at DATETIME DEFAULT NOW(),
	birthday_at DATETIME,
	email VARCHAR(100) UNIQUE,
	phone BIGINT UNSIGNED UNIQUE,
	address VARCHAR(100),
	
	FOREIGN KEY (department_id) REFERENCES departments(id),
	FOREIGN KEY (post_id) REFERENCES posts(id),
	FOREIGN KEY (staff_id) REFERENCES staff(id)
) COMMENT 'информация о медицинских работниках';

INSERT INTO `medical_staff_info` 
VALUES 
(1,3,1,0,'м','2022-06-27','1980-03-24', 'iiii@hospital.ru','9876543212','Олдж, Авыф ул. , д. 1, кв. 1'),
(3,6,2,0,'м', '2022-06-27','1981-04-25','ssss@hospital.ru','9876543213','Олдж, Авыф ул. , д. 2, кв. 2'),
(4,4,2,0,'м','2022-06-27','1970-05-26','vvvv@hospital.ru','9876543214','Олдж, Авыф ул. , д. 3, кв. 3'),
(5,5,4,0,'ж','2022-06-27','1982-06-27','aaaa@hospital.ru','9876543215','Олдж, Авыф ул. , д. 4, кв. 4'),
(6,6,5,0,'ж','2022-06-27','1983-07-28','oooo@hospital.ru','9876543216','Олдж, Авыф ул. , д. 5, кв. 5'),
(8,6,4,0,'ж','2022-06-27','1984-08-29','kkkk@hospital.ru','9876543217','Олдж, Авыф ул. , д. 6, кв. 6'),
(9,6,2,1,'м','2022-06-27','1985-09-30','eeee@hospital.ru','9876543218','Олдж, Авыф ул. , д. 7, кв. 7'),
(10,2,2,1,'м','2022-06-27','1986-10-31','zzzz@hospital.ru','9876543219','Олдж, Авыф ул. , д. 8, кв. 8');

#7 Информация о немедицинских работниках
DROP TABLE IF EXISTS non_medical_staff_info;
CREATE TABLE non_medical_staff_info(
	staff_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	post_id bigint(20) unsigned NOT NULL,
	gender CHAR(1),
	hired_at DATETIME DEFAULT NOW(),
	birthday_at DATETIME,
	email VARCHAR(100) UNIQUE,
	phone BIGINT UNSIGNED UNIQUE,
	address VARCHAR(100),
	FOREIGN KEY (post_id) REFERENCES posts(id), 
	FOREIGN KEY (staff_id) REFERENCES staff(id) 
) COMMENT 'информация о немедицинских работниках';

INSERT INTO `non_medical_staff_info` 
VALUES 
(2,8,'м','2022-06-27','1980-07-24','electro@hospital.ru','9876544212','Олдж, Авыф ул. , д. 11, кв. 11'),
(7,9,'ж','2022-06-27','1981-08-25','cleano@hospital.ru','9876543313','Олдж, Авыф ул. , д. 22, кв. 22');

# 8 Фото сотрудников
DROP TABLE IF EXISTS staff_photos;
CREATE TABLE staff_photos(
	staff_id BIGINT UNSIGNED NOT NULL,
	photo VARCHAR(20),

	FOREIGN KEY (staff_id) REFERENCES staff(id)
) COMMENT 'фотографии сотрудников';

INSERT INTO `staff_photos` VALUES 
(1,'img1'),
(2,'img2'),
(3,'img3'),
(4,'img4'),
(5,'img5'),
(6,'img6'),
(7,'img7'),
(8,'img8'),
(9,'img9'),
(10,'img10');

# 9 Пациенты
DROP TABLE IF EXISTS patients;
CREATE TABLE patients(
	id SERIAL PRIMARY KEY,
	lastname VARCHAR(100),
	firstname VARCHAR(100),
	middlename VARCHAR(100),
	first_request DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
	) COMMENT 'Список пациентов';

INSERT INTO `patients` 
VALUES 
(1,'O\'Kon','Stuart','est','2003-01-19 23:00:15','1984-04-10 12:15:29'),
(2,'Connelly','Keaton','enim','1983-08-24 21:25:35','2013-04-22 10:30:30'),
(3,'Halvorson','Estella','minus','2005-10-18 01:45:26','1980-08-23 19:03:37'),
(4,'Sipes','Mitchel','officiis','1993-03-22 09:27:40','2010-10-14 15:59:04'),
(5,'Williamson','Ottilie','optio','1988-01-24 07:53:15','1991-08-08 20:01:57'),
(6,'Kling','Waino','fuga','1981-03-25 14:03:21','1987-09-13 14:06:15'),
(7,'Hoeger','Keanu','dignissimos','1984-12-28 15:29:20','1987-01-18 22:58:33'),
(8,'Abernathy','Jewell','repellat','1985-05-29 15:50:27','1973-08-28 12:04:08'),
(9,'Connelly','Kenyatta','dolorem','1972-02-21 11:54:54','2001-01-17 11:21:31'),
(10,'Harber','Hubert','ipsam','2002-09-12 05:15:19','2013-12-05 19:14:59');

# 10 Данные пациентов
DROP TABLE IF EXISTS patients_info;
CREATE TABLE patients_info(
	patient_id BIGINT UNSIGNED NOT NULL,
	gender CHAR(1),
	birthday_at DATETIME,
	medical_insurance_policy BIGINT UNSIGNED UNIQUE,
	passport_number BIGINT UNSIGNED UNIQUE,
#	icd10_code VARCHAR(100) COMMENT 'код по международной классификации болезней МКБ-10',
	email VARCHAR(100) UNIQUE,
	phone BIGINT UNSIGNED UNIQUE,
	address VARCHAR(100),

	FOREIGN KEY (patient_id) REFERENCES patients(id)
) COMMENT 'информация о пациентах';

INSERT INTO `patients_info` VALUES 
(1,'m','2013-06-11 00:25:21',770006456496,098776,'luella.medhurst@example.net',1,'914 Camryn Isle\nLake Antwonmouth, MA 53925-1851'),
(2,'m','2019-01-14 20:37:21',770087439097,2073,'nitzsche.america@example.org',448,'38315 Schumm Forks\nEast Derrickborough, ND 68190'),
(3,'f','2017-04-10 21:36:41',770020842209,66770105,'vhammes@example.net',0,'2362 Mathias Pike\nNew Nicholastown, AZ 36611-8705'),
(4,'f','2010-06-15 17:44:38',770060994996,626324231,'ngerhold@example.net',767260,'7517 Parker Cliff\nNorth Elbertview, AZ 35733-0294'),
(5,'m','1974-07-12 10:42:54',770021237925,3687563,'lgusikowski.frances@example.org',327497,'42819 Madelynn Ferry\nNew Koreyberg, AL 71200-5991'),
(6,'m','1976-07-20 10:42:54',770021237444,3687553,'gusikowski.frances@example.org',327498,'42819 Madelynn Ferry\nNew Koreyberg, AL 71200-5991'),
(7,'m','1970-04-03 12:36:46',770022115209,49973528,'schinner.rupert@example.net',6670,'1912 Ruthe Motorway Suite 491\nBlickfurt, MN 02888'),
(8,'f','1988-07-24 23:36:09',770059507420,9520,'tskiles@example.org',87843,'259 Jeremy Centers\nHaydenmouth, KS 03126'),
(9,'f','1974-07-19 10:42:54',770044437925,36879903,'kgusikowski.frances@example.org',327499,'42819 Madelynn Ferry\nNew Koreyberg, AL 71200-5991'),
(10,'m','2018-09-27 15:19:51',770013095904,765116883,'bconsidine@example.org',76672,'5924 Jacobson Bridge Apt. 186\nLeonardoland, MI 17586');

# 11 Услуги прайслист
DROP TABLE IF EXISTS services_price_list;
CREATE TABLE services_price_list(
	service_id BIGINT UNSIGNED NOT NULL,
	price FLOAT COMMENT 'Цена услуги',
	FOREIGN KEY (service_id) REFERENCES services(id)
);

INSERT INTO services_price_list VALUES
(1, 1000),
(2, 1000),
(3, 2000),
(4, 2000),
(5, 3000),
(6, 3000),
(7, 2000),
(8, 2000),
(9, 4000),
(10, 1000);

# 12 Услуги, за которыми обращались пациенты
DROP TABLE IF EXISTS patients_services;
CREATE TABLE patients_services(
	id SERIAL PRIMARY KEY,
	patient_id BIGINT UNSIGNED NOT NULL,
 	service_id BIGINT UNSIGNED NOT NULL,
	ordered_at DATETIME DEFAULT NOW(),
	
	FOREIGN KEY (patient_id) REFERENCES patients(id),
	FOREIGN KEY (service_id) REFERENCES services(id)
);

INSERT INTO patients_services (patient_id, service_id) VALUES
(1, 1),
(3, 2),
(4, 1),
(3, 2),
(4, 3),
(5, 3),
(6, 3),
(3, 3),
(8, 4),
(9, 8);

# Ранг оценок
DROP TABLE IF EXISTS marks;
CREATE TABLE marks(
	id SERIAL PRIMARY KEY,
 	mark ENUM ('excellent', 'good', 'middle', 'bad', 'the worst')
 );

INSERT INTO marks VALUES
(1,'the worst'),
(2,'bad'),
(3,'middle'),
(4,'good'),
(5,'excellent');

# 14 Отзывы о персонале
DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews(
	patient_id BIGINT UNSIGNED NOT NULL,
 	staff_id BIGINT UNSIGNED,
 	mark_id BIGINT UNSIGNED,
	review_text TEXT,
	
	FOREIGN KEY (patient_id) REFERENCES patients(id),
	FOREIGN KEY (staff_id) REFERENCES staff(id),
	FOREIGN KEY (mark_id) REFERENCES marks(id)
);

INSERT INTO reviews VALUES
(1,2,'3','Lorem ipsum'),
(2,4,'5','dolor'),
(3,4,'4','Lorem ipsum dolor'),
(4,5,'4','Lorem ipsum dolor Lorem ipsum dolor Lorem ipsum dolor'),
(5,4,'2',''),
(6,2,'1',''),
(8,6,'3',''),
(9,2,'5',''),
(1,2,'3','Lorem'),
(3,6,'4','ipsum');

