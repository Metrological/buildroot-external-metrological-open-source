#!/usr/bin/env bash
-e
-x

DIR=$( dirname -- "$( readlink -f -- "$0"; )"; )

TEMP="/tmp/sanitize_defconfigs"

DEFCONFIGDIR=$( readlink -f -- ${DIR}/../configs )
DEFCONFIGS=$( ls -1 ${DEFCONFIGDIR}/${FILTER} )

echo $DEFCONFIGDIR
mkdir -p ${TEMP}

for C in $DEFCONFIGS
do
    echo "defconfig: $C"
    make \
        -C ${DIR}/../../buildroot \
        BR2_EXTERNAL="${DIR}/../../buildroot-external-metrological-restricted:${DIR}/../../buildroot-external-metrological-open-source" \
        O=${TEMP}/$C $C
        make -C ${TEMP}/$C syncconfig
        make -C ${TEMP}/$C savedefconfig
done