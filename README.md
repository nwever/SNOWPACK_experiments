# SNOWPACK_experiments
Doing some experiments with the SNOWPACK example for WFJ (res1exp) in the SNOWPACK doc/examples/ folder.

## Requirements

- Compiled MeteoIO and SNOWPACK
- GNU tools like bash, sed, awk, etc.
- gnuplot for plotting

## Steps to reproduce
1) Clone this repository in the `doc/exampes/` folder in the SNOWPACK git repository
2) Navigate to the folder: `doc/examples/SNOWPACK_experiments/`
3) In a bash terminal, execute `bash setup_experiments.sh`. This does the following:
   - Creates an *.ini file for each experiment
   - Adds a command to run SNOWPACK to the file `runs.lst`
4) In a bash terminal, execute `bash runs.lst` to execute all the SNOWPACK simulations
