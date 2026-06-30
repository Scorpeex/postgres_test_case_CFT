#! /bin/bash
Ранее я никогда не писал на баше и не трогал psql.
Это пример самого простого и нестабильного кода. Если у меня останется время, то я добавлю сюда проверок на каждый шаг. 
Например версия psql может не соответствовать на вашей машине, или бд/кластер с таким именем уже существует. Так что код
можно улучшить.

sudo pg_createcluster 16 test_bench_cft --start

sudo -u postgres createdb -p 5433 pg_bench_db
sudo -u postgres pgbench -i -s 2 -p 5433 pg_bench_db
sudo -u postgres pgbench -c 10 -T 30 -p 5433 pg_bench_db > result_scale_2.txt

sudo -u postgres dropdb -p 5433 pg_bench_db

sudo -u postgres createdb -p 5433 pg_bench_db
sudo -u postgres pgbench -i -s 20 -p 5433 pg_bench_db
sudo -u postgres pgbench -c 10 -T 30 -p 5433 pg_bench_db > result_scale_20.txt

grep "tps =" result_scale_2.txt result_scale_20.txt

sudo pg_dropcluster 16 test_bench --stop

