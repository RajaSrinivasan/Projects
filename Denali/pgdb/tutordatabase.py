__author__ = 'gsriniv1'
import postgresql.driver as pg_driver


def ConnecttoDB():
    host='denalidev.c7arb5e6jrs8.us-west-2.rds.amazonaws.com'
    user='denalidev'
    password='kW8VJAcjYmPBA2'
    port=5432
    database='tutor'
    db=pg_driver.connect( user=user, password=password, host=host, port=port, database=database)
    return db

