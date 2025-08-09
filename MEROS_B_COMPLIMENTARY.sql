DROP TABLE IF EXISTS SMARTPHONE_VENDOR CASCADE;
DROP TABLE IF EXISTS OPERATE CASCADE;
DROP TABLE IF EXISTS OPERATING_SYSTEM CASCADE;
--DROP TABLE IF EXISTS RATING CASCADE;
DROP TABLE IF EXISTS APP CASCADE;
DROP TABLE IF EXISTS CATEGORY CASCADE;
DROP TABLE IF EXISTS DEVELOPER CASCADE;
DROP TABLE IF EXISTS USE CASCADE;
DROP TYPE IF EXISTS RATING cascade;
DROP TYPE IF EXISTS Affiliation cascade;
DROP TYPE IF EXISTS Address_ cascade;
DROP TYPE IF EXISTS MESSAGETYPE cascade;
DROP TYPE IF EXISTS STYPE CASCADE;
DROP TYPE IF EXISTS CommentorType CASCADE;
DROP TABLE IF EXISTS AppBlog CASCADE;
 
 --DIMIOURGIA ENUM GIA ESWTERIKOUS KAI EKSWTERIKOUS DEVS
CREATE TYPE Affiliation AS ENUM('E','I');
CREATE TYPE Address_ AS (--XRISI COMPOSITE DATA TYPE GIA DIMIOURGIA GNWRISMATWN MESA SE GNWRISMA ADDRESS
	Line VARCHAR(90),
	Zip_Code VARCHAR(90)
);

CREATE TABLE DEVELOPER (
Dev_ID TEXT NOT NULL,
Name TEXT NOT NULL UNIQUE,
email VARCHAR (50)[][] NOT NULL UNIQUE, --DIMIOURGOUME MULTI-VALUED METAVLITI ME XRISI MULTI DIMENSIONAL ARRAY 
Address Address_ NOT NULL,
Affiliation_ Affiliation NOT NULL,
PRIMARY KEY(Dev_ID)
);
 
-- Table: CATEGORY
CREATE TABLE CATEGORY (
Name TEXT NOT NULL, 
Description TEXT, 
Age_Group TEXT NOT NULL,
PRIMARY KEY(Name)
);
 
 
--NEO DATA TYPE GIA YPOTHETIKO VLOG
CREATE TYPE MESSAGETYPE AS(
	PERIEXOMENO VARCHAR(4000),
	HMEROMHNIA DATE,
	TAGS TEXT[]
);


--DIMIOURGIA DATA TYPE RATING GIA ANARTISI AKSIOLOGISEWN
CREATE TYPE RATING AS(
	Rating_ID INT,
	App_ID TEXT,
	App_Rating_Value TEXT,
	App_Rating_Date TEXT
);

-- Table: APP
CREATE TABLE APP (
App_ID TEXT NOT NULL,
Name TEXT NOT NULL,
Description TEXT NOT NULL,
Date TEXT NOT NULL,
Version TEXT NOT NULL,
Blog_Name TEXT NOT NULL UNIQUE, --ONOMA GIA KATHE BLOG TOU KATHE APP
Installations INTEGER,
Category_Name TEXT NOT NULL,
Developer_ID TEXT NOT NULL,
Ratings RATING[] NOT NULL,
PRIMARY KEY (App_ID),
FOREIGN KEY (Category_Name) REFERENCES CATEGORY(Name),
FOREIGN KEY (Developer_ID) REFERENCES DEVELOPER(Dev_ID)
);

CREATE TYPE CommentorType AS ENUM ('DEVELOPER','VENDOR'); --DIMIOURGIA ENUM GIA PERIORISMO EPILOGWN KAI DIAXWRISI TYPOY POY KANEI ANARTISI
CREATE TABLE AppBlog ( --YPOTITHEMENO BLOG GIA TIS ANAGKES TIS ASKISIS
	App_ID TEXT NOT NULL,
	Blog_Name TEXT NOT NULL,
	Commentor_ID TEXT NOT NULL, --ID GIA VENDOR H DEVELOPER
	CommentorType CommentorType NOT NULL,
	Content MESSAGETYPE [] NOT NULL,
	PRIMARY KEY(App_ID,Blog_Name,Commentor_ID), --DEN VAZW Commentor_ID PRIMARY KEY DIOTI TO BLOG EKSARTATAI MONO APO TO APP
	FOREIGN KEY (App_ID) REFERENCES APP(App_ID),
	FOREIGN KEY (Blog_Name) REFERENCES APP(Blog_Name)
);
 
