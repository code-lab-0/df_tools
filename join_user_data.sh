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

dc_list.my -db $DB -ds メールアドレス -p 氏名 | \
dc_join.my -db $DB -ds メールアドレス -p 所属 | \
dc_join.my -db $DB -ds メールアドレス -p 郵便番号 | \
dc_join.my -db $DB -ds メールアドレス -p 住所 | \
dc_join.my -db $DB -ds メールアドレス -p 電話番号 | \
dc_join.my -db $DB -ds メールアドレス -p 国籍 | \
dc_join.my -db $DB -ds メールアドレス -p class_account -c | \
sort > ${PREFIX}__メールアドレス__氏名__所属__郵便番号__住所__電話番号__国籍__class_account.tsv
