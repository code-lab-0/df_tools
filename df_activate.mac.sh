#!/bin/bash -x

#
#
#

export DF_TOOLS=$HOME/works/df_tools
export PATH=$PATH:$DF_TOOLS


#brew update
#brew upgrade
brew install dos2unix

# alias dc_join_h2='java -cp $DF_TOOLS/DataCell-h2-8.1.0-jar-with-dependencies.jar net.ogalab.datacell.h2.app.DcJoinH2 "$@"'

# alias dc_list_h2='java -cp $DF_TOOLS/DataCell-h2-8.1.0-jar-with-dependencies.jar net.ogalab.datacell.h2.app.DcListH2 "$@"'

# alias dc_load_h2='java -cp $DF_TOOLS/DataCell-h2-8.1.0-jar-with-dependencies.jar net.ogalab.datacell.h2.app.DcLoadH2 "$@"'

# alias dc_delete_h2='java -cp $DF_TOOLS/DataCell-h2-8.1.0-jar-with-dependencies.jar net.ogalab.datacell.h2.app.DcDeleteTablesH2 "$@"'

alias dc_join='java -cp $DF_TOOLS/DataCell-mysql-8.1.0-jar-with-dependencies.jar net.ogalab.datacell.mysql.app.DcJoinMySQL "$@"'

alias dc_list='java -cp $DF_TOOLS/DataCell-mysql-8.1.0-jar-with-dependencies.jar net.ogalab.datacell.mysql.app.DcListMySQL "$@"'

alias dc_load='java -cp $DF_TOOLS/DataCell-mysql-8.1.0-jar-with-dependencies.jar net.ogalab.datacell.mysql.app.DcLoadMySQL "$@"'

alias dc_delete='java -cp $DF_TOOLS/DataCell-mysql-8.1.0-jar-with-dependencies.jar net.ogalab.datacell.mysql.app.DcDeleteTablesMySQL "$@"'


#
#
#