--DIMIOURGIA ENUM GIA APOFUGI TOU CHECK
CREATE TYPE STYPE AS ENUM('Open Source','Closed Source');
-- Table: OPERATING_SYSTEM
CREATE TABLE OPERATING_SYSTEM (
Name TEXT NOT NULL,
Source_Model STYPE NOT NULL,
Website TEXT,
PRIMARY KEY(Name)
);
 
-- Table: OPERATE
CREATE TABLE OPERATE (
App_ID TEXT NOT NULL,
Operating_System_Name TEXT NOT NULL,
PRIMARY KEY (App_ID,Operating_System_Name),
FOREIGN KEY (App_ID) REFERENCES APP(App_ID),
FOREIGN KEY (Operating_System_Name) REFERENCES OPERATING_SYSTEM(Name)
);
 
-- Table: SMARTPHONE_VENDOR
 
CREATE TABLE SMARTPHONE_VENDOR (
Name TEXT NOT NULL, 
Location TEXT NOT NULL, 
Founder TEXT,
PRIMARY KEY(Name)
);
 
-- Table: USE
 
CREATE TABLE USE(
Smartphone_Vendor_Name VARCHAR NOT NULL,
Operating_System_Name  VARCHAR NOT NULL,
PRIMARY KEY(Smartphone_Vendor_Name,Operating_System_Name),
FOREIGN KEY(Smartphone_Vendor_Name) REFERENCES SMARTPHONE_VENDOR(Name),
FOREIGN KEY(Operating_System_Name) REFERENCES OPERATING_SYSTEM(Name)
);




--EISAGWGES

INSERT INTO DEVELOPER VALUES
('DEV1','DIMITRIS PSOMAS','{{business,tp4507@edu.hmu.gr},{personal,dpsomas98@gmail.com}}',ROW('MAXIS KRITIS 1','74100'),'I'),
('DEV2','DIMOSTHENIS AKOUMIANAKIS','{{business,da@hmu.gr},{personal,da2@hmu.gr}}',ROW('GIANNI ATHITAKI 1','71410'),'I'),
('DEV3','KOSTANTINOS VLAHAVAS','{{business,vlaxavas@hmu.gr},{personal,vlaxavas2@hmu.gr}}',ROW('GIANNI ATHITAKI 1',''),'E'),
('DEV4','MARK ZUCKERBURG','{{business,zuck@facebook.com},{personal,zuck2@facebook.com}}',ROW('CALIFORNIA 1','14410'),'E');

INSERT INTO CATEGORY VALUES
('COMMUNICATION','All kinds of communications','Over 16 years old'),
('GAMES','All kinds of games - mostly kids-friendly','Over 8 years old'),
('SCIENTIFIC','All kinds of science','All'),
('HEALTH','All kinds of health-related','All'),
('FLAMETHROWERS','Only made from the Boring Company','Over 18 years old'); --MEGALOS FAN TOU ELON
 
INSERT INTO APP VALUES
('APP1','MESSENGER','Facebook/s messenger','2012-05-10','10.0','Messenger News',10000000,'COMMUNICATION','DEV4',
ARRAY[
	  ROW(1,'APP1','4','2024-03-10')::RATING,
	  ROW(5,'APP1','3','2020-08-29')::RATING
 ]
),
('APP2','ECLASS','Open Eclass','2003-05-10','10.0','Eclass News',50000,'SCIENTIFIC','DEV2',
 ARRAY[
	 ROW(2,'APP2','5','2024-05-15')::RATING,
	 ROW(6,'APP2','4','2024-06-18')::RATING
 ]),
('APP3','GYMBUDDY','Gym friend spotter','2024-05-10','1.0','GymBuddys Blog',10,'HEALTH','DEV1',
 ARRAY[
	 ROW(3,'APP3','5','2023-04-22')::RATING
 ]),
('APP4','EASYCLEAN','Robot vacuum app','2023-05-10','2.0','EasyClean News',100,'HEALTH','DEV3',
 ARRAY[
	 ROW(4,'APP4','2','2022-07-15')::RATING
 ]);

INSERT INTO OPERATING_SYSTEM VALUES
('Windows','Closed Source','https://www.microsoft.com/el-gr/windows'),
('Android','Open Source','https://www.android.com'),
('iOS','Closed Source','https://www.apple.com');
 
