-- Daniel Gallab
-- Taylor Jones

-- medicinal marijuana database

use sys;

drop table if exists Patient;
drop table if exists Substrains;
drop table if exists Breeder;
drop table if exists Illnesses;
drop table if exists Strains;
drop table if exists Psychotic_constituents;

drop function if exists treatability;
-- each substrain has lab tested chemical information
CREATE TABLE Psychotic_constituents(
substrain_id decimal(4,2),
thc_percentage decimal (4,2),
cbd_percentage decimal (4,2),
PRIMARY KEY (substrain_id)
) engine=InnoDB;

-- this tables contains instances of all strains. All substrains of the same strain have the same parents
-- and flowering time
CREATE TABLE Strains(
strain_id int,
strain_name varchar(20),
parent1_id int,
parent2_id int,
flowering_time int,
PRIMARY KEY (strain_id)
) engine=InnoDB;

-- a breeder produces substrains in either a greenhouse,natural, or hybrid environment
CREATE TABLE Breeder(
breeder_id int,
breeder_name varchar(35),
growing_environment varchar(1),
state varchar(2),
PRIMARY KEY (breeder_id)
) engine=InnoDB;


-- Many substrains can exist for a single strain
-- depending on quantity of breeders who breed that strain

-- the substrain is defined by the combination of the breeder and the strain, so we use
-- a decimal- the integer portion refers to a breeder, the decimal portion refers to the strain. 
CREATE TABLE Substrains(
substrain_id decimal(4,2),
breeder_id int,
strain_id int,
PRIMARY KEY (substrain_id),
FOREIGN KEY (strain_id) REFERENCES Strains (strain_id),
FOREIGN KEY  (breeder_id) REFERENCES Breeder (breeder_id)
) engine=InnoDB;



-- each illness has an id, name, and a treatibility scorem which takes into account
-- how effective marijuana was in general at treating the illness.

CREATE TABLE Illnesses(
illness_id int,
illness varchar(30),
PRIMARY KEY (illness_id)
) engine=InnoDB;

-- a patient with an illness and a specified strain for treatment.
-- and before/after scores rating intensity of symptoms, 1-10
-- 10 being most severe

CREATE TABLE Patient(
patient_id int,
illness_id int,
before_ tinyint,
after_ tinyint,
substrain_id decimal(4,2),
PRIMARY KEY (patient_id, illness_id),
FOREIGN KEY (substrain_id) REFERENCES Substrains (substrain_id),
FOREIGN KEY (illness_id) REFERENCES Illnesses (illness_id)
) engine=InnoDB;




INSERT INTO Strains VALUES
(1,"Durban Poison", NULL, NULL, 7.3),
(2,"Afghani", NULL, NULL, 7.1),
(3, "Thai", NULL, NULL, 10.2),
(4, "Panama Red", NULL, NULL, 11.3),
(5, "Black Durban", 1, 6, 7.2),
(6, "Black Russian", 7, 340, 7.6),
(7, "Domina", 2, 8, 8.4),
(8, "Northern Lights", 2, 3, 8.1),
(9, "Hash Plant", 2, 8, 9.0),
(10, "Girl Scout Cookies", 1, 11, 8.1),
(11, "OG Kush", 12, 13, 10.3),
(12, "Hindu Kush", NULL, NULL, 10.1),
(13, "Chemdawg", 3, 14, 8.0),
(14, "Nepalese", NULL, NULL, 11.4),
(15, "SS", 16, 400, 10.0),
(16, "Peyote Purple", 11, 17, 8.4),
(17, "Bubba Kush", 1, 11, 8.9),
(18, "Death Star", 19, 20, 9.4),
(19, "Sensi Star", NULL, NULL, 8.6),
(20, "Sour Diesel", 13, 21, 8.5),
(21, "Super Skunk", 1, 22, 7.7),
(22, "Skunk 1", 1, 23, 10.8),
(23, "Colombian Gold", NULL, NULL, 9.0),
(24, "Acapulco Gold",  NULL, NULL, 10.4),
(25, "GD Purple", 26, 27, 9.0),
(26, "Purple Urkle", 28, NULL, 7.5),
(27, "Big Bud", 22, 8, 7.8), 
(28, "Mendocino Purps", NULL, NULL, 11.9),
(29, "M. Silvertip", 25, 30, 10.5),
(30, "SS Haze", 22, 31, 12.2),
(31, "Haze", 3, NULL, 12.0),
(32, "True OG", 3, 13, 11.0);

INSERT INTO Breeder VALUES
(1,"GLW","g","WA"),
(2,"Artizen","g", "WA"),
(3,"Ladera Farms","n", "WA"),
(4,"Frosted Flowers", "h", "CA"),
(5,"Vimutti","h","CA"),
(6,"IC Collective", "g", "CA"),
(7,"Apthoecary Gen.","n","CA"),
(8,"AV3 Gen.","n", "CO"),
(9,"Montana Cannabis", "h", "MT"),    
(10,"Amadeus","g", "MT"),
(11,"Honu", "n", "WA"),
(12,"Blue Roots", "g", "WA"),
(13,"Remedy", "g", "MT"),
(14,"Treedom", "g", "WA"); 

