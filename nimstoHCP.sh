#!/bin/bash

# Script looks for subject with ID given as argument in the current directory. It goes through all the sessions, but skips fMRI data from sessions without a fieldmap (it is required for preprocessing)
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

mkdir -p ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T

for session in 1 2 3 #there are at most three parts to each scan
do

cd "${path_of_raw_folder}"
echo ${PWD}
if [ -d "${subject}_p${session}" ]
then

echo "Found first session, part $session data"

cd "${subject}_p${session}"

# # Find T1
# if [ -d *T1w_MPRAGE_PROMO ] #check if the directory exists
# then
#   mkdir ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/T1w_MPR1
#   echo "T1 found in session 1, part $session, copying..."
#   cd "$(find . -name *T1w_MPRAGE_PROMO -type d)"
#   cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/T1w_MPR1/${subject}_3T_T1w_MPR1.nii.gz
#   cd "${path_of_raw_folder}/${subject}_p${session}"
# fi
#
#
# # Find T2
# if [ -d *T2w_CUBE_PROMO_8mm_sag ]
# then
#   mkdir ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/T2w_SPC1
#   echo "T2 found in session 1, part $session, copying..."
#   cd "$(find . -name *T2w_CUBE_PROMO_8mm_sag -type d)"
#   cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/T2w_SPC1/${subject}_3T_T2w_SPC1.nii.gz
#   cd "${path_of_raw_folder}/${subject}_p${session}"
# fi
#
#
# # Find DWI
# if [ -d *DTI_pe0_g81 ]
# then
#   mkdir ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/Diffusion
#   echo "DTI PA g81 found in session $session, copying..."
#   cd "$(find . -name *DTI_pe0_g81 -type d)"
#   cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_PA.nii.gz
#
#   # Reading bvals and bvecs, discarding the ones from calibration volumes.
#   bvals=`cat *bval`
#   bvals="${bvals//.0}" #FSL doesn't accept decimals
#   arr=($bvals)
#   echo "${arr[@]: -81}">${path_of_raw_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_PA.bval
#
#   index=0; while read line; do myArray[index]="$line"; ((index++)); done<*.bvec
#   row0=${myArray[0]}
#   row1=${myArray[1]}
#   row2=${myArray[2]}
#   echo -e ${row0[@]: -81}"\n"${row1[@]: -81}"\n"${row2[@]: -81}>${path_of_raw_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_PA.bvec
#
#   echo "Cutting first two calibration volumes"
#   fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_PA.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_PA.nii.gz 2 -1
#   cd "${path_of_raw_folder}/${subject}_p${session}"
# fi
#
# if [ -d *DTI_pe0_g79 ]
# then
#   echo "DTI PA g79 found in session $session, copying..."
#   cd "$(find . -name *DTI_pe0_g79 -type d)"
#   cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_PA.nii.gz
#
#   # Reading bvals and bvecs, discarding the ones from calibration volumes.
#   bvals=`cat *bval`
#   bvals="${bvals//.0}" #FSL doesn't accept decimals
#   arr=($bvals)
#   echo "${arr[@]: -79}">${path_of_raw_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_PA.bval
#
#   index=0; while read line; do myArray[index]="$line"; ((index++)); done<*.bvec
#   row0=${myArray[0]}
#   row1=${myArray[1]}
#   row2=${myArray[2]}
#   echo -e ${row0[@]: -79}"\n"${row1[@]: -79}"\n"${row2[@]: -79}>${path_of_raw_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_PA.bvec
#
#   echo "Cutting first two calibration volumes"
#   fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_PA.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_PA.nii.gz 2 -1
#   cd "${path_of_raw_folder}/${subject}_p${session}"
# fi
#
# if [ -d *DTI_pe1_g81 ]
# then
#   echo "DTI AP g81 found in session $session, copying..."
#   cd "$(find . -name *DTI_pe1_g81 -type d)"
#   cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_AP.nii.gz
#
#   # Reading bvals and bvecs, discarding the ones from calibration volumes.
#   bvals=`cat *bval`
#   bvals="${bvals//.0}" #FSL doesn't accept decimals
#   arr=($bvals)
#   echo "${arr[@]: -81}">>${path_of_raw_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_AP.bval
#
#   index=0; while read line; do myArray[index]="$line"; ((index++)); done<*.bvec
#   row0=${myArray[0]}
#   row1=${myArray[1]}
#   row2=${myArray[2]}
#   echo -e ${row0[@]: -81}"\n"${row1[@]: -81}"\n"${row2[@]: -81}>${path_of_raw_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_AP.bvec
#
#   echo "Cutting first two calibration volumes"
#   fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_AP.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir81_AP.nii.gz 2 -1
#   cd "${path_of_raw_folder}/${subject}_p${session}"
# fi
#
# if [ -d *DTI_pe1_g79 ]
# then
#   echo "DTI AP g79 found in session $session, copying..."
#   cd "$(find . -name *DTI_pe0_g79 -type d)"
#   cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_AP.nii.gz
#
#   # Reading bvals and bvecs, discarding the ones from calibration volumes.
#   bvals=`cat *bval`
#   bvals="${bvals//.0}" #FSL doesn't accept decimals
#   arr=($bvals)
#   echo "${arr[@]: -79}">${path_of_raw_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_AP.bval
#
#   index=0; while read line; do myArray[index]="$line"; ((index++)); done<*.bvec
#   row0=${myArray[0]}
#   row1=${myArray[1]}
#   row2=${myArray[2]}
#   echo -e ${row0[@]: -79}"\n"${row1[@]: -79}"\n"${row2[@]: -79}>${path_of_raw_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_AP.bvec
#
#   echo "Cutting first two calibration volumes"
#   fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_AP.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/Diffusion/${subject}_3T_DWI_dir79_AP.nii.gz 2 -1
#   cd "${path_of_raw_folder}/${subject}_p${session}"
# fi