INSERT INTO OPERATE VALUES
('APP1','Android'),
('APP2','Windows'),
('APP3','Android'),
('APP4','iOS');
 
INSERT INTO SMARTPHONE_VENDOR VALUES
('Samsung','Taegu, Korea','Lee Byung-Chull'),
('Apple','California','Steve Jobs'),
('SMARTEC','Athens,Greece,','Dimitris Christakos'),
('InfoQuest','Athens,Greece','Dimitris Eforakopoulos');

INSERT INTO AppBlog VALUES
('APP1', 'Messenger News', 'Samsung', 'VENDOR',
 ARRAY[
	 ROW('We consider buying you!', '2013-05-15', ARRAY['Sales', 'Stocks'])::MESSAGETYPE,
 	 ROW('Are you still interested?','2016-04-15',ARRAY['Sales','Stocks'])::MESSAGETYPE]),
('APP2', 'Eclass News', 'Samsung', 'VENDOR',
 ARRAY[
	 ROW('We consider buying you!', '2013-05-15', ARRAY['Sales', 'Stocks'])::MESSAGETYPE,
	 ROW('Your project is failing!', '2021-05-15', ARRAY['Sales', 'Development'])::MESSAGETYPE]),
('APP3', 'GymBuddys Blog', 'Samsung', 'VENDOR', 
 ARRAY[
	 ROW('Excellent idea!', '2024-05-30', ARRAY['Sales', 'Development'])::MESSAGETYPE,
	 ROW('Are you interested in funding?', '2024-05-31', ARRAY['Funding', 'Stocks'])::MESSAGETYPE]),
('APP3', 'GymBuddys Blog', 'SMARTEC', 'VENDOR', 
 ARRAY[
	 ROW('Εξαιρετικη δουλεια!', '2024-05-29', ARRAY['Development', 'Stocks'])::MESSAGETYPE,
	 ROW('Δωσε εμφαση στο UI γρηγορα!', '2024-05-31', ARRAY['Development', 'Deadline'])::MESSAGETYPE]),
('APP2', 'Eclass News', 'InfoQuest', 'VENDOR', 
 ARRAY[
	 ROW('Μπορειτε και καλυτερα!', '2016-05-15', ARRAY['Development', 'Stocks'])::MESSAGETYPE]),
('APP1', 'Eclass News', 'DEV4', 'DEVELOPER', 
 ARRAY[
	 ROW('No thanks!', '2016-04-16', ARRAY['Sales', 'Stocks'])::MESSAGETYPE]),
('APP1', 'Eclass News', 'DEV1', 'DEVELOPER', 
 ARRAY[
	 ROW('Ευχαριστώ, εχω δουλεια ακομα!', '2024-05-30', ARRAY['Development', 'Stocks'])::MESSAGETYPE]);
	 
	 	 



--SQL ERWTIMATA
--1
SELECT Dev_ID,Name,DEVELOPER.email[2:2]
FROM DEVELOPER
WHERE DEVELOPER.email @>'{{personal}}'; --VASI DIAFANEIWN

SELECT DEVELOPER.email
FROM DEVELOPER
WHERE DEVELOPER.email@>'{{personal}}';

--2
SELECT *
FROM DEVELOPER
WHERE Affiliation_='E' and (DEVELOPER.Address).Line LIKE '%CA%';/*EXISTS (
	Select *
	FROM unnest(DEVELOPER.Address) as r
	WHERE r.Zip_Code LIKE '%CA%');*/
	
--3
SELECT *
FROM DEVELOPER
WHERE (DEVELOPER.Address).Zip_Code IS NULL OR (DEVELOPER.Address).Zip_Code='';

--4
SELECT Commentor_ID, Content.PERIEXOMENO
FROM AppBlog, UNNEST(Content) AS Content
WHERE 'Development' = ANY (Content.TAGS);

--5
SELECT COUNT (*)
FROM AppBlog, UNNEST(Content) AS Content
WHERE 'Development' = ANY (Content.TAGS);

--6
SELECT Commentor_ID, Content.PERIEXOMENO
FROM AppBlog, UNNEST(Content) AS Content
WHERE ARRAY['Sales'] <@ Content.TAGS;

--7
SELECT Commentor_ID, Blog_Name, Content.PERIEXOMENO
FROM AppBlog, UNNEST(Content) AS Content
WHERE NOT ARRAY['Stocks'] <@ Content.TAGS;



	

