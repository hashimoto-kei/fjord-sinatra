CREATE TABLE memos (
    id     int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    title  text NOT NULL,
    detail text NOT NULL
);
