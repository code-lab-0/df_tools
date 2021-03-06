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
year='2017'

for m in 01 02 03 04 05 06 07 08 09 10 11 12
do
    for p in 1 2
    do
        if [ -r parsed_data/kenkyu_phase${p}_${year}${m}.tsv ]; then
            for queue in 'challenge.q' 'dbcls.q' 'debug.q' 'login.q' 'login_sp.q' 'month_fat.q' 'month_gpu.q' 'month_hdd.q' 'month_medium.q' 'month_phi.q' 'month_ssd.q' 'short.q' 'week_hdd.q' 'week_ssd.q' 'total'
            do
                for i in 3 4 5
                do
                    grep "\s${queue}\s" parsed_data/kenkyu_phase${p}_${year}${m}.tsv | \
                    cut -f1,${i} | \
                    dc_load.my -db ${DB[${i}]} -f TSV2 -ds account -p kenkyu_phase${p}_${queue}_${year}${m} -op kv
                done
            done
        fi
    done
done
