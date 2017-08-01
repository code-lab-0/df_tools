#!/bin/bash -x

is_defined() {
	varname="$1"
	if set | grep -q "^${varname}="; then
		echo "${varname}" is defined.
	else
		echo "${varname}" is NOT define.
	fi
}


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

