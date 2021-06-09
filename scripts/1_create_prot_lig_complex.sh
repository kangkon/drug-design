#!/bin/sh

# Environment variables
# ROOT_DIR=$(dirname $(pwd))
# RECEPTOR=1lpb
# RECEPTOR_FILENAME=1lpb_chB_fixed.pdbqt
# RESULT_PDBQT_FILENAME=docking_results.pdbqt
# SPLITTED_POSES_DIR=poses
# DOCKING_RUNS_DIR=$ROOT_DIR/docking_runs_vina/$RECEPTOR
# PROT_LIG_COMPLEX_LISTFILE=list_prot_lig_complexes.txt

CURRENT_DIR=$(pwd)

# Initialize complex path list file
rm -f "$DOCKING_RUNS_DIR/$PROT_LIG_COMPLEX_LISTFILE"
touch "$DOCKING_RUNS_DIR/$PROT_LIG_COMPLEX_LISTFILE"

COUNTER=1
# Ligands Directories
for f in $(cat $DOCKING_RUNS_DIR/$LIG_DIR_LISTFILE); 
do	
	echo 
	echo "Processing ligand $COUNTER - $RECEPTOR > $f"
	mkdir -p "$DOCKING_RUNS_DIR/$f/complexes"
	cd "$DOCKING_RUNS_DIR/$f"
    for p in $(find $SPLITTED_POSES_DIR -maxdepth 1 -mindepth 1 -type f -name "*.pdbqt");
	do
		POSE_BASENAME=$(basename $p)
		python $CURRENT_DIR/create_complex_from_poses.py $RECEPTOR_FILENAME $p --output "complexes/complex_${POSE_BASENAME%.*}.pdb"
		# Append complex path to list
		echo "$f/complexes/complex_${POSE_BASENAME%.*}.pdb" >> $DOCKING_RUNS_DIR/$PROT_LIG_COMPLEX_LISTFILE
	done
	COUNTER=$((COUNTER+1))
	cd $CURRENT_DIR
done
