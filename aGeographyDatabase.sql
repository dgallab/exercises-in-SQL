-- Daniel Gallab
-- hw5
-- implement new queries and a view relation and detail
-- their purpose on the database created
-- in hw 4

use dgallab_DB;

-- order of dropping tables/creating tables is important when considering foreign keys
drop table if exists Border;

drop table if exists City;

drop table if exists Province;

drop table if exists Country;

drop view if exists assoc_borders;

create table Country
(code varchar(2),
country_name varchar(30) NOT NULL,
gdp int NOT NULL,
inflation double(5,2) NOT NULL,
primary key (code))
Engine = InnoDB;


create table Province
(province_name varchar(30),
country_code varchar(2),
area_ bigint NOT NULL,
primary key(province_name, country_code),
foreign key (country_code) references Country(code))
Engine = InnoDB;


create table City
(city_name varchar(30),
province_name varchar(30),
country_code varchar(2),
population bigint NOT NULL,
primary key(city_name, province_name, country_code),
foreign key(province_name, country_code) references Province(province_name, country_code))
Engine = InnoDB;

-- this table has an interesting foriegn key where two attributes
-- individually are foreign keys to the same Country relation

-- keep in mind that because they are both foreign keys
-- countries that border no other countries (and therefore would
-- have a NULL value) cannot be inserted into this table
create table Border
(country1 varchar(5),
country2 varchar(5),
border_length int,
primary key(country1,country2),
foreign key(country1) references Country(code),
foreign key(country2) references Country(code))
Engine = InnoDB;

insert into Country
values('BD', 'Bangladesh', 1524, 5.57),
('MM','Mynamar', 1374, 6.26),
('RU','Russia', 10885, 3.3),
('NO','Norway', 73450, 1.3),
('FI','Finland', 42611,.7),
('CN','China', 8481, 1.8),
('VE', 'Venezuela', 8004, 741),
('CO', 'Colombia', 6216, 3.87),
('US', 'United States of America', 57467, 1.02),
('LA', 'Laos', 6115, -.3),
('EC', 'Ecuador', 11788, .28),
('TH', 'Thailand', 6265, .32),
('SE', 'Sweden', 51603, 2.1);

insert into Province
values('Amur', 'RU', 363700),
('Arkhangelsk', 'RU', 587400),
('Astrakhan', 'RU', 44100),
('Shandong', 'CN', 157100),
('Sichuan', 'CN', 485000),
('Tanintharyi', 'MM',43300),
('Leningrad', 'RU', 84500),
('Florida', 'US', 170000),
('Novosibirsk Oblast', 'RU', 178200),
('Primorsky Krai', 'RU', 165900);

insert into City
values('Blagoveshchensk', 'Amur','RU', 220000),
('Komsomolsk', 'Amur', 'RU', 260000),
('Jinan', 'Shandong', 'CN', 7100000),
('Chengdu', 'Sichuan', 'CN', 14000000),
('Dawei', 'Tanintharyi', 'MM', 125000),
('St. Petersburg', 'Leningrad', 'RU', 4910000),
('Novosibirsk', 'Novosibirsk Oblast', 'RU', 1600000),
('Vladivostok', 'Primorsky Krai', 'RU', 600000),
('St. Petersburg', 'Florida','US', 261000),
('Zeya','Amur','RU',25000),
('Tynda','Amur','RU',36000),
('Svobodny','Amur', 'RU', 60000);

insert into Border
values('RU','FI', 1313),
('RU','NO', 196),
('RU', 'CN', 4209),
('BD', 'MM', 271),
('CO', 'VE', 2219),
('CN', 'LA', 423),
('CO', 'EC', 586),
('TH', 'MM', 2107),
('SE', 'NO', 1630);

-- q1
-- finds the provinces and their respective areas
-- if there exists a city within that province
-- where the population exceeds 1000
SELECT DISTINCT p.province_name, p.area_
FROM Province p JOIN City c USING (province_name)
WHERE c.population > 1000;


-- q2
-- finds the city name and the code of the country where it is located
-- which shares its city name with another city of a different country
-- and the population of the first city exceeds the
-- population of the second city

-- in the case of multiple cities of the same name
-- the city with the least population would not be selected
SELECT c1.city_name, c1.country_code
FROM City c1 JOIN City c2 USING (city_name)
WHERE c1.country_code <> c2.country_code AND
c1.population > c2.population;

-- q3
-- finds the GDP, inflation, and total population of each country
-- in this hw, total population equals total population of cities
SELECT code, country_name, GDP, inflation, SUM(City.population) AS country_population
FROM Country JOIN City ON City.country_code = Country.code
GROUP BY code;

-- q4
-- find the name, area, and total population of provinces with a population
-- over 1,000,000 people. in this hw, the population of a province equals total population
-- of its cities
SELECT province_name, area_, SUM(City.population) AS province_population
FROM Province JOIN City USING (province_name)
GROUP BY province_name
HAVING SUM(City.population)>1000000;

-- q5
--  finds and orders countries by their size in terms of the number of cities they have
SELECT Country.code, Country.country_name, COUNT(City.country_code) AS number_of_cities
FROM City, Country
WHERE City.country_code = Country.code
GROUP BY Country.code
ORDER BY COUNT(City.country_code) ;

-- q6
-- orders countries by their total area.
-- In this hw, a country’s area is the sum
-- of its provinces’ areas (that have been entered).
SELECT Country.code, Country.country_name, SUM(Province.area_) as province_area
FROM Province, Country
WHERE Province.country_code = Country.code
GROUP BY Country.code
ORDER BY SUM(Province.area_) ;

-- q7
-- finds countries containing one or more provinces with at least 5 cities.
-- Your query should report the name of each country at most once.
SELECT  DISTINCT Country.code, Country.country_name
FROM Country, Province, City
WHERE Province.country_code = Country.code AND Province.country_code = City.country_code
GROUP BY City.province_name -- dont want to group by country, this means something different
HAVING COUNT (City.city_name)>4;

-- view1
-- associative version of Border relation
-- which allows q8 to work
CREATE VIEW assoc_borders AS
SELECT c1.country_name AS first_country, c2.country_name AS second_country, b.border_length
FROM Border b, Country c1, Country c2
WHERE (b.country1 = c1.code AND b.country2=c2.code)
OR (b.country2 = c1.code AND b.country1=c2.code);

-- q8
-- finds for each country, the average GDP and inflation of each of its
-- bordering countries. Your query should return the countries ordered by (from lowest to highest)
-- the average GDP followed by the average inflation of their bordering countries

-- groups sets based on their first_country value
-- then finds average gdp and inflation on the corresponding second_country values
SELECT distinct first_country, AVG(Country.gdp), AVG(Country.inflation)
FROM assoc_borders, Country
WHERE assoc_borders.second_country = Country.country_name
GROUP BY assoc_borders.first_country
ORDER BY AVG(Country.gdp), AVG(Country.inflation);
