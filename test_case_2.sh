#!/bin/bash

VERSION="16"
CLUSTER_NAME="test_2_cft"
DB_NAME="random_values"

sudo -u postgres pg_createcluster $VERSION $CLUSTER_NAME --start

PORT=$(pg_lsclusters | grep "$VERSION  $CLUSTER_NAME" | awk '{print $3}')

sudo -u postgres createdb -p $PORT $DB_NAME

sudo -u postgres psql -p $PORT -d $DB_NAME -c "
CREATE TABLE random_values (
    id SERIAL PRIMARY KEY,
    value1 INTEGER
);
INSERT INTO random_values (value1)
SELECT floor(random() * 1000 + 1) FROM generate_series(1, 1500);"

sudo -u postgres psql -p $PORT -d $DB_NAME -c "
WITH average AS (SELECT AVG(value1) as avg_val FROM random_values)
    SELECT avg_val AS Average_value,
        (SELECT COUNT(value1)
            FROM random_values
            WHERE value1 > avg_val/2) AS Count_rows
FROM average;"

sudo pg_dropcluster $VERSION $CLUSTER_NAME --stop