INSERT INTO Substrains VALUES 
(9.18,9,18),
(11.24,11,24),
(11.15,11,15),
(8.11,8,11),
(12.24,12,24),
(7.29,7,29),
(6.26,6,26),
(1.06,1,6),
(3.13,3,13),
(11.3,11,30),
(13.15,13,15),
(5.04,5,4),
(6.25,6,25),
(9.26,9,26),
(6.16,6,16),
(6.27,6,27),
(8.31,8,31),
(14.09,14,9),
(1.05,1,5),
(12.28,12,28),
(9.22,9,22),
(2.14,2,14),
(14.1,14,10),
(1.03,1,3),
(12.26,12,26),
(13.3,13,30),
(14.13,14,13),
(7.02,7,2),
(7.09,7,9),
(1.12,1,12),
(11.18,11,18),
(5.12,5,12),
(8.04,8,4),
(4.23,4,23),
(11.21,11,21),
(3.28,3,28),
(9.27,9,27),
(2.18,2,18),
(2.06,2,6),
(10.07,10,7),
(2.19,2,19),
(8.24,8,24),
(13.13,13,13),
(11.25,11,25),
(14.27,14,27),
(2.29,2,28),
(12.11,12,11),
(13.07,13,7),
(3.26,3,26),
(1.2,1,20),
(5.19,5,19),
(12.3,12,30),
(1.11,1,11),
(14.07,14,7);

INSERT INTO Illnesses VALUES
(1, "anixety"),
(2, "depression"),
(3, "nausea"),
(4, "OCD"),
(5, "schizophrenia"),
(6, "Tourette's Syndrome"),
(7, "HIV"),
(8, "PTSD");

-- 1 is no symptoms 
INSERT INTO Patient VALUES
(1,1,10, 5, 7.29),
(2,4,6,2, 11.21),
(1,2,10, 4, 9.18),
(3,6,3, 1, 6.16),
(3,7,6,4, 13.15),
(1,4,10,3, 9.26);


INSERT INTO Psychotic_constituents VALUES
(9.18,24.7,.04),
(11.24,21.8,.01),
(11.15,23.0,1.0),
(8.11,19.0,.09),
(12.24,25.6,.21),
(7.29,22.3,.02),
(6.26,21.9,.8),
(1.06,14.2,1.4),
(3.13,26.5,.21),
(11.3,24.5,.1),
(13.15,23.6,.1),
(5.04,27.8,.4),
(6.25,22.9,25),
(9.26,17.9,.3),
(6.16,19.8,.1),
(6.27,21.3,.21),
(8.31,18.5,.31),
(14.09,26.3,.21),
(1.05,22.4,.5),
(12.28,16.3,.3),
(9.22,19.4,.67),
(2.14,21.6,.39),
(14.1,25.5,.01),
(1.03,27.7,.32),
(12.26,24.2,.46),
(13.3,21.8,.20),
(14.13,21,.13),
(7.02,17.2,.1),
(7.09,22.1,.1),
(1.12,28.1,.0),
(11.18,21.1,.0),
(5.12,23.1,.06),
(8.04,30.4,1.0),
(4.23,17.3,2.12),
(11.21,19.31,.21),
(3.28,18.9,.34),
(9.27,16.5,1.00),
(2.18,1.4,14.6),
(2.06,22.8,2.44),
(10.07,24.2,.71),
(2.19,26.3,.23),
(8.24,18.0,1.13),
(13.13,19.4,2.6),
(11.25,23.21,.25),
(14.27,21.1,2.3),
(2.29,15.6,1.11),
(12.11,27.1,.71),
(13.07,23.2,1.1),
(3.26,27.4,.06),
(1.2,18.0,.2),
(5.19,23.1,.5),
(12.3,26.1,.23),
(1.11,22.4,.99),
(14.07,26.7,.7);


-- this query finds the strain which has the most variations
-- this number also tells us how many breeders are currently producing the strain
SELECT strain_name, COUNT(*)
FROM Strains NATURAL JOIN Substrains
GROUP BY strain_id
ORDER BY COUNT(*) DESC;


-- finds the strain crossed the most
SELECT s1.strain_name, s1.strain_id, COUNT(*)
FROM Strains s1, Strains s2
WHERE s1.strain_id = s2.parent1_id OR s1.strain_id = s2.parent2_id
GROUP BY s1.strain_id
ORDER BY COUNT(*) DESC;


-- finds a treatability score for an illness, which is the difference of every before value with the after value
-- corresponding with the patient rating,
-- a higher treatability score implies that marijuana has more consistently been successful treating the illness
-- CREATE FUNCTION treatability(illness_input varchar(20))
	-- RETURNS INT
	-- RETURN ((SELECT SUM(before_) FROM  Patient NATURAL JOIN Illnesses
				-- WHERE illness = illness_input)-(SELECT SUM(after_) FROM  Patient NATURAL JOIN Illnesses
				-- WHERE illness = illness_input));
				
				
-- SELECT treatability(illness)
-- FROM Patient NATURAL JOIN Illnesses;