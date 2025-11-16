# Spotify Advanced SQL Project 
Project Category: Advanced
[Click Here to get Dataset](https://github.com/sawan026/Spotify_sql_project/blob/main/cleaned_dataset.csv)

![Spotify Logo](https://github.com/najirh/najirh-Spotify-Data-Analysis-using-SQL/blob/main/spotify_logo.jpg)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
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
```
## Project Steps

### 1. Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 4. Querying the Data
After the data is inserted, various SQL queries can be written to explore and analyze the data. Queries are categorized into **easy**, **medium**, and **advanced** levels to help progressively develop SQL proficiency.

#### Easy Queries
- Simple data retrieval, filtering, and basic aggregations.
  
#### Medium Queries
- More complex queries involving grouping, aggregation functions, and joins.
  
#### Advanced Queries
- Nested subqueries, window functions, CTEs, and performance optimization.

### 5. Query Optimization
In advanced stages, the focus shifts to improving query performance. Some optimization strategies include:
- **Indexing**: Adding indexes on frequently queried columns.
- **Query Execution Plan**: Using `EXPLAIN ANALYZE` to review and refine query performance.
  
---
## Business Practice Questions

### ---EASY CATEOGARY 

### Q1. Retrieve the name of all tracks that have more than 1 billion stream 
```sql
select * from spotify 
where stream > 1000000000;
```
### Q2. Get the total number of comments for track where licensed = true 
```sql
select sum(comments ) as total_comments
from spotify 
where licensed = 'true'
```

### Q3. count the total number of tracks for each artist;
```sql
select
    artist,
	count(tracks) as total_songs
from spotify
group by artist;
```
### ----Medium level

### Q1. find the top 5 tracks with the heighest energy values 

```sql
select 
    track,
	max(energy)
from spotify
group by track
order by max(energy)
limit 5;
```
### Q2. list all the tracks along with their views and likes where official_video = true
```sql
select 
    track,
	sum(views) as total_views,
	sum(likes) as total_likes 
from spotify 
where official_video = 'true'
group by track
order by 2 desc
```
### Q3. for each album , calculate the total views of all associated tracks.
```sql
select
    album ,
	track,
	sum(views )
from spotify
group by album, track
order by sum(views) desc
```

### Q4. retrieve the track names that have been streamed on spotify more than youtube
```sql
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
```
### --- Hard level 

### Q1. find the top 3 most_viewed tracks from each artist using window function
```sql
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
```
### Q2. write a query to find tracks where the liveness score is above the average .
```sql
select
    track,
	artist,
	liveness
from spotify 
where liveness > (select avg(liveness)from spotify)
```
### Q3. use a with clause to calculate the difference between the highest and lowest energy values for tracks in each album
```sql
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
```
