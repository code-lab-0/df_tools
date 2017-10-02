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

DATA_DIR=$DF_TOOLS/data/alluser_20170929
INFILE=$DATA_DIR/alluser_20170929.tsv
OUTFILE=$DATA_DIR/alluser_20170929_personal.tsv

parse_alluser.pl --personal < $INFILE > $OUTFILE

