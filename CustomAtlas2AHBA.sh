#!/bin/bash
currentPath=$(pwd)
#import D_K308 atlas
git clone https://github.com/RafaelRomeroGarcia/subParcellation
# Select the corresponding annot file names
DKpath="$currentPath/subParcellation/500mm parcellation (308 regions)"
filesToCopy=("rh.500.aparc.annot" "lh.500.aparc.annot")
CustomAtlas="$DKpath/$file"

# Import AHBA reconstruction results, comment out if already present
git clone https://github.com/lubiandexiaochitan/AHBA_SurferRecon
# The .annot file for the custom atlas needs to be placed in the 'label' folder of fsaverage.
Labelpath="$currentPath/AHBA_SurferRecon/freesurfer/fsaverage/label"

# Copy .annot files
for file in "${filesToCopy[@]}"; do
destinationFile="$Labelpath/$file"
    # Check if the file already exists at the destination path
    if [ -f "$destinationFile" ]; then
    echo "File already exists: $destinationFile"
    exit 1
    else
        # Copy .annot file
        cp "$CustomAtlas" "$Labelpath"
    fi
done

# Set FreeSurfer subjects directory
SUBJECTS_DIR="$currentPath/AHBA_SurferRecon/freesurfer"

# Process each subject
cd $SUBJECTS_DIR
for sub in $(ls -d */ | grep -v "fsaverage/"); do
    sub=${sub%/}
    echo "${SUBJECTS_DIR}/${sub}"

    for parcellation in 500.aparc ; do
        for hemi in lh rh ; do
          if [ ! -f "${SUBJECTS_DIR}/${sub}/label/${hemi}.${parcellation}.annot" ] ; then
            mri_surf2surf --srcsubject fsaverage \
                          --sval-annot ${SUBJECTS_DIR}/fsaverage/label/${hemi}.${parcellation} \
                          --trgsubject ${sub} \
                          --trgsurfval ${SUBJECTS_DIR}/${sub}/label/${hemi}.${parcellation} \
                          --hemi ${hemi}
          fi
        done
    done
done

# Remove the copied .annot files
for file in "${filesToCopy[@]}"; do
    destinationFile="$Labelpath/$file"
    rm "$destinationFile"
done

echo "Operation complete, copied files have been removed"
