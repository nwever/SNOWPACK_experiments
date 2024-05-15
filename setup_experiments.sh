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
plotfile="plots.lst"
> ${plotfile}


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
echo "bash plotting.sh ${tag} HS_mod output/MST96_default.smet output/MST96_${tag}.smet" >> ${plotfile}


#
# Set ENFORCE_MEASURED_SNOW_HEIGHTS
#
tag=HS
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ENFORCE_MEASURED_SNOW_HEIGHTS = TRUE" >> ${inifile}
echo "bash plotting.sh ${tag} HS_mod output/MST96_default.smet output/MST96_${tag}.smet" >> ${plotfile}


#
# Set ENFORCE_MEASURED_SNOW_HEIGHTS and clear sky incoming longwave
#
tag=HS_CSKY
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ENFORCE_MEASURED_SNOW_HEIGHTS = TRUE" >> ${inifile}
echo "[SNOWPACKADVANCED]" >> ${inifile}
echo "THRESH_DTEMP_AIR_SNOW = 1.0" >> ${inifile}
echo "[InputEditing]" >> ${inifile}
echo "*::edit10		= EXCLUDE" >> ${inifile}
echo "*::arg10::params  = ILWR" >> ${inifile}
echo "bash plotting.sh ${tag} HS_mod output/MST96_HS.smet output/MST96_${tag}.smet" >> ${plotfile}


#
# Set ENFORCE_MEASURED_SNOW_HEIGHTS and clear sky incoming longwave and no TSS
#
tag=HS_CSKY_NOTSS
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ENFORCE_MEASURED_SNOW_HEIGHTS = TRUE" >> ${inifile}
echo "[SNOWPACKADVANCED]" >> ${inifile}
echo "THRESH_DTEMP_AIR_SNOW = 1.0" >> ${inifile}
echo "[InputEditing]" >> ${inifile}
echo "*::edit10		= EXCLUDE" >> ${inifile}
echo "*::arg10::params  = ILWR TSS" >> ${inifile}
echo "bash plotting.sh ${tag} HS_mod output/MST96_HS.smet output/MST96_${tag}.smet" >> ${plotfile}


#
# Set 1 hour timesteps
#
tag=DT1M
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ENFORCE_MEASURED_SNOW_HEIGHTS = TRUE" >> ${inifile}
echo "CALCULATION_STEP_LENGTH = 1" >> ${inifile}
echo "bash plotting.sh ${tag} HS_mod output/MST96_HS.smet output/MST96_${tag}.smet" >> ${plotfile}


#
# Set 1 hour timesteps
#
tag=DT1H
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ENFORCE_MEASURED_SNOW_HEIGHTS = TRUE" >> ${inifile}
echo "CALCULATION_STEP_LENGTH = 60" >> ${inifile}
echo "bash plotting.sh ${tag} HS_mod output/MST96_HS.smet output/MST96_${tag}.smet" >> ${plotfile}


#
# Set 3 hour timesteps
#
tag=DT3H
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ENFORCE_MEASURED_SNOW_HEIGHTS = TRUE" >> ${inifile}
echo "CALCULATION_STEP_LENGTH = 180" >> ${inifile}
echo "bash plotting.sh ${tag} HS_mod output/MST96_HS.smet output/MST96_${tag}.smet" >> ${plotfile}
