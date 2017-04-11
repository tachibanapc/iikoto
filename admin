#!/usr/bin/env bash

EXIT_SUCCESS=0
EXIT_NOARGS=1

if [ $# -lt 1 ]
then
	echo "No arguments given"
	exit $EXIT_NOARGS
else
	case $1 in
	install)
		$(sqlite3 imageboard.db < models/schemas/sqlite.sql)
		sql=$(cat <<-'END_HEREDOC'
			insert into boards(route, name) values("test", "Testing");
		END_HEREDOC)
		$(sqlite3 imageboard.db "$sql")
		;;

	delete)
		sql=$(cat <<-'END_HEREDOC'
			drop table if exists boards;
			drop table if exists yarns;
			drop table if exists posts;
			drop table if exists images;
		END_HEREDOC)
		$(sqlite3 imageboard.db "$sql")
		;;
	esac
	exit $EXIT_SUCCESS
fi
