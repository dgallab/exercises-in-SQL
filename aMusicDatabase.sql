-- Daniel Gallab
-- hw3
-- implement queries using database from hw2

use dgallab_DB;
-- database name
drop table if exists musicGenre;
-- dropping tables allow us to run this query multiple times, with possibly different values
drop table if exists songs;
-- we want to drop songs before albums because it contains a foreign key to albums
drop table if exists albums;

drop table if exists groupMembers;

create table musicGenre
(musicGroupName varchar(40) NOT NULL,
genreName varchar(20) NOT NULL,
primary key (musicGroupName, genreName))
Engine = InnoDB;

create table albums
(albumID int NOT NULL,
albumName varchar(30) NOT NULL,
musicGroup varchar(40) NOT NULL,
recordingLabel varchar(20) NOT NULL,
yearRecorded smallint NOT NULL,
primary key (albumID))
Engine = InnoDB;

create table songs
(songName varchar(30) NOT NULL,
albumID int NOT NULL,
albumName varchar(40) NOT NULL,
primary key (songName, albumID),
foreign key (albumID) references albums(albumID))
Engine = InnoDB;


create table groupMembers
(groupMemberName varchar(18),
musicGroupName varchar(40) NOT NULL,
yearEntered smallint NOT NULL,
yearLeft smallint,
primary key (groupMemberName, musicGroupName,yearEntered))
Engine = InnoDB;

insert into groupMembers
values('Daniel', 'Dr. Bowers and the Geeks from 321', 2017, NULL),
('Trevor', 'Dr. Bowers and the Geeks from 321', 2016, NULL),
('Tyler the Creator', 'Odd Future', 2007, NULL);

insert into musicGenre
values('Dr. Bowers and the Geeks from 321', 'synth-pop'),
('Odd Future', 'hip-hop'),
('Crystal Castles','synth-pop');

insert into albums
values(1, 'FlowerBower', 'Dr. Bowers and the Geeks from 321', 'Def-Jam', 2017),
(2, 'How to Get an A', 'Dr. Bowers and the Geeks from 321','Def-Jam', 2017);

insert into songs
values('Procrastinating on Wednesday', 1, 'FlowerBower'),
('Procrastinating on Monday', 1, 'FlowerBower'),
('A+', 2, 'How to Get an A');


-- queries

-- q1 Find the album titles created by a particular music group.
-- music group is Dr. Bowers and the Geeks from 321
SELECT albumName
FROM albums
WHERE musicGroup = 'Dr. Bowers and the Geeks from 321';

-- q2 Find the music groups that play a particular genre of music.
-- genere is synth-pop
SELECT musicGroupName
FROM musicGenre
WHERE genreName = 'synth-pop';

-- q3 Find the names of people that were members of a particular music group in a particular year.
-- musicgroupname is Dr. Bowers and the Geeks from 321, year is 2017
SELECT groupMemberName
FROM groupMembers
WHERE musicGroupName = 'Dr. Bowers and the Geeks from 321' AND  yearEntered<=2017
AND (yearLeft is NULL OR yearLeft>=2017);

-- q4 Find the names of people that were members of a particular music group within a
-- music group is Dr. Bowers and the Geeks from 321, particular range of years
-- range is 2000-3000, should produce same results as previous given the instances
SELECT groupMemberName
FROM groupMembers
WHERE musicGroupName = 'Dr. Bowers and the Geeks from 321' AND yearEntered<=3000
AND (yearLeft>=2000 or yearLeft is NULL);


-- q5 Find all of the song titles for a particular album
-- album is FLowerBower which has the album ID of 1
-- in this case, we can just use the name, but conceptually, a table about songs and albums
-- can contain albums with identical names but different artists. Same for songs.

SELECT songName
FROM songs
WHERE albumID = 1;

-- q6 Find all of the song titles that were on albums of groups
-- that had a particular group member at the time the album was recorded.
-- group member is Daniel. Note that if Daniel were part of multiple bands, then possibly more
-- songs would be returned
SELECT songName
FROM songs s,  groupMembers m, albums a
WHERE   s.albumName=a.albumName  AND m.groupMemberName = 'Daniel' AND a.yearRecorded >= m.yearEntered
AND (a.yearRecorded <= m.yearLeft OR m.yearLeft is NULL);

-- q7 Find album titles released under a particular record label
-- within a given range of years
-- record label is Def-Jam, range is 2015 to 2019
SELECT albumName
FROM albums
WHERE  recordingLabel = 'Def-Jam' AND yearRecorded BETWEEN 2015 AND 2019;

