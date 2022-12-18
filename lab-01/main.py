import psycopg2
import os

POSGRES_PWD = os.getenv('POSGRES_PASSWORD')

def create_databases(cursor):
    cursor.execute(open("script.sql", "r").read())


def copy_to_database(cursor):
    if not(os.path.exists("/home/alexander/Documents/bmstu/postgress-data/pgdata/csv_tables/tables")):
        os.system("sudo cp -r ./tables/ /home/alexander/Documents/bmstu/postgress-data/pgdata/csv_tables/")
    cursor.execute(open("copy_from_csv.sql", "r").read())
    
    
def main():
    
    conn = psycopg2.connect(database = "mental_hospital", user="root", password="postgres", host="localhost", port="5432")
    print("Databes opened")

    cursor = conn.cursor()

    create_databases(cursor)

    conn.commit()
    conn.close()

    print("ALL DONE")


if __name__ == "__main__":
    main()