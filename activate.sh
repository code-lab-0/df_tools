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
export DATACELL_MYSQL_JAR=$DF_TOOLS/DataCell-mysql-8.1.2-jar-with-dependencies.jar


#alias dc_join='java -cp $DATACELL_MYSQL_JAR net.ogalab.datacell.mysql.app.DcJoinMySQL "$@"'
#alias dc_list='java -cp $DATACELL_MYSQL_JAR net.ogalab.datacell.mysql.app.DcListMySQL "$@"'
#alias dc_load='java -cp $DATACELL_MYSQL_JAR net.ogalab.datacell.mysql.app.DcLoadMySQL "$@"'
#alias dc_delete='java -cp $DATACELL_MYSQL_JAR net.ogalab.datacell.mysql.app.DcDeleteTablesMySQL "$@"'

dc_join() {
    java -cp $DATACELL_MYSQL_JAR net.ogalab.datacell.mysql.app.DcJoinMySQL "$@"
}

dc_list() {
    java -cp $DATACELL_MYSQL_JAR net.ogalab.datacell.mysql.app.DcListMySQL "$@"
}

dc_load() {
    java -cp $DATACELL_MYSQL_JAR net.ogalab.datacell.mysql.app.DcLoadMySQL "$@"
}

dc_delete() {
    java -cp $DATACELL_MYSQL_JAR net.ogalab.datacell.mysql.app.DcDeleteTablesMySQL "$@"
}
#
#
#

