#!/bin/sh

#
# Create a release package from a BSP build.
#

usage()
{
    echo "Usage: ${0} NAME [LICENSE]"
    echo "  NAME        Basename of the package."
    echo "  LICENSE     License file to be used when making installer."
    echo
    exit 0
}

die()
{
    echo "ERROR: $@"
    exit 1
}

OUTDIR=$1

if [ -z "${OUTDIR}" ]; then
    usage
fi

if [ "${OUTDIR}" = "-h" ] || [ "${OUTDIR}" = "--help" ]; then
    usage
fi

if [ -d "${OUTDIR}" ]; then
    die "${OUTDIR} already exists.  Please remove."
fi

CP=`which cp`
MKDIR=`which mkdir`
RMDIR=`which rmdir`
WC=`which wc`
TAR=`which tar`

if [ -z "${CP}" ] ||
   [ -z "${MKDIR}" ] ||
   [ -z "${RMDIR}" ] ||
   [ -z "${WC}" ] ||
   [ -z "${TAR}" ]; then
	echo "Missing dependencies:\n"
	echo "CP=${CP}"
	echo "MKDIR=${MKDIR}"
	echo "RMDIR=${RMDIR}"
	echo "WC=${WC}"
	echo "TAR=${TAR}"
	exit 1
fi

checkfile()
{
    [ -f "$1" ] || die "Required file $1 not found.  Did you build?"
}

checkfile "output/images/uImage"
checkfile "output/images/rootfs.tar"

${MKDIR} -p ${OUTDIR}/output/images/
${CP} output/images/uImage ${OUTDIR}/output/images/
${CP} output/images/*.dtb ${OUTDIR}/output/images/
${CP} output/images/uEnv.txt ${OUTDIR}/output/images/
${CP} output/images/rootfs.tar ${OUTDIR}/output/images/
${CP} output/images/u-boot ${OUTDIR}/output/images/
${CP} ../pic32_br_bsp/board/microchip/scripts/mksdcard ${OUTDIR}

count=`ls -1 output/images/*.hex 2>/dev/null | ${WC} -l`
if [ $count != 0 ]; then
    ${MKDIR} -p ${OUTDIR}/dist/pic32mzda/production/
    ${CP} output/images/*.hex ${OUTDIR}/dist/pic32mzda/production/
    ${CP} output/build/stage1-*/stage1.X/flash.sh ${OUTDIR}
    ${CP} output/build/stage1-*/stage1.X/boot_flash.cfg.in ${OUTDIR}
else
    echo "Bootloader not built.  Not including."
fi

SHELLINSTALLER=`which shell_installer.sh`
if [ -z "${SHELLINSTALLER}" ]; then
    ${TAR} -czf ${OUTDIR}.tar.gz ${OUTDIR}
else
    shell_installer.sh --license $2 ${OUTDIR}
fi

rm -rf ${OUTDIR}
