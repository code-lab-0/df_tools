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

dc_list.my -db df_tools_testdb -ds mail_address -p ippan_id | \
dc_join.my -db df_tools_testdb -ds mail_address -p daikibo_id | \
dc_join.my -db df_tools_testdb -ds mail_address -p migap_id | \
dc_join.my -db df_tools_testdb -ds mail_address -p pipeline_id | \
dc_join.my -db df_tools_testdb -ds mail_address -p gyoumu_id | \
dc_join.my -db df_tools_testdb -ds mail_address -p se_id
