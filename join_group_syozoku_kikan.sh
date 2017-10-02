#!/bin/bash

DF_TOOLS=$HOME/works/df_tools
PATH=$PATH:$DF_TOOLS
DATACELL_MYSQL_JAR=$DF_TOOLS/DataCell-mysql-1.0.0-jar-with-dependencies.jar

dc_join.my() {
    java -cp $DATACELL_MYSQL_JAR net.ogalab.datacell.mysql.app.DcJoinMySQL "$@"
}

dc_list.my() {
    java -cp $DATACELL_MYSQL_JAR net.ogalab.datacell.mysql.app.DcListMySQL "$@"
}

dc_load.my() {
    java -cp $DATACELL_MYSQL_JAR net.ogalab.datacell.mysql.app.DcLoadMySQL "$@"
}

dc_delete.my() {
    java -cp $DATACELL_MYSQL_JAR net.ogalab.datacell.mysql.app.DcDeleteTablesMySQL "$@"
}

dc_list.my -db sc_alluser_20170929 -ds グループID -p 責任者所属 | \
dc_join.my -db sc_alluser_20170905 -ds 所属 -p 機関名 -t 1 | \
cut -f2,3 |
sort -t$'\t' -k2 | uniq > alluser_20170929_group__所属__機関名.tsv
