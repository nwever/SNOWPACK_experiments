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
echo "bash plotting.sh ${tag} HS_mod output/MST96_default.smet output/MST96_default.smet" >> ${plotfile}


#
# Set NEUTRAL atmospheric stability
#
tag=neutral
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ATMOSPHERIC_STABILITY = NEUTRAL" >> ${inifile}
echo "bash plotting.sh ${tag} HS_mod output/MST96_default.smet output/MST96_${tag}.smet" >> ${plotfile}
echo "bash plotting_spring.sh ${tag}_spring HS_mod output/MST96_default.smet output/MST96_${tag}.smet" >> ${plotfile}


#
# Set ENFORCE_MEASURED_SNOW_HEIGHTS and NEUTRAL atmospheric stability
#
tag=HS_neutral
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ENFORCE_MEASURED_SNOW_HEIGHTS = TRUE" >> ${inifile}
echo "ATMOSPHERIC_STABILITY = NEUTRAL" >> ${inifile}
echo "bash plotting.sh ${tag} HS_mod output/MST96_HS.smet output/MST96_${tag}.smet" >> ${plotfile}
echo "bash plotting_spring.sh ${tag}_spring HS_mod output/MST96_HS.smet output/MST96_${tag}.smet" >> ${plotfile}


#
# Set MO_MICHLMAYR atmospheric stability
#
tag=HS_mo_michlmayr
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ENFORCE_MEASURED_SNOW_HEIGHTS = TRUE" >> ${inifile}
echo "ATMOSPHERIC_STABILITY = MO_MICHLMAYR" >> ${inifile}
echo "bash plotting.sh ${tag} HS_mod output/MST96_HS.smet output/MST96_${tag}.smet" >> ${plotfile}
echo "bash plotting_spring.sh ${tag}_spring HS_mod output/MST96_HS.smet output/MST96_${tag}.smet" >> ${plotfile}


#
# Set roughness length
#
tag=HS_Z0_0.07
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ENFORCE_MEASURED_SNOW_HEIGHTS = TRUE" >> ${inifile}
echo "ROUGHNESS_LENGTH = 0.07" >> ${inifile}
echo "bash plotting.sh ${tag} HS_mod output/MST96_default.smet output/MST96_${tag}.smet" >> ${plotfile}
echo "bash plotting_spring.sh ${tag}_spring HS_mod output/MST96_HS.smet output/MST96_${tag}.smet" >> ${plotfile}


#
# Set conditions for "Nachschneien": spurious snowfalls during ablation because of overestimated melt
#
tag=HS_Nachschneien
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ENFORCE_MEASURED_SNOW_HEIGHTS = TRUE" >> ${inifile}
echo "ATMOSPHERIC_STABILITY = NEUTRAL" >> ${inifile}
echo "[SNOWPACKADVANCED]" >> ${inifile}
echo "THRESH_RAIN = 10" >> ${inifile}
echo "THRESH_DTEMP_AIR_SNOW = 8.0" >> ${inifile}
echo "[INPUT]" >> ${inifile}
echo "PSUM_PH::PRECSPLITTING::SNOW = 284.35" >> ${inifile}
echo "bash plotting_spring.sh ${tag}_spring HS_mod output/MST96_HS.smet output/MST96_${tag}.smet" >> ${plotfile}


#
# Set ENFORCE_MEASURED_SNOW_HEIGHTS
#
tag=HS
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ENFORCE_MEASURED_SNOW_HEIGHTS = TRUE" >> ${inifile}
echo "bash plotting.sh ${tag} HS_mod output/MST96_default.smet output/MST96_${tag}.smet" >> ${plotfile}
echo "bash plotting.sh ${tag}_dflt HS_mod output/MST96_${tag}.smet output/MST96_${tag}.smet" >> ${plotfile}
echo "bash plotting_spring.sh ${tag}_dflt_spring HS_mod output/MST96_${tag}.smet output/MST96_${tag}.smet" >> ${plotfile}


#
# Set ENFORCE_MEASURED_SNOW_HEIGHTS and clear sky incoming longwave
#
tag=HS_CSKY
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ENFORCE_MEASURED_SNOW_HEIGHTS = TRUE" >> ${inifile}
echo "CHANGE_BC = false" >> ${inifile}
echo "[SNOWPACKADVANCED]" >> ${inifile}
echo "THRESH_DTEMP_AIR_SNOW = 3.0" >> ${inifile}
echo "[InputEditing]" >> ${inifile}
echo "*::edit10		= EXCLUDE" >> ${inifile}
echo "*::arg10::params  = ILWR" >> ${inifile}
echo "[Generators]" >> ${inifile}
echo "ILWR::generator1 = clearsky_LW" >> ${inifile}
echo "ILWR::arg1::type = Dilley" >> ${inifile}
echo "bash plotting.sh ${tag} HS_mod output/MST96_HS.smet output/MST96_${tag}.smet" >> ${plotfile}
echo "bash plotting_spring.sh ${tag}_spring HS_mod output/MST96_HS.smet output/MST96_${tag}.smet" >> ${plotfile}
echo "bash plotting.sh ${tag}_tss TSS_mod output/MST96_HS.smet output/MST96_${tag}.smet" >> ${plotfile}


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
# Set ENFORCE_MEASURED_SNOW_HEIGHTS and ZWART new snow density
#
tag=HS_ZWART
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ENFORCE_MEASURED_SNOW_HEIGHTS = TRUE" >> ${inifile}
echo "[SNOWPACKADVANCED]" >> ${inifile}
echo "HN_DENSITY_PARAMETERIZATION = ZWART" >> ${inifile}
echo "bash plotting.sh ${tag} HS_mod output/MST96_HS.smet output/MST96_${tag}.smet" >> ${plotfile}


#
# Set ENFORCE_MEASURED_SNOW_HEIGHTS and ZWART new snow density
#
tag=HS_RHO_HN_150
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ENFORCE_MEASURED_SNOW_HEIGHTS = TRUE" >> ${inifile}
echo "SNOW_EROSION = FALSE" >> ${inifile}
echo "[SNOWPACKADVANCED]" >> ${inifile}
echo "HN_DENSITY = FIXED" >> ${inifile}
echo "HN_DENSITY_FIXEDVALUE = 150" >> ${inifile}
echo "bash plotting.sh ${tag} HS_mod output/MST96_HS.smet output/MST96_${tag}.smet" >> ${plotfile}


#
# Set ENFORCE_MEASURED_SNOW_HEIGHTS and no TSS
#
tag=HS_FIXTSS
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ENFORCE_MEASURED_SNOW_HEIGHTS = TRUE" >> ${inifile}
echo "CHANGE_BC = TRUE" >> ${inifile}
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


#
# Set 12 hour timesteps
#
tag=DT12H
Init
echo "[SNOWPACK]" >> ${inifile}
echo "ENFORCE_MEASURED_SNOW_HEIGHTS = TRUE" >> ${inifile}
echo "CALCULATION_STEP_LENGTH = 720" >> ${inifile}
echo "bash plotting.sh ${tag} HS_mod output/MST96_HS.smet output/MST96_${tag}.smet" >> ${plotfile}
