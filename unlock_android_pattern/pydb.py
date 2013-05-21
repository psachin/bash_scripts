#!/usr/bin/python
import sqlite3

DB_PATH="/root/nande/system/com.android.providers.settings/databases/settings.db"
#DB_PATH="/home/sachin/temp/settings.db"

conn = sqlite3.connect(DB_PATH)
c = conn.cursor()

c.execute("UPDATE secure SET value=0 WHERE name='lock_pattern_autolock'")
c.execute("UPDATE secure SET value=0 WHERE name='lockscreen.lockedoutpermanently'")

#c.execute("UPDATE tbl1 set two=0 WHERE one='hiya'")
#c.execute("INSERT INTO tbl1 VALUES('hiaaya',12);")
conn.commit()
conn.close()
