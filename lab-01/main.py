import psycopg2
import os

POSGRES_PWD = os.getenv('POSGRES_PASSWORD')

conn = psycopg2.connect(database = "mental_hospital", user="postgres", password=POSGRES_PWD, host="localhost", port="5432")
print("Databes opened")

cursor = conn.cursor()

cursor.execute(open("script.sql", "r").read())

conn.commit()
conn.close()

print("ALL DONE")