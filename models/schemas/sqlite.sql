CREATE TABLE boards (
  route TEXT PRIMARY KEY NOT NULL,
  name  TEXT NOT NULL
);

CREATE TABLE yarns (
  number  INTEGER PRIMARY KEY NOT NULL,
  board TEXT NOT NULL,
  updated DATETIME NOT NULL,
  subject TEXT,
  locked  BOOLEAN,
  FOREIGN KEY(board) REFERENCES board(route)
);

CREATE TABLE posts (
  number INTEGER PRIMARY KEY AUTOINCREMENT,
  yarn INT NOT NULL,
  name TEXT NOT NULL,
  time DATETIME NOT NULL,
  body TEXT,
  spoiler BOOLEAN,
  FOREIGN KEY(yarn) REFERENCES yarn(number)
);
