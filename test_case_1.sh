#! /bin/bash

# Это пример самого простого и нестабильного кода. Если у меня останется время, то я добавлю сюда проверок на каждый шаг. 
# Например версия psql может не соответствовать на вашей машине, или бд/кластер с таким именем уже существует. Так что код
# можно улучшить.

#sudo pg_createcluster 16 test_bench_cft --start

#sudo -u postgres createdb -p 5433 pg_bench_db
#sudo -u postgres pgbench -i -s 2 -p 5433 pg_bench_db
#sudo -u postgres pgbench -c 10 -T 30 -p 5433 pg_bench_db > result_scale_2.txt

#sudo -u postgres dropdb -p 5433 pg_bench_db

#sudo -u postgres createdb -p 5433 pg_bench_db
#sudo -u postgres pgbench -i -s 20 -p 5433 pg_bench_db
#sudo -u postgres pgbench -c 10 -T 30 -p 5433 pg_bench_db > result_scale_20.txt

#grep "tps =" result_scale_2.txt result_scale_20.txt

#sudo pg_dropcluster 16 test_bench --stop

# Вынес повторяющиеся значения в переменные, и повторяющиеся строки в функцию.
# Можно больше, но мне не хватает времени разобраться.

#!/bin/bash


CLUSTER_VERSION=16      
# Нагуглил такой вариант, вроде работает, но сам бы я не сообразил. 
# CLUSTER_VERSION=$(psql --version | grep -oE '[0-9]+' | head -1)
#PORT=5433 

CLUSTER_NAME="test_bench_cluster"
DB_NAME="pg_bench_db"
FILE1="result_scale_2.txt"
FILE2="result_scale_20.txt"

sudo pg_createcluster $CLUSTER_VERSION $CLUSTER_NAME --start

PORT=$(pg_lsclusters | grep "$CLUSTER_VERSION  $CLUSTER_NAME" | awk '{print $3}')

run_bench() {
    local scale=$1
    local outfile=$2    
    
    sudo -u postgres createdb -p $PORT $DB_NAME
    sudo -u postgres pgbench -i -s $scale -p $PORT $DB_NAME
    sudo -u postgres pgbench -c 10 -T 30 -p $PORT $DB_NAME > $outfile    
    sudo -u postgres dropdb -p $PORT $DB_NAME
}

run_bench 2 $FILE1
run_bench 20 $FILE2

echo "Сравнение результатов (tps):"
echo "Scale 2:"
grep "tps =" $FILE1 | tail -n 1
echo "Scale 20:"
grep "tps =" $FILE2 | tail -n 1

sudo pg_dropcluster $CLUSTER_VERSION $CLUSTER_NAME --stop