# Find fieldmaps
if [ -d *fieldmap_pe0 ]
then
  echo "Fieldmaps found in session $session."
  cd "$(find . -name *fieldmap_pe0 -type d)"
  fmapPA="$PWD/*.nii.gz"
  echo ${fmapPA}
  cd "${path_of_raw_folder}/${subject}_p${session}"
  cd "$(find . -name *fieldmap_pe1 -type d)"
  fmapAP="$PWD/*.nii.gz"
  cd "${path_of_raw_folder}/${subject}_p${session}"
else
  echo "No fieldmaps in this session. fMRI processing impossible for HCP, skipping to next session."
  continue
fi

# Find rest AP
if [ -d *rsFmri24_pe1_ssg ]
then
  echo "Rest run AP found in session $session, copying..."
  cd "$(find . -name *rsFmri24_pe1_ssg* -type d)"
  mkdir ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_AP
  cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_AP/${subject}_3T_rfMRI_REST${session}_AP.nii.gz
  echo "Cutting first two volumes..."
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_AP/${subject}_3T_rfMRI_REST${session}_AP.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_AP/${subject}_3T_rfMRI_REST${session}_AP.nii.gz 2 -1
  echo "Copying and cutting fieldmaps..."
  cp $fmapPA ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_AP/${subject}_3T_SpinEchoFieldMap_PA.nii.gz
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_AP/${subject}_3T_SpinEchoFieldMap_PA.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_AP/${subject}_3T_SpinEchoFieldMap_PA.nii.gz 3 3
  cp $fmapAP ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_AP/${subject}_3T_SpinEchoFieldMap_AP.nii.gz
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_AP/${subject}_3T_SpinEchoFieldMap_AP.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_AP/${subject}_3T_SpinEchoFieldMap_AP.nii.gz 3 3
  cd "${path_of_raw_folder}/${subject}_p${session}"

  # Find sbref
  s="$(find $PWD -type d -name '*rsFmri24_pe1_ssg*' | awk -F/ '{print $NF}')"
  fmri_prefix=(${s//_/ })
  sbref_prefix="$(($fmri_prefix - 1))"
  sbref_prefix_2="$(($fmri_prefix - 2))"
  if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (1 folder before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
  cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_AP/${subject}_3T_rfMRI_REST${session}_AP_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_AP/${subject}_3T_rfMRI_REST${session}_AP_SBRef.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_AP/${subject}_3T_rfMRI_REST${session}_AP_SBRef.nii.gz 3 3
  cd "${path_of_raw_folder}/${subject}_p${session}"
  elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (2 folders before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
  cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_AP/${subject}_3T_rfMRI_REST${session}_AP_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_AP/${subject}_3T_rfMRI_REST${session}_AP_SBRef.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_AP/${subject}_3T_rfMRI_REST${session}_AP_SBRef.nii.gz 3 3
  cd "${path_of_raw_folder}/${subject}_p${session}"
  fi
fi

# Find rest PA
if [ -d *rsFmri24_pe0_ssg ]
then
  echo "Rest run PA found in session $session, copying..."
  cd "$(find . -name *rsFmri24_pe0_ssg* -type d)"
  mkdir ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_PA
  cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_rfMRI_REST${session}_PA.nii.gz
  echo "Cutting first two volumes..."
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_rfMRI_REST${session}_PA.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_rfMRI_REST${session}_PA.nii.gz 2 -1
  echo "Copying and cutting fieldmaps..."
  cp $fmapPA ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz 3 3
  cp $fmapAP ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz 3 3
  cd "${path_of_raw_folder}/${subject}_p${session}"

  # Find sbref
  s="$(find $PWD -type d -name '*rsFmri24_pe0_ssg*' | awk -F/ '{print $NF}')"
  fmri_prefix=(${s//_/ })
  sbref_prefix="$(($fmri_prefix - 1))"
  sbref_prefix_2="$(($fmri_prefix - 2))"
  if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (1 folder before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
  cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_rfMRI_REST${session}_PA_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_rfMRI_REST${session}_PA_SBRef.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_rfMRI_REST${session}_PA_SBRef.nii.gz 3 3
  cd "${path_of_raw_folder}/${subject}_p${session}"
  elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (2 folders before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
  cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_rfMRI_REST${session}_PA_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_rfMRI_REST${session}_PA_SBRef.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/rfMRI_REST${session}_PA/${subject}_3T_rfMRI_REST${session}_PA_SBRef.nii.gz 3 3
  cd "${path_of_raw_folder}/${subject}_p${session}"
  fi
fi

# Find emotion PA
if [ -d *tFmri_Emotion_pe0_ssg ]
then
  echo "Rest run AP found in session $session, copying..."
  cd "$(find . -name *tFmri_Emotion_pe0_ssg* -type d)"
  mkdir ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_EMOTION_PA
  cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA.nii.gz
  echo "Cutting first two volumes..."
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA.nii.gz 2 -1
  echo "Copying and cutting fieldmaps..."
  cp $fmapPA ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz 3 3
  cp $fmapAP ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz 3 3
  cd "${path_of_raw_folder}/${subject}_p${session}"

  # Find sbref
  s="$(find $PWD -type d -name '*tFmri_Emotion_pe0_ssg*' | awk -F/ '{print $NF}')"
  fmri_prefix=(${s//_/ })
  sbref_prefix="$(($fmri_prefix - 1))"
  sbref_prefix_2="$(($fmri_prefix - 2))"
  if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (1 folder before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
  cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA_SBRef.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA_SBRef.nii.gz 3 3
  cd "${path_of_raw_folder}/${subject}_p${session}"
  elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (2 folders before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
  cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA_SBRef.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_EMOTION_PA/${subject}_3T_tfMRI_EMOTION_PA_SBRef.nii.gz 3 3
  cd "${path_of_raw_folder}/${subject}_p${session}"
  fi
fi

# Find gambling PA
if [ -d *tFmri_Gambling_pe0_ssg ]
then
  echo "Rest run AP found in session $session, copying..."
  cd "$(find . -name *tFmri_Gambling_pe0_ssg* -type d)"
  mkdir ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_GAMBLING_PA
  cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA.nii.gz
  echo "Cutting first two volumes..."
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA.nii.gz 2 -1
  echo "Copying and cutting fieldmaps..."
  cp $fmapPA ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz 3 3
  cp $fmapAP ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz 3 3
  cd "${path_of_raw_folder}/${subject}_p${session}"

  # Find sbref
  s="$(find $PWD -type d -name '*tFmri_Gambling_pe0_ssg*' | awk -F/ '{print $NF}')"
  fmri_prefix=(${s//_/ })
  sbref_prefix="$(($fmri_prefix - 1))"
  sbref_prefix_2="$(($fmri_prefix - 2))"
  if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (1 folder before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
  cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz 3 3
  cd "${path_of_raw_folder}/${subject}_p${session}"
  elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (2 folders before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
  cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/${subject}_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz 3 3
  cd "${path_of_raw_folder}/${subject}_p${session}"
  fi
fi

# Find WM PA
if [ -d *tFmri_WM_pe0_ssg ]
then
  echo "Rest run AP found in session $session, copying..."
  cd "$(find . -name *tFmri_WM_pe0_ssg* -type d)"
  mkdir ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_WM_PA
  cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA.nii.gz
  echo "Cutting first two volumes..."
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA.nii.gz 2 -1
  echo "Copying and cutting fieldmaps..."
  cp $fmapPA ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_SpinEchoFieldMap_PA.nii.gz 3 3
  cp $fmapAP ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_SpinEchoFieldMap_AP.nii.gz 3 3
  cd "${path_of_raw_folder}/${subject}_p${session}"

  # Find sbref
  s="$(find $PWD -type d -name '*tFmri_WM_pe0_ssg*' | awk -F/ '{print $NF}')"
  fmri_prefix=(${s//_/ })
  sbref_prefix="$(($fmri_prefix - 1))"
  sbref_prefix_2="$(($fmri_prefix - 2))"
  if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (1 folder before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
  cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA_SBRef.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA_SBRef.nii.gz 3 3
  cd "${path_of_raw_folder}/${subject}_p${session}"
  elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (2 folders before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
  cp *.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA_SBRef.nii.gz
  echo  "Cutting SbRef..."
  fslroi ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA_SBRef.nii.gz ${path_of_destination_folder}/${subject}_hcp/unprocessed/3T/tfMRI_WM_PA/${subject}_3T_tfMRI_WM_PA_SBRef.nii.gz 3 3
  cd "${path_of_raw_folder}/${subject}_p${session}"
  fi
fi


fi
done
