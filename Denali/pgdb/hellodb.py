import postgresql.driver as pg_driver

__author__ = 'srini'
host='denalidev.c7arb5e6jrs8.us-west-2.rds.amazonaws.com'
user='denalidev'
password='kW8VJAcjYmPBA2'
port=5432
database='tutor'

db=pg_driver.connect( user=user, password=password, host=host, port=port, database=database)
print(db.version)
print(db.version_info)
db.close()



