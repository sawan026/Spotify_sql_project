--Advance sql project --spotify
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
    likes FLOAT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

SELECT * FROM SPOTIFY;

--EDA
SELECT COUNT(*) FROM SPOTIFY;

SELECT COUNT(DISTINCT ARTIST) FROM SPOTIFY;

SELECT COUNT (DISTINCT ALBUM) FROM SPOTIFY;

SELECT DISTINCT ALBUM_TYPE FROM SPOTIFY;

SELECT MAX(DURATION_MIN) FROM SPOTIFY;

SELECT MIN(DURATION_MIN) FROM SPOTIFY;

SELECT * FROM SPOTIFY WHERE DURATION_MIN = 0;

DELETE FROM SPOTIFY
WHERE DURATION_MIN = 0;

SELECT  DISTINCT CHANNEL FROM SPOTIFY;

---DATA ANALYSIS  - EASY CATEOGARY 

Q1. Retrieve the name of all tracks that have more than 1 billion stream 

select * from spotify 
where stream > 1000000000;

Q2. Get the total number of comments for track where licensed = true 

select sum(comments ) as total_comments
from spotify 
where licensed = 'true'

Q3. count the total number of tracks for each artist;

select
    artist,
	count(tracks) as total_songs
from spotify
group by artist;

----Medium level

Q1. find the top 5 tracks with the heighest energy values 


select 
    track,
	max(energy)
from spotify
group by track
order by max(energy)
limit 5;

Q2. list all the tracks along with their views and likes where official_video = true
select * from spotify

select 
    track,
	sum(views) as total_views,
	sum(likes) as total_likes 
from spotify 
where official_video = 'true'
group by track
order by 2 desc

Q3. for each album , calculate the total views of all associated tracks.

select
    album ,
	track,
	sum(views )
from spotify
group by album, track
order by sum(views) desc

Q4. retrieve the track names that have been streamed on spotify more than youtube

select * from 
(select 
    track,
	coalesce(sum(case when most_played_on = 'youtube' then stream end),0) as streamed_on_youtube ,
	coalesce(sum(case when most_played_on = 'spotify' then stream end ),0) as streamed_on_spotify
from spotify
group by track
) as t1
where 
    streamed_on_spotify > streamed_on_youtube
and 
    streamed_on_youtube <> 0

--- Hard level 

Q1. find the top 3 most_viewed tracks from each artist using window function

with ranking_artist
as
(select
    artist,
	track,
	sum(views)as total_views,
	dense_rank()over(partition by artist order by sum(views) desc ) as rank
from spotify
group by 1,2 
order by 1 , 3 desc
) 
select * from ranking_artist 
where rank <= 3

Q2. write a query to find tracks where the liveness score is above the average .

select
    track,
	artist,
	liveness
from spotify 
where liveness > (select avg(liveness)from spotify)

Q3. use a with clause to calculate the difference between the highest and lowest energy values for tracks in each album

with cte
as
(select 
    album,
	max(energy) as highest_energy,
	min(energy )as lowest_energy
from spotify 
group by 1
)
select 
    album,
	highest_energy - lowest_energy as energy_diff
from cte








