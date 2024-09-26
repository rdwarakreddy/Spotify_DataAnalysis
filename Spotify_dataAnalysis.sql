-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-- EDA--
select count(*) from spotify;

select count(distinct artist) from spotify;--2074

select count(distinct album) from spotify;--11854

select distinct album_type from spotify; --Album, Compilation, Single

select max(duration_min) from spotify;--77.9343
select min(duration_min) from spotify;--0

select * from spotify
where duration_min = 0;

delete from spotify
where duration_min = 0;

select * from spotify
where duration_min = 0;


-------------------------------------
-- Data Analysis--- Easy Category---
-------------------------------------


-- 1. Retrieve the names of all tracks that have more than 1 billion streams
select * from spotify
where stream>1000000000;

-- 2.List all albums along with their respective artists
select album,artist
from spotify;

-- 3. Get the total number of comments for tracks where licensed = TRUE.
select count(comments) from spotify
where licensed = 'true';

-- 4. Find all tracks that belong to the album type single
select track from spotify
where album_type = 'single';

-- 5. Count the total number of tracks by each artist.
select artist,count(track) from spotify
group by artist;


-------------------------------------
-- Data Analysis--- Medium Category--
-------------------------------------


-- 6. Calculate the average danceability of tracks in each album
select album,avg(danceability) from spotify
group by album
order by 2 desc;

-- 7.Find the top 5 tracks with the highest energy values.
select track,max(energy) from spotify
group by track
order by max(energy) desc
limit 5;

-- 8.List all tracks along with their views and likes where official_video = TRUE.
select 
	track,
	sum(views) as total_views,
	sum(likes) as total_likes 
from spotify
where official_video = 'true'
group by track

-- 9. For each album, calculate the total views of all associated tracks
select
	album,
	track,
	sum(views) as total_views
from spotify
group by album,track;

-- 10.Retrieve the track names that have been streamed on Spotify more than YouTube
select * from 
(SELECT 
	track, 
	coalesce(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream ELSE 0 END),0) AS spotify_streams,
	coalesce(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream ELSE 0 END),0) AS youtube_streams
FROM spotify
GROUP BY track) as t1
where  spotify_streams>youtube_streams and (spotify_streams!=0 and youtube_streams!=0)


-------------------------------------
-- Data Analysis--- Hard Category--
-------------------------------------


-- 11.Find the top 3 most-viewed tracks for each artist using window functions.
with cte as (
select 
	artist,
	track,
	sum(views) as total_views,
	dense_rank() over(partition by artist order by sum(views) desc) as d_rank
from spotify
group by artist,track
)

select * from cte
where d_rank<=3;

-- 12.Write a query to find tracks where the liveness score is above the average.
select
	track,liveness
from spotify
where liveness > (select avg(liveness) as average from spotify);

-- 13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
select * from spotify;
with cte as (
select
	album,
	Max(energy) as max_energy,
	Min(energy) as min_energy
from spotify
group by 1
)
select 
	album,
	(max_energy - min_energy) as diff_energy
from cte

-- 14.Find tracks where the energy-to-liveness ratio is greater than 1.2.
select	
	track
from spotify
where energy_liveness > 1.2;


SELECT 
    track,
    views,
    likes,
    SUM(likes) OVER (ORDER BY views) AS cumulative_likes
FROM spotify
ORDER BY views desc;












