#!/bin/bash

# Script looks for subject with ID given as argument in the current directory. It goes through all the sessions, but skips fMRI data from sessions without a fieldmap (it is required for preprocessing)


### Status, good draft the logic, but still needs to be debugged. Also problems with the helepr script.

get_batch_options() {
    local arguments=("$@")

    unset ${path_of_destination_folder}
    unset subjectlist_csv
    unset path_of_raw_folder

    local index=0
    local numArgs=${#arguments[@]}
    local argument

    while [ ${index} -lt ${numArgs} ]; do
        argument=${arguments[index]}

        case ${argument} in
            --DestinationFolder=*)
                path_of_destination_folder=${argument#*=}
                index=$(( index + 1 ))
                ;;
            --RawDataFolder=*)
                path_of_raw_folder=${argument#*=}
                index=$(( index + 1 ))
                ;;
            --SubjectID=*)
                subject=${argument#*=}
                index=$(( index + 1 ))
                ;;
	    *)
		echo ""
		echo "ERROR: Unrecognized Option: ${argument}"
		echo ""
		exit 1
		;;
        esac
    done
}

get_batch_options "$@"
echo "Destination Folder: ${path_of_destination_folder}"
echo "Raw Folder: ${path_of_raw_folder}"
echo "Subject ID: ${subject}"
echo "FSL Directory: ${FSLDIR}"
echo "Current Path: ${PATH}"

mkdir -p ${path_of_destination_folder}/${subject}/unprocessed/3T


