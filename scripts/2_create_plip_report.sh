#!/bin/sh
CURRENT_DIR=$(pwd)
# ROOT_DIR=$(dirname $(pwd))

# Environment variables
# RECEPTOR=1lpb
# PLIP_SCRIPT_FILE=/mnt/e/wsl_home/plip/plip/plipcmd.py
# PLIP_REPORTS_DIR=reports
# DOCKING_RUNS_DIR=$ROOT_DIR/docking_runs_vina/$RECEPTOR
# PROT_LIG_COMPLEX_LISTFILE=list_prot_lig_complexes.txt
# XML_REPORT_LIST_FILENAME=list_xml_reports.txt

rm -f "$DOCKING_RUNS_DIR/$XML_REPORT_LIST_FILENAME"
touch "$DOCKING_RUNS_DIR/$XML_REPORT_LIST_FILENAME"

COUNTER=1
# Get all immediate Ligands Dir
for c in $(cat $DOCKING_RUNS_DIR/$PROT_LIG_COMPLEX_LISTFILE); 
do
	LIG_DIR=$(echo $c | cut -d/ -f1) # Get the ligand directory
	COMPLEX_FILE_NAME=$(echo $c | cut -d/ -f3) # Get the complex filename
	mkdir -p "$DOCKING_RUNS_DIR/$LIG_DIR/$PLIP_REPORTS_DIR"
	mkdir -p "$DOCKING_RUNS_DIR/$LIG_DIR/$PLIP_REPORTS_DIR/${COMPLEX_FILE_NAME%.*}"
	cd "$DOCKING_RUNS_DIR/$LIG_DIR/$PLIP_REPORTS_DIR/${COMPLEX_FILE_NAME%.*}"
	
	echo
	echo "Writing report for complex $COUNTER for $RECEPTOR > $LIG_DIR/$PLIP_REPORTS_DIR/${COMPLEX_FILE_NAME%.*}"

	python $PLIP_SCRIPT_FILE --file "$DOCKING_RUNS_DIR/$c" -pxyt
	echo "$DOCKING_RUNS_DIR/$LIG_DIR/$PLIP_REPORTS_DIR/${COMPLEX_FILE_NAME%.*}/report.xml" >> $DOCKING_RUNS_DIR/$XML_REPORT_LIST_FILENAME
	cd $CURRENT_DIR
	COUNTER=$((COUNTER+1))
done
