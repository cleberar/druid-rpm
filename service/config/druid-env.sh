export DRUID_HEAP_OPTS="-Xms1024M -Xmx1024M"
export DRUID_SPEC_OPTS="-Ddruid.realtime.specFile=/etc/druid/evo-analytics-realtime.spec"
export DRUID_OPTS="-XX:PermSize=512m -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+UseCompressedOops -XX:NewSize=200m -XX:MaxNewSize=200m"
