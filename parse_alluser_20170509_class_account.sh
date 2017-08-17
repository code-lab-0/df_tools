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

INFILE=$DF_TOOLS/data/alluser-20170509_class_account.txt
OUTFILE_PREFIX='alluser-20170509_class_account'
DB='testdb'

dataArray=(
    '0 class_account 1 ユーザーメールアドレス'
    '1 ユーザーメールアドレス 0 class_account'
    '0 class_account 2 ユーザー種別'
    '0 class_account 3 アカウント名'
    '0 class_account 4 アカウント開始日'
    '0 class_account 5 アカウント停止日'
)

for i in "${dataArray[@]}"; do
    data=(${i[@]})
    KC=${data[0]}
    KN=${data[1]}
    VC=${data[2]}
    VN=${data[3]}
    get_tsv4.pl -kc ${KC} -kn ${KN} -vc ${VC} -vn ${VN} < ${INFILE} > ${OUTFILE_PREFIX}__${KN}__${VN}.txt
    dc_load.my -db ${DB} -f TSV4 -op kv < ${OUTFILE_PREFIX}__${KN}__${VN}.txt
done

