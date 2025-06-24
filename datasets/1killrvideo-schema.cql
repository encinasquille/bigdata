// Sample schema for Apache Cassandra

// IF EXISTS added for Cassandra 2.1
// CQL 3.1.0
DROP KEYSPACE IF EXISTS killrvideo;
// CREATE KEYSPACE killrvideo WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 3 };
CREATE KEYSPACE killrvideo WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

//Create the schema
use killrvideo;

// User credentials, keyed by email address so we can authenticate
// Seperated from user in case auth is external (Google, Facebook, etc...)
CREATE TABLE user_by_email (
   email text,
   password text,
   userid uuid,
   PRIMARY KEY (email)
);

// Basic entity table for a user
// UUID for userid to link to auth system
CREATE TABLE users (
   userid uuid,
   firstname text,
   lastname text,
   email text,
   created_date timestamp,
   PRIMARY KEY (userid)
);


// Entity table that will store many videos for a unique user
// Videos by id
CREATE TABLE videos (
    videoid uuid,
    userid uuid,
    name text,
    description text,
    location text,
    location_type int,
    preview_image_location text,
    tags set<text>,
    added_date timestamp,
    PRIMARY KEY (videoid)
);


// One-to-many from the user point of view
// Also know as a lookup table
CREATE TABLE videos_by_user (
   userid uuid,
   added_date timestamp,
   videoid uuid,
   name text,
   preview_image_location text,
   PRIMARY KEY (userid, added_date, videoid)
) WITH CLUSTERING ORDER BY (added_date DESC, videoid ASC);

// Track latest videos, grouped by day (if we ever develop a bad hotspot from the daily grouping here, we could mitigate by
// splitting the row using an arbitrary group number, making the partition key (yyyymmdd, group_number))
CREATE TABLE latest_videos (
   yyyymmdd text,
   added_date timestamp,
   videoid uuid,
   name text,
   preview_image_location text,
   PRIMARY KEY (yyyymmdd, added_date, videoid)
) WITH CLUSTERING ORDER BY (added_date DESC, videoid ASC);

// Counter table
CREATE TABLE video_rating (
   videoid uuid,
   rating_counter counter,
   rating_total counter,
   PRIMARY KEY (videoid)
);

    
// Video ratings by user (to try and mitigate voting multiple times)
CREATE TABLE video_ratings_by_user (
   videoid uuid,
   userid uuid,
   rating int,
   PRIMARY KEY (videoid, userid)
);



// Index for tag keywords
CREATE TABLE IF NOT EXISTS videos_by_tag (
    tag text,
    videoid uuid,
    added_date timestamp, 
    name text,
    preview_image_location text,
    tagged_date timestamp,
    PRIMARY KEY (tag, videoid)
);

// Comments as a many-to-many
// Looking from the video side to many users
CREATE TABLE comments_by_video (
   videoid uuid,
   commentid timeuuid,
   userid uuid,
   comment text,
   PRIMARY KEY (videoid, commentid)
) WITH CLUSTERING ORDER BY (commentid DESC);

// looking from the user side to many videos
CREATE TABLE comments_by_user (
   userid uuid,
   commentid timeuuid,
   videoid uuid,
   comment text,
   PRIMARY KEY (userid, commentid)
) WITH CLUSTERING ORDER BY (commentid DESC);
