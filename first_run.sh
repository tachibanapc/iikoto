#!/usr/bin/env bash
sqlite3 imageboard.db < models/schemas/sqlite.sql
sqlite3 imageboard.db <<'EOF'
  insert into boards(route, name) values("test", "Testing");
EOF
