CREATE DATABASE fjord_sinatra;

\connect fjord_sinatra

CREATE TABLE memos (
    id     int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    title  text NOT NULL,
    detail text
);
