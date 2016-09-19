#!/usr/bin/env python3

import sys
import sqlite3

def create_db(dbfilename):
    db=sqlite3.connect(dbfilename)
    cursor=db.cursor()
    cursor.execute( '''CREATE TABLE jobs
                       (id INTEGER PRIMARY KEY AUTOINCREMENT,
                       client TEXT,
                       added DATE,
                       cmdfile TEXT) ;''' )
    cursor.close()

if __name__ == "__main__":
    create_db(sys.argv[1])