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
OUTFILE=$DATA_DIR/alluser_20170929_group.tsv

parse_alluser.pl --group < $INFILE > $OUTFILE

OUTFILE_PREFIX='alluser_20170929_group'
DB='sc_alluser_20170929'

dataArray=(
    '0 グループID 1 責任者氏名'
    '0 グループID 2 責任者所属'
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