cd "${path_of_raw_folder}"
echo ${PWD}
if [ -d "${subject}" ]
then

  ### Setup ###
  echo "Found ${subject} data"
  cd "${path_of_raw_folder}/${subject}"
  #Create invalid_files.txt to record errors and unusuable scans
  touch ${path_of_destination_folder}/${subject}/invalid_files.txt

  ### Structural Scans ###

  # Find T1
  if [ -d *T1w_MPRAGE_PROMO* ] #check if the directory exists
  then
    mkdir ${path_of_destination_folder}/${subject}/unprocessed/3T/T1w_MPR1
    echo "T1 found, copying..."
    cd "$(find . -name *T1w_MPRAGE_PROMO -type d)"
    rsync -av *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/T1w_MPR1/${subject}_3T_T1w_MPR1.nii.gz
    cd "${path_of_raw_folder}/${subject}"
  else
    echo "Couldn't find T1 folder">>${path_of_destination_folder}/${subject}/invalid_files.txt
  fi
  # Find T2
  if [ -d *T2w_CUBE_PROMO_8mm_sag* ]
  then
    mkdir ${path_of_destination_folder}/${subject}/unprocessed/3T/T2w_SPC1
    echo "T2 found, copying..."
    cd "$(find . -name *T2w_CUBE_PROMO_8mm_sag -type d)"
    rsync -av *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/T2w_SPC1/${subject}_3T_T2w_SPC1.nii.gz
    cd "${path_of_raw_folder}/${subject}"
  else
    echo "Couldn't find T2 folder">>${path_of_destination_folder}/${subject}/invalid_files.txt
  fi


  # # Find DWI
  # if [ -d *DTI_pe0_g81 ]
  # then
  #   mkdir ${path_of_destination_folder}/${subject}/unprocessed/3T/Diffusion
  #   echo "DTI PA g81 found in session $session, copying..."
  #   cd "$(find . -name *DTI_pe0_g81 -type d)"
  #   cp *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_PA.nii.gz
  #
  #   # Reading bvals and bvecs, discarding the ones from calibration volumes.
  #   bvals=`cat *bval`
  #   bvals="${bvals//.0}" #FSL doesn't accept decimals
  #   arr=($bvals)
  #   echo "${arr[@]: -81}">${path_of_raw_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_PA.bval
  #
  #   index=0; while read line; do myArray[index]="$line"; ((index++)); done<*.bvec
  #   row0=${myArray[0]}
  #   row1=${myArray[1]}
  #   row2=${myArray[2]}
  #   echo -e ${row0[@]: -81}"\n"${row1[@]: -81}"\n"${row2[@]: -81}>${path_of_raw_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_PA.bvec
  #
  #   echo "Cutting first two calibration volumes"
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_PA.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_PA.nii.gz 2 -1
  #   cd "${path_of_raw_folder}/${subject}"
  # fi
  #
  # if [ -d *DTI_pe0_g79 ]
  # then
  #   echo "DTI PA g79 found in session $session, copying..."
  #   cd "$(find . -name *DTI_pe0_g79 -type d)"
  #   cp *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_PA.nii.gz
  #
  #   # Reading bvals and bvecs, discarding the ones from calibration volumes.
  #   bvals=`cat *bval`
  #   bvals="${bvals//.0}" #FSL doesn't accept decimals
  #   arr=($bvals)
  #   echo "${arr[@]: -79}">${path_of_raw_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_PA.bval
  #
  #   index=0; while read line; do myArray[index]="$line"; ((index++)); done<*.bvec
  #   row0=${myArray[0]}
  #   row1=${myArray[1]}
  #   row2=${myArray[2]}
  #   echo -e ${row0[@]: -79}"\n"${row1[@]: -79}"\n"${row2[@]: -79}>${path_of_raw_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_PA.bvec
  #
  #   echo "Cutting first two calibration volumes"
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_PA.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_PA.nii.gz 2 -1
  #   cd "${path_of_raw_folder}/${subject}"
  # fi
  #
  # if [ -d *DTI_pe1_g81 ]
  # then
  #   echo "DTI AP g81 found in session $session, copying..."
  #   cd "$(find . -name *DTI_pe1_g81 -type d)"
  #   cp *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_AP.nii.gz
  #
  #   # Reading bvals and bvecs, discarding the ones from calibration volumes.
  #   bvals=`cat *bval`
  #   bvals="${bvals//.0}" #FSL doesn't accept decimals
  #   arr=($bvals)
  #   echo "${arr[@]: -81}">>${path_of_raw_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_AP.bval
  #
  #   index=0; while read line; do myArray[index]="$line"; ((index++)); done<*.bvec
  #   row0=${myArray[0]}
  #   row1=${myArray[1]}
  #   row2=${myArray[2]}
  #   echo -e ${row0[@]: -81}"\n"${row1[@]: -81}"\n"${row2[@]: -81}>${path_of_raw_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_AP.bvec
  #
  #   echo "Cutting first two calibration volumes"
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_AP.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_AP.nii.gz 2 -1
  #   cd "${path_of_raw_folder}/${subject}"
  # fi
  #
  # if [ -d *DTI_pe1_g79 ]
  # then
  #   echo "DTI AP g79 found in session $session, copying..."
  #   cd "$(find . -name *DTI_pe0_g79 -type d)"
  #   cp *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_AP.nii.gz
  #
  #   # Reading bvals and bvecs, discarding the ones from calibration volumes.
  #   bvals=`cat *bval`
  #   bvals="${bvals//.0}" #FSL doesn't accept decimals
  #   arr=($bvals)
  #   echo "${arr[@]: -79}">${path_of_raw_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_AP.bval
  #
  #   index=0; while read line; do myArray[index]="$line"; ((index++)); done<*.bvec
  #   row0=${myArray[0]}
  #   row1=${myArray[1]}
  #   row2=${myArray[2]}
  #   echo -e ${row0[@]: -79}"\n"${row1[@]: -79}"\n"${row2[@]: -79}>${path_of_raw_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_AP.bvec
  #
  #   echo "Cutting first two calibration volumes"
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_AP.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_AP.nii.gz 2 -1
  #   cd "${path_of_raw_folder}/${subject}"
  # fi


  ### Find Functional Scans ###
  # Find fieldmaps, save the full path, copy and cut later within each scan
    if [ -d *fieldmap_1_pe0 ]
    then
      #Pe0
      echo "Fieldmaps found in Part 1"
      cd "$(find . -name *fieldmap_1_pe0 -type d)"
      dim4=$(fslhd *.nii.gz | grep "^dim4" | cut -d " " -f 12)
      if [ ${dim4} -eq 4 ]
      then
        fmapPA="$PWD/*.nii.gz"
      else
        echo "Incorrect volumes for Part 1 Pe0 fieldmap:" >>${path_of_destination_folder}/${subject}/invalid_files.txt
        echo "$PWD/*.nii.gz" >>${path_of_destination_folder}/${subject}/invalid_files.txt
      fi
      cd "${path_of_raw_folder}/${subject}"
      #Pe1
      cd "$(find . -name *fieldmap_1_pe1 -type d)"
      dim4=$(fslhd *.nii.gz | grep "^dim4" | cut -d " " -f 12)
      if [ ${dim4} -eq 4 ]
      then
          fmapAP="$PWD/*.nii.gz"
      else
        echo "Incorrect volumes for Part 1 Pe1 fieldmap:" >>path_of_destination_folder}/${subject}/invalid_files.txt
        echo "$PWD/*.nii.gz" >>${path_of_destination_folder}/${subject}/invalid_files.txt
      fi
      cd "${path_of_raw_folder}/${subject}"
    else
      echo "No fieldmaps in this session. fMRI processing impossible for HCP, skipping to next session."
      echo "No fieldmaps in this session!" >>${path_of_destination_folder}/${subject}/invalid_files.txt
      continue
    fi

  # Find rest AP
    if [ ! -e ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_AP/${subject}_3T_rfMRI_REST1_AP.nii.gz ]
    then

      if [ -d *rsFmri24_pe1_ssg ]
      then
        #Are there multiple folders?
        dirs=$(find . -name "*rsFmri24_1_pe1_ssg*" -type d | wc -l)
        if [ ${dirs} -gt 1 ]
        then
            echo "Error foud more than one directory for RS 1, check invalid_files.txt"
            echo "Multiple RS_1 Directories" >>${path_of_destination_folder}/${subject}/invalid_files.txt
            echo $(find . -wholename "*rsFmri24*/*.nii.gz" -type f) | tr " " "\n" >>${path_of_destination_folder}/${subject}/invalid_files.txt #print folders and scans to
        else
            #Create Directory for Destination Folder
            mkdir ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_AP
            echo "First Rest run AP found"
            #CD raw Directory
            cd "$(find . -name *rsFmri24_pe1_ssg* -type d)"
            #Check number of volumes
            dim4=$(fslhd *.nii.gz | grep "^dim4" | cut -d " " -f 12)
            if [ ${dim4} -eq 428 ]
            then
                rsync -av *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_AP/${subject}_3T_rfMRI_REST1_AP.nii.gz
                echo "Cutting first two volumes..."
                fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_AP/${subject}_3T_rfMRI_REST1_AP.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_AP/${subject}_3T_rfMRI_REST1_AP.nii.gz 2 -1
                echo "Copying and cutting fieldmaps..."
                rsync -av $fmapPA ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_AP/${subject}_3T_SpinEchoFieldMap_PA.nii.gz
                fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_AP/${subject}_3T_SpinEchoFieldMap_PA.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_AP/${subject}_3T_SpinEchoFieldMap_PA.nii.gz 3 3
                rsync -av $fmapAP ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_AP/${subject}_3T_SpinEchoFieldMap_AP.nii.gz
                fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_AP/${subject}_3T_SpinEchoFieldMap_AP.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_AP/${subject}_3T_SpinEchoFieldMap_AP.nii.gz 3 3
                cd "${path_of_raw_folder}/${subject}"
            fi #If there is correct num of volumes
        fi  #If there are too many rs folders
      fi #If a RS folder exists
    fi #If the RS folder doesn't already exist

    if [ ! -e ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_AP/${subject}_3T_rfMRI_REST1_AP_SBRef.nii.gz ]
    then
        # Find sbref
        if [ -d *BOLD_SB_ref_RS_1 ]
        then
            cd "$(find $PWD -type d -name "*BOLD_SB_ref_RS_1")"
            rsync -av *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_AP/${subject}_3T_rfMRI_REST1_AP_SBRef.nii.gz
            echo "Cutting SbRef..."
            fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_AP/${subject}_3T_rfMRI_REST1_AP_SBRef.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_AP/${subject}_3T_rfMRI_REST1_AP_SBRef.nii.gz 3 3
            cd "${path_of_raw_folder}/${subject}"
        fi
    fi

  # # Find rest PA
  # if [ -d *rsFmri24_1_pe0_ssg ]
  # then
  #   echo "Rest run PA found in session $session, copying..."
  #   cd "$(find . -name *rsFmri24_pe0_ssg* -type d)"
  #   mkdir ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_PA
  #   cp *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_PA/${subject}_3T_rfMRI_REST1_PA.nii.gz
  #   echo "Cutting first two volumes..."
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_PA/${subject}_3T_rfMRI_REST1_PA.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_PA/${subject}_3T_rfMRI_REST1_PA.nii.gz 2 -1
  #   echo "Copying and cutting fieldmaps..."
  #   cp $fmapPA ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz 3 3
  #   cp $fmapAP ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST1_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz 3 3
  #   cd "${path_of_raw_folder}/${subject}"
  #
  #   # Find sbref
  #   s="$(find $PWD -type d -name '*rsFmri24_pe0_ssg*' | awk -F/ '{print $NF}')"
  #   fmri_prefix=(${s//_/ })
  #   sbref_prefix="$(($fmri_prefix - 1))"
  #   sbref_prefix_2="$(($fmri_prefix - 2))"
  #   if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
  #   then
  #   echo "Found SBref (1 folder before this acquisition), copying..."
  #   cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
  #   cp *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_rfMRI_REST${session}_PA_SBRef.nii.gz
  #   echo "Cutting SbRef..."
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_rfMRI_REST${session}_PA_SBRef.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_rfMRI_REST${session}_PA_SBRef.nii.gz 3 3
  #   cd "${path_of_raw_folder}/${subject}"
  #   elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
  #   then
  #   echo "Found SBref (2 folders before this acquisition), copying..."
  #   cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
  #   cp *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_rfMRI_REST${session}_PA_SBRef.nii.gz
  #   echo "Cutting SbRef..."
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_rfMRI_REST${session}_PA_SBRef.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_rfMRI_REST${session}_PA_SBRef.nii.gz 3 3
  #   cd "${path_of_raw_folder}/${subject}"
  #   fi
  # fi
  #
  # # Find emotion PA
  # if [ -d *tFmri_Emotion_pe0_ssg ]
  # then
  #   echo "Rest run AP found in session $session, copying..."
  #   cd "$(find . -name *tFmri_Emotion_pe0_ssg* -type d)"
  #   mkdir ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_EMOTION_PA
  #   cp *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA.nii.gz
  #   echo "Cutting first two volumes..."
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA.nii.gz 2 -1
  #   echo "Copying and cutting fieldmaps..."
  #   cp $fmapPA ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz 3 3
  #   cp $fmapAP ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz 3 3
  #   cd "${path_of_raw_folder}/${subject}"
  #
  #   # Find sbref
  #   s="$(find $PWD -type d -name '*tFmri_Emotion_pe0_ssg*' | awk -F/ '{print $NF}')"
  #   fmri_prefix=(${s//_/ })
  #   sbref_prefix="$(($fmri_prefix - 1))"
  #   sbref_prefix_2="$(($fmri_prefix - 2))"
  #   if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
  #   then
  #   echo "Found SBref (1 folder before this acquisition), copying..."
  #   cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
  #   cp *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA_SBRef.nii.gz
  #   echo "Cutting SbRef..."
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA_SBRef.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA_SBRef.nii.gz 3 3
  #   cd "${path_of_raw_folder}/${subject}"
  #   elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
  #   then
  #   echo "Found SBref (2 folders before this acquisition), copying..."
  #   cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
  #   cp *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA_SBRef.nii.gz
  #   echo "Cutting SbRef..."
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA_SBRef.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA_SBRef.nii.gz 3 3
  #   cd "${path_of_raw_folder}/${subject}"
  #   fi
  # fi
  #
  # # Find gambling PA
  # if [ -d *tFmri_Gambling_pe0_ssg ]
  # then
  #   echo "Rest run AP found in session $session, copying..."
  #   cd "$(find . -name *tFmri_Gambling_pe0_ssg* -type d)"
  #   mkdir ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_GAMBLING_PA
  #   cp *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA.nii.gz
  #   echo "Cutting first two volumes..."
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA.nii.gz 2 -1
  #   echo "Copying and cutting fieldmaps..."
  #   cp $fmapPA ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz 3 3
  #   cp $fmapAP ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz 3 3
  #   cd "${path_of_raw_folder}/${subject}"
  #
  #   # Find sbref
  #   s="$(find $PWD -type d -name '*tFmri_Gambling_pe0_ssg*' | awk -F/ '{print $NF}')"
  #   fmri_prefix=(${s//_/ })
  #   sbref_prefix="$(($fmri_prefix - 1))"
  #   sbref_prefix_2="$(($fmri_prefix - 2))"
  #   if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
  #   then
  #   echo "Found SBref (1 folder before this acquisition), copying..."
  #   cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
  #   cp *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz
  #   echo "Cutting SbRef..."
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz 3 3
  #   cd "${path_of_raw_folder}/${subject}"
  #   elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
  #   then
  #   echo "Found SBref (2 folders before this acquisition), copying..."
  #   cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
  #   cp *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz
  #   echo "Cutting SbRef..."
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz 3 3
  #   cd "${path_of_raw_folder}/${subject}"
  #   fi
  # fi
  #
  # # Find WM PA
  # if [ -d *tFmri_WM_pe0_ssg ]
  # then
  #   echo "Rest run AP found in session $session, copying..."
  #   cd "$(find . -name *tFmri_WM_pe0_ssg* -type d)"
  #   mkdir ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_WM_PA
  #   cp *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA.nii.gz
  #   echo "Cutting first two volumes..."
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA.nii.gz 2 -1
  #   echo "Copying and cutting fieldmaps..."
  #   cp $fmapPA ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz 3 3
  #   cp $fmapAP ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz 3 3
  #   cd "${path_of_raw_folder}/${subject}"
  #
  #   # Find sbref
  #   s="$(find $PWD -type d -name '*tFmri_WM_pe0_ssg*' | awk -F/ '{print $NF}')"
  #   fmri_prefix=(${s//_/ })
  #   sbref_prefix="$(($fmri_prefix - 1))"
  #   sbref_prefix_2="$(($fmri_prefix - 2))"
  #   if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
  #   then
  #   echo "Found SBref (1 folder before this acquisition), copying..."
  #   cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
  #   cp *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA_SBRef.nii.gz
  #   echo "Cutting SbRef..."
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA_SBRef.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA_SBRef.nii.gz 3 3
  #   cd "${path_of_raw_folder}/${subject}"
  #   elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
  #   then
  #   echo "Found SBref (2 folders before this acquisition), copying..."
  #   cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
  #   cp *.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA_SBRef.nii.gz
  #   echo  "Cutting SbRef..."
  #   fslroi ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA_SBRef.nii.gz ${path_of_destination_folder}/${subject}/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA_SBRef.nii.gz 3 3
  #   cd "${path_of_raw_folder}/${subject}"
  #   fi
  # fi


fi
