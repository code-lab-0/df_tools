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

DB="sc_alluser_20170817"
PREFIX="sc_alluser_20170817"

dc_list.my -db $DB -ds class_account -p メールアドレス | \
dc_join.my -db $DB -ds class_account -p ユーザー種別 | \
dc_join.my -db $DB -ds class_account -p アカウント名 | \
dc_join.my -db $DB -ds class_account -p アカウント開始日 | \
dc_join.my -db $DB -ds class_account -p アカウント停止日 | \
sort > ${PREFIX}__class_account__メールアドレス__ユーザー種別__アカウント名__アカウント開始日__アカウント停止日.tsv
