Init()
{
	inifile=./ini/io_${tag}.ini
	echo "../../../bin/snowpack -c ${inifile} -e NOW > log/${tag}.log 2>&1" >> ${runfile}
	echo "IMPORT_BEFORE = ../../cfgfiles/io_res1exp.ini" > ${inifile}
	echo "[INPUT]" >> ${inifile}
	echo "METEOPATH = ../input/" >> ${inifile}
	echo "[OUTPUT]" >> ${inifile}
	echo "EXPERIMENT = ${tag}" >> ${inifile}
}

# Create required directories and initializations
mkdir -p ./ini/
mkdir -p ./log/
mkdir -p ./output/
runfile="runs.lst"
> ${runfile}


#
# DEFAULT, no changes
#
tag=default
Init


#
# Set NEUTRAL atmospheric stability
#
tag=neutral
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ATMOSPHERIC_STABILITY = NEUTRAL" >> ${inifile}


#
# Set ENFORCE_MEASURED_SNOW_HEIGHTS
#
tag=HS
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ENFORCE_MEASURED_SNOW_HEIGHTS = TRUE" >> ${inifile}

