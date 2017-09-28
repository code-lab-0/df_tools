#!/bin/bash
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

DB=('dummy' 'dummy' 'dummy' 'uge_submit_count' 'uge_cpu_usage' 'uge_memory_usage')

for m in 01 02 03 04 05 06 07 08 09 10 11 12
do
    if [ -r parsed_data/gyoumu_phase1_2017${m}.tsv ]; then
        for queue in 'debug.q' 'login.q' 'month_hdd.q' 'month_ssd.q' 'week_hdd.q' 'week_ssd.q' 'total'
        do
            for i in 3 4 5
            do
                grep "\s${queue}\s" parsed_data/gyoumu_phase1_2017${m}.tsv | \
                cut -f1,${i} | \
                dc_load.my -db ${DB[${i}]} -f TSV2 -ds account -p gyoumu_phase1_${queue}_2017${m} -op kv
            done
        done
    fi
done
