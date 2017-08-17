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

DATA_DIR=$DF_TOOLS/alluser_20170817
INFILE=$DATA_DIR/alluser_20170817.tsv
OUTFILE_PREFIX='alluser_20170817'
DB='sc_alluser_20170817'

dataArray=(
    '0 ユーザーメールアドレス 1 ユーザー氏名'
    '0 ユーザーメールアドレス 2 ユーザー所属'
    '0 ユーザーメールアドレス 6 ユーザー国籍'
)

for i in "${dataArray[@]}"; do
    data=(${i[@]})
    KC=${data[0]}
    KN=${data[1]}
    VC=${data[2]}
    VN=${data[3]}
    get_tsv4.pl -kc ${KC} -kn ${KN} -vc ${VC} -vn ${VN} < ${INFILE} > ${DATA_DIR}/${OUTFILE_PREFIX}__${KN}__${VN}.txt
    dc_load.my -db ${DB} -f TSV4 -op kv < ${DATA_DIR}/${OUTFILE_PREFIX}__${KN}__${VN}.txt
done

