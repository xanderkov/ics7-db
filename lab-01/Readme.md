# Установка postgres

1. docker pull postgres 
2. docker run -d \t--name some-postgres \ -p 5432:5432
\\n\t-e POSTGRES_PASSWORD=postgres 
\\n\t-e PGDATA=/var/lib/postgresql/data/pgdata 
\\n\t-v /home/alexander/Documents/bmstu/postgress-data:/var/lib/postgresql/data \\n\tpostgres
3. docker exec -it some-postgres
4. psql -U postgres
5. sudo apt install pgadmin4-desktop
6. psql -h localhost -p 5432 -U postgre
7. в pgadmin4 подключится name: localhost, net: 0.0.0.0