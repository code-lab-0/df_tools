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

INFILE=$DF_TOOLS/data/alluser-20170509-307e30663099-2.txt
OUTFILE_PREFIX='alluser-20170509'
DB='testdb'

dataArray=(
    '1 ユーザーメールアドレス 2 ユーザー氏名'
    '1 ユーザーメールアドレス 3 ユーザー所属'
    '3 ユーザー所属 5 機関名'
    '5 機関名 6 国内外'
    '5 機関名 7 機関区分'
    '1 ユーザーメールアドレス 11 ユーザー国籍'
    '1 ユーザーメールアドレス 12 一般ユーザーID'
    '1 ユーザーメールアドレス 15 大規模ユーザーID'
    '1 ユーザーメールアドレス 18 MIGAPユーザーID'
    '1 ユーザーメールアドレス 21 PIPELINEユーザーID'
    '1 ユーザーメールアドレス 24 業務ユーザーID'
    '1 ユーザーメールアドレス 27 SEユーザーID'
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

