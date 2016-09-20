CREATE TABLE boards (
  route TEXT PRIMARY KEY NOT NULL,
  name TEXT NOT NULL
);

CREATE TABLE yarns (
  number INTEGER PRIMARY KEY NOT NULL,
  board TEXT NOT NULL,
  updated DATETIME NOT NULL,
  subject TEXT,
  locked BOOLEAN,
  FOREIGN KEY(board) REFERENCES boards(route)
);

CREATE TABLE posts (
  number INTEGER PRIMARY KEY AUTOINCREMENT,
  yarn INT NOT NULL,
  name TEXT NOT NULL,
  time DATETIME NOT NULL,
  body TEXT,
  spoiler BOOLEAN,
  file INTEGER,
  FOREIGN KEY(file) REFERENCES files(number)
);

CREATE TABLE files (
  number INTEGER PRIMARY KEY,
  extension TEXT NOT NULL,
  name TEXT NOT NULL,
  width INTEGER NOT NULL,
  height INTEGER NOT NULL,
  t_width INTEGER NOT NULL,
  t_height INTEGER NOT NULL
);
