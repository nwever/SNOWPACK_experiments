name=$1
var_to_plot=$2
file_to_plot=$3
file_to_plot2=$4

if [ $# -lt 3 ]; then
	echo "Wrong number of command line parameters."
	exit
fi

mkdir -p figures
plotfilename="./figures/${name}"

xi=1
linespec="lt 1 lw 1"

echo "set term pdf size 7,4 font 'Liberation Sans,18'" > ${plotfilename}
#echo "set encoding iso_8859_1" >> ${plotfilename}
echo "set datafile missing \"-9999\"" >> ${plotfilename}
echo "set output '${plotfilename}.pdf'" >> ${plotfilename}
echo "set key top left font ',14' reverse" >> ${plotfilename}
echo "set yl 'Snow Depth (cm)'" >> ${plotfilename}
echo "set xl 'Date'" >> ${plotfilename}
xlabels=$(grep ^[0-9] ${file_to_plot} | awk '{printf "%02d-%02d %d\n", int(substr($1,9,2)), int(substr($1,6,2)), NR}' | awk -F- -v xi=$xi '($1==01 && $2%xi==0)' | uniq -w5 | awk 'BEGIN {a=0; printf "set xtics ("} {if(a>0) {printf ", "} else {a=1}; printf "\"%s\" %d", $1, $2} END {printf (")\n")}' | sed 's/-01/ Jan/g' | sed 's/-02/ Feb/g' | sed 's/-03/ Mar/g' | sed 's/-04/ Apr/g' | sed 's/-05/ May/g' | sed 's/-06/ Jun/g' | sed 's/-07/ Jul/g' | sed 's/-08/ Aug/g' | sed 's/-09/ Sep/g' | sed 's/-10/ Oct/g' | sed 's/-11/ Nov/g' | sed 's/-12/ Dec/g')

if [ ! -z "${file_to_plot}" ]; then
	coltoplot=$(fgrep fields ${file_to_plot} | awk -v var_to_plot="${var_to_plot}" '{for(i=3; i<=NF; i++) {if($i==var_to_plot) {print i-2; exit}}}')
	colname=$(basename --suffix ".smet" ${file_to_plot} | cut -d "_" -f2- | tr '_' '-')
else
	echo "Nothing to plot."
	exit
fi
if [ ! -z "${file_to_plot2}" ]; then
	coltoplot2=$(fgrep fields ${file_to_plot2} | awk -v var_to_plot="${var_to_plot}" '{for(i=3; i<=NF; i++) {if($i==var_to_plot) {print i-2; exit}}}')
	colname2=$(basename --suffix ".smet" ${file_to_plot2} | cut -d "_" -f2- | tr '_' '-')
else
	coltoplot2=""
fi
coltoplot3=""
if [ "${var_to_plot}" = "HS_mod" ]; then
	var_to_plot3="HS_meas"
	coltoplot3=$(fgrep fields ${file_to_plot} | awk -v var_to_plot="${var_to_plot3}" '{for(i=3; i<=NF; i++) {if($i==var_to_plot) {print i-2; exit}}}')
fi

# Convert var_to_plot
var_to_plot_t=$(echo ${var_to_plot} | tr '_' '-')
var_to_plot_t3=$(echo ${var_to_plot3} | tr '_' '-')

echo "${xlabels}" >> ${plotfilename}
echo "${ylabels}" >> ${plotfilename}
echo "pl '<(grep ^[0-9] ${file_to_plot})' u ${coltoplot} w l ${linespec} lc rgb '#d1420f' title '${var_to_plot_t} (${colname})' \\" >> ${plotfilename}
if [ ! -z "${coltoplot2}" ]; then
	echo ", '<(grep ^[0-9] ${file_to_plot2})' u ${coltoplot2} w l ${linespec} lc rgb '#0f73d1' title '${var_to_plot_t} (${colname2})' \\" >> ${plotfilename}
fi 
if [ ! -z "${coltoplot3}" ]; then
	echo ", '<(grep ^[0-9] ${file_to_plot})' u ${coltoplot3} w l ${linespec} lc rgb 'black' title '${var_to_plot_t3}' \\" >> ${plotfilename}
fi 
echo "" >> ${plotfilename}
gnuplot ${plotfilename}
rm ${plotfilename}
