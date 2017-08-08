#!/bin/bash
export DF_TOOLS=$HOME/works/df_tools
export PATH=$PATH:$DF_TOOLS
export DATACELL_MYSQL_JAR=$DF_TOOLS/DataCell-mysql-1.0.0-jar-with-dependencies.jar

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

INFILE=$DF_TOOLS/data/quota_20170714_member.txt
OUTFILE_PREFIX='quota_20170714_member'
DB='testdb'

dataArray=(
    '0 メンバーID 1 グループID'
    '0 メンバーID 2 メンバー氏名'
    '0 メンバーID 3 メンバー所属'
    '0 メンバーID 4 メンバーメールアドレス'
    '1 グループID 0 メンバーID'
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

