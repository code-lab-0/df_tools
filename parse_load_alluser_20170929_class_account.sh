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
OUTFILE=$DATA_DIR/alluser_20170929_class_account.tsv

parse_alluser.pl --account < $INFILE > $OUTFILE

OUTFILE_PREFIX='alluser_20170929_class_account'
DB='sc_alluser_20170929'

dataArray=(
    '0 class_account 1 メールアドレス'
    '1 メールアドレス 0 class_account'
    '0 class_account 2 ユーザー種別'
    '0 class_account 3 アカウント名'
    '0 class_account 4 アカウント開始日'
    '0 class_account 5 アカウント停止日'
    '0 class_account 6 利用目的'
    '0 class_account 7 グループID'
)


for i in "${dataArray[@]}"; do
    data=(${i[@]})
    KC=${data[0]}
    KN=${data[1]}
    VC=${data[2]}
    VN=${data[3]}
    get_tsv4.pl -kc ${KC} -kn ${KN} -vc ${VC} -vn ${VN} < ${OUTFILE} > ${DATA_DIR}/${OUTFILE_PREFIX}__${KN}__${VN}.txt
    dc_load.my -db ${DB} -f TSV4 -op kv < ${DATA_DIR}/${OUTFILE_PREFIX}__${KN}__${VN}.txt
done

