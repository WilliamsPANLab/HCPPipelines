# Script looks for subject with ID given as argument in the current directory. It goes through all the sessions, but skips fMRI data from sessions without a fieldmap (it is required for preprocessing)

origdir=$PWD
mkdir $1_hcp
mkdir $origdir/$1_hcp/unprocessed
mkdir $origdir/$1_hcp/unprocessed/3T

echo "Runnning subject $1"

for session in 1 2 3 4 #usually there are less than 5 sessions
do
cd "$origdir"
if [ -d "$1_p${session}" ]
then

echo "Found session $session"

cd "$1_p${session}"

# Find T1
if [ -d *T1w_MPRAGE_PROMO ]
then
  mkdir $origdir/$1_hcp/unprocessed/3T/T1w_MPR1
  echo "T1 found in session $session, copying..."
  cd "$(find . -name *T1w_MPRAGE_PROMO -type d)"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/T1w_MPR1/$1_3T_T1w_MPR1.nii.gz
  cd ..
fi


# Find T2
if [ -d *T2w_CUBE_PROMO_8mm_sag ]
then
  mkdir $origdir/$1_hcp/unprocessed/3T/T2w_SPC1
  echo "T2 found in session $session, copying..."
  cd "$(find . -name *T2w_CUBE_PROMO_8mm_sag -type d)"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/T2w_SPC1/$1_3T_T2w_SPC1.nii.gz
  cd ..
fi


# Find DWI
if [ -d *DTI_pe0_g81 ]
then
  mkdir $origdir/$1_hcp/unprocessed/3T/Diffusion
  echo "DTI PA g81 found in session $session, copying..."
  cd "$(find . -name *DTI_pe0_g81 -type d)"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_PA.nii.gz
  
  # Reading bvals and bvecs, discarding the ones from calibration volumes. 
  bvals=`cat *bval`  
  bvals="${bvals//.0}" #FSL doesn't accept decimals
  arr=($bvals)
  echo "${arr[@]: -81}">$origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_PA.bval
  
  index=0; while read line; do myArray[index]="$line"; ((index++)); done<*.bvec
  row0=${myArray[0]}
  row1=${myArray[1]}
  row2=${myArray[2]}
  echo -e ${row0[@]: -81}"\n"${row1[@]: -81}"\n"${row2[@]: -81}>$origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_PA.bvec
  
  echo "Cutting first two calibration volumes"
  fslroi $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_PA.nii.gz $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_PA.nii.gz 2 -1
  cd ..
fi

if [ -d *DTI_pe0_g79 ]
then
  echo "DTI PA g79 found in session $session, copying..."
  cd "$(find . -name *DTI_pe0_g79 -type d)"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_PA.nii.gz
  
  # Reading bvals and bvecs, discarding the ones from calibration volumes. 
  bvals=`cat *bval`  
  bvals="${bvals//.0}" #FSL doesn't accept decimals
  arr=($bvals)
  echo "${arr[@]: -79}">$origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_PA.bval
  
  index=0; while read line; do myArray[index]="$line"; ((index++)); done<*.bvec
  row0=${myArray[0]}
  row1=${myArray[1]}
  row2=${myArray[2]}
  echo -e ${row0[@]: -79}"\n"${row1[@]: -79}"\n"${row2[@]: -79}>$origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_PA.bvec  
  
  echo "Cutting first two calibration volumes"
  fslroi $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_PA.nii.gz $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_PA.nii.gz 2 -1
  cd ..
fi

if [ -d *DTI_pe1_g81 ]
then
  echo "DTI AP g81 found in session $session, copying..."
  cd "$(find . -name *DTI_pe1_g81 -type d)"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_AP.nii.gz

  # Reading bvals and bvecs, discarding the ones from calibration volumes. 
  bvals=`cat *bval`  
  bvals="${bvals//.0}" #FSL doesn't accept decimals
  arr=($bvals)
  echo "${arr[@]: -81}">>$origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_AP.bval
  
  index=0; while read line; do myArray[index]="$line"; ((index++)); done<*.bvec
  row0=${myArray[0]}
  row1=${myArray[1]}
  row2=${myArray[2]}
  echo -e ${row0[@]: -81}"\n"${row1[@]: -81}"\n"${row2[@]: -81}>$origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_AP.bvec
  
  echo "Cutting first two calibration volumes"
  fslroi $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_AP.nii.gz $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_AP.nii.gz 2 -1
  cd ..
fi

if [ -d *DTI_pe1_g79 ]
then
  echo "DTI AP g79 found in session $session, copying..."
  cd "$(find . -name *DTI_pe0_g79 -type d)"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_AP.nii.gz

  # Reading bvals and bvecs, discarding the ones from calibration volumes. 
  bvals=`cat *bval`  
  bvals="${bvals//.0}" #FSL doesn't accept decimals
  arr=($bvals)
  echo "${arr[@]: -79}">$origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_AP.bval
  
  index=0; while read line; do myArray[index]="$line"; ((index++)); done<*.bvec
  row0=${myArray[0]}
  row1=${myArray[1]}
  row2=${myArray[2]}
  echo -e ${row0[@]: -79}"\n"${row1[@]: -79}"\n"${row2[@]: -79}>$origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_PA.bvec  

  echo "Cutting first two calibration volumes"
  fslroi $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_AP.nii.gz $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_AP.nii.gz 2 -1
  cd ..
fi

# Find fieldmaps
if [ -d *fieldmap_pe0 ]
then
  echo "Fieldmaps found in session $session."
  cd "$(find . -name *fieldmap_pe0 -type d)"
  fmapPA="$PWD/*.nii.gz"
  cd ..
  cd "$(find . -name *fieldmap_pe1 -type d)"
  fmapAP="$PWD/*.nii.gz"
  cd ..
else
  echo "No fieldmaps in this session. fMRI processing impossible for HCP, skipping to next session."
  continue
fi

# Find rest AP
if [ -d *rsFmri24_pe1 ]
then
  echo "Rest run AP found in session $session, copying..."
  cd "$(find . -name *rsFmri24_pe1* -type d)"
  mkdir $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_AP
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_AP/$1_3T_rfMRI_REST${session}_AP.nii.gz
  echo "Cutting first two volumes..."
  fslroi $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_AP/$1_3T_rfMRI_REST${session}_AP.nii.gz $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_AP/$1_3T_rfMRI_REST${session}_AP.nii.gz 2 -1
  echo "Copying and cutting fieldmaps..."
  cp $fmapPA $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_AP/$1_3T_SpinEchoFieldMap_PA.nii.gz
  fslroi $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_AP/$1_3T_SpinEchoFieldMap_PA.nii.gz $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_AP/$1_3T_SpinEchoFieldMap_PA.nii.gz 3 3
  cp $fmapAP $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_AP/$1_3T_SpinEchoFieldMap_AP.nii.gz
  fslroi $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_AP/$1_3T_SpinEchoFieldMap_AP.nii.gz $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_AP/$1_3T_SpinEchoFieldMap_AP.nii.gz 3 3
  cd ..

  # Find sbref
  s="$(find $PWD -type d -name '*rsFmri24_pe1*' | awk -F/ '{print $NF}')"
  fmri_prefix=(${s//_/ })
  sbref_prefix="$(($fmri_prefix - 1))"
  sbref_prefix_2="$(($fmri_prefix - 2))"
  if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (1 folder before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_AP/$1_3T_rfMRI_REST${session}_AP_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_AP/$1_3T_rfMRI_REST${session}_AP_SBRef.nii.gz $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_AP/$1_3T_rfMRI_REST${session}_AP_SBRef.nii.gz 3 3
  cd ..
  elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (2 folders before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_AP/$1_3T_rfMRI_REST${session}_AP_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_AP/$1_3T_rfMRI_REST${session}_AP_SBRef.nii.gz $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_AP/$1_3T_rfMRI_REST${session}_AP_SBRef.nii.gz 3 3
  cd ..
  fi
fi

# Find rest PA
if [ -d *rsFmri24_pe0 ]
then
  echo "Rest run PA found in session $session, copying..."
  cd "$(find . -name *rsFmri24_pe0* -type d)"
  mkdir $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_PA
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_PA/$1_3T_rfMRI_REST${session}_PA.nii.gz
  echo "Cutting first two volumes..."
  fslroi $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_PA/$1_3T_rfMRI_REST${session}_PA.nii.gz $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_PA/$1_3T_rfMRI_REST${session}_PA.nii.gz 2 -1
  echo "Copying and cutting fieldmaps..."
  cp $fmapPA $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_PA/$1_3T_SpinEchoFieldMap_PA.nii.gz
  fslroi $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_PA/$1_3T_SpinEchoFieldMap_PA.nii.gz $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_PA/$1_3T_SpinEchoFieldMap_PA.nii.gz 3 3
  cp $fmapAP $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_PA/$1_3T_SpinEchoFieldMap_AP.nii.gz
  fslroi $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_PA/$1_3T_SpinEchoFieldMap_AP.nii.gz $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_PA/$1_3T_SpinEchoFieldMap_AP.nii.gz 3 3
  cd ..

  # Find sbref
  s="$(find $PWD -type d -name '*rsFmri24_pe0*' | awk -F/ '{print $NF}')"
  fmri_prefix=(${s//_/ })
  sbref_prefix="$(($fmri_prefix - 1))"
  sbref_prefix_2="$(($fmri_prefix - 2))"
  if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (1 folder before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_PA/$1_3T_rfMRI_REST${session}_PA_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_PA/$1_3T_rfMRI_REST${session}_PA_SBRef.nii.gz $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_PA/$1_3T_rfMRI_REST${session}_PA_SBRef.nii.gz 3 3
  cd ..
  elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (2 folders before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_PA/$1_3T_rfMRI_REST${session}_PA_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_PA/$1_3T_rfMRI_REST${session}_PA_SBRef.nii.gz $origdir/$1_hcp/unprocessed/3T/rfMRI_REST${session}_PA/$1_3T_rfMRI_REST${session}_PA_SBRef.nii.gz 3 3
  cd ..
  fi
fi

# Find emotion PA
if [ -d *tFmri_Emotion_pe0 ]
then
  echo "Rest run AP found in session $session, copying..."
  cd "$(find . -name *tFmri_Emotion_pe0* -type d)"
  mkdir $origdir/$1_hcp/unprocessed/3T/tfMRI_EMOTION_PA
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_EMOTION_PA/$1_3T_tfMRI_EMOTION_PA.nii.gz
  echo "Cutting first two volumes..."
  fslroi $origdir/$1_hcp/unprocessed/3T/tfMRI_EMOTION_PA/$1_3T_tfMRI_EMOTION_PA.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_EMOTION_PA/$1_3T_tfMRI_EMOTION_PA.nii.gz 2 -1
  echo "Copying and cutting fieldmaps..."
  cp $fmapPA $origdir/$1_hcp/unprocessed/3T/tfMRI_EMOTION_PA/$1_3T_SpinEchoFieldMap_PA.nii.gz
  fslroi $origdir/$1_hcp/unprocessed/3T/tfMRI_EMOTION_PA/$1_3T_SpinEchoFieldMap_PA.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_EMOTION_PA/$1_3T_SpinEchoFieldMap_PA.nii.gz 3 3
  cp $fmapAP $origdir/$1_hcp/unprocessed/3T/tfMRI_EMOTION_PA/$1_3T_SpinEchoFieldMap_AP.nii.gz
  fslroi $origdir/$1_hcp/unprocessed/3T/tfMRI_EMOTION_PA/$1_3T_SpinEchoFieldMap_AP.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_EMOTION_PA/$1_3T_SpinEchoFieldMap_AP.nii.gz 3 3
  cd ..

  # Find sbref
  s="$(find $PWD -type d -name '*tFmri_Emotion_pe0*' | awk -F/ '{print $NF}')"
  fmri_prefix=(${s//_/ })
  sbref_prefix="$(($fmri_prefix - 1))"
  sbref_prefix_2="$(($fmri_prefix - 2))"
  if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (1 folder before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_EMOTION_PA/$1_3T_tfMRI_EMOTION_PA_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi $origdir/$1_hcp/unprocessed/3T/tfMRI_EMOTION_PA/$1_3T_tfMRI_EMOTION_PA_SBRef.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_EMOTION_PA/$1_3T_tfMRI_EMOTION_PA_SBRef.nii.gz 3 3
  cd ..
  elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (2 folders before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_EMOTION_PA/$1_3T_tfMRI_EMOTION_PA_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi $origdir/$1_hcp/unprocessed/3T/tfMRI_EMOTION_PA/$1_3T_tfMRI_EMOTION_PA_SBRef.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_EMOTION_PA/$1_3T_tfMRI_EMOTION_PA_SBRef.nii.gz 3 3
  cd ..
  fi
fi

# Find gambling PA
if [ -d *tFmri_Gambling_pe0 ]
then
  echo "Rest run AP found in session $session, copying..."
  cd "$(find . -name *tFmri_Gambling_pe0* -type d)"
  mkdir $origdir/$1_hcp/unprocessed/3T/tfMRI_GAMBLING_PA
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/$1_3T_tfMRI_GAMBLING_PA.nii.gz
  echo "Cutting first two volumes..."
  fslroi $origdir/$1_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/$1_3T_tfMRI_GAMBLING_PA.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/$1_3T_tfMRI_GAMBLING_PA.nii.gz 2 -1
  echo "Copying and cutting fieldmaps..."
  cp $fmapPA $origdir/$1_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/$1_3T_SpinEchoFieldMap_PA.nii.gz
  fslroi $origdir/$1_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/$1_3T_SpinEchoFieldMap_PA.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/$1_3T_SpinEchoFieldMap_PA.nii.gz 3 3
  cp $fmapAP $origdir/$1_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/$1_3T_SpinEchoFieldMap_AP.nii.gz
  fslroi $origdir/$1_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/$1_3T_SpinEchoFieldMap_AP.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/$1_3T_SpinEchoFieldMap_AP.nii.gz 3 3
  cd ..

  # Find sbref
  s="$(find $PWD -type d -name '*tFmri_Gambling_pe0*' | awk -F/ '{print $NF}')"
  fmri_prefix=(${s//_/ })
  sbref_prefix="$(($fmri_prefix - 1))"
  sbref_prefix_2="$(($fmri_prefix - 2))"
  if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (1 folder before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/$1_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi $origdir/$1_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/$1_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/$1_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz 3 3
  cd ..
  elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (2 folders before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/$1_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi $origdir/$1_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/$1_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_GAMBLING_PA/$1_3T_tfMRI_GAMBLING_PA_SBRef.nii.gz 3 3
  cd ..
  fi
fi

# Find WM PA
if [ -d *tFmri_WM_pe0 ]
then
  echo "Rest run AP found in session $session, copying..."
  cd "$(find . -name *tFmri_WM_pe0* -type d)"
  mkdir $origdir/$1_hcp/unprocessed/3T/tfMRI_WM_PA
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_WM_PA/$1_3T_tfMRI_WM_PA.nii.gz
  echo "Cutting first two volumes..."
  fslroi $origdir/$1_hcp/unprocessed/3T/tfMRI_WM_PA/$1_3T_tfMRI_WM_PA.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_WM_PA/$1_3T_tfMRI_WM_PA.nii.gz 2 -1
  echo "Copying and cutting fieldmaps..."
  cp $fmapPA $origdir/$1_hcp/unprocessed/3T/tfMRI_WM_PA/$1_3T_SpinEchoFieldMap_PA.nii.gz
  fslroi $origdir/$1_hcp/unprocessed/3T/tfMRI_WM_PA/$1_3T_SpinEchoFieldMap_PA.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_WM_PA/$1_3T_SpinEchoFieldMap_PA.nii.gz 3 3
  cp $fmapAP $origdir/$1_hcp/unprocessed/3T/tfMRI_WM_PA/$1_3T_SpinEchoFieldMap_AP.nii.gz
  fslroi $origdir/$1_hcp/unprocessed/3T/tfMRI_WM_PA/$1_3T_SpinEchoFieldMap_AP.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_WM_PA/$1_3T_SpinEchoFieldMap_AP.nii.gz 3 3
  cd ..

  # Find sbref
  s="$(find $PWD -type d -name '*tFmri_WM_pe0*' | awk -F/ '{print $NF}')"
  fmri_prefix=(${s//_/ })
  sbref_prefix="$(($fmri_prefix - 1))"
  sbref_prefix_2="$(($fmri_prefix - 2))"
  if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (1 folder before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_WM_PA/$1_3T_tfMRI_WM_PA_SBRef.nii.gz
  echo "Cutting SbRef..."
  fslroi $origdir/$1_hcp/unprocessed/3T/tfMRI_WM_PA/$1_3T_tfMRI_WM_PA_SBRef.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_WM_PA/$1_3T_tfMRI_WM_PA_SBRef.nii.gz 3 3
  cd ..
  elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
  then
  echo "Found SBref (2 folders before this acquisition), copying..."
  cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_WM_PA/$1_3T_tfMRI_WM_PA_SBRef.nii.gz
  echo  "Cutting SbRef..."
  fslroi $origdir/$1_hcp/unprocessed/3T/tfMRI_WM_PA/$1_3T_tfMRI_WM_PA_SBRef.nii.gz $origdir/$1_hcp/unprocessed/3T/tfMRI_WM_PA/$1_3T_tfMRI_WM_PA_SBRef.nii.gz 3 3
  cd ..
  fi
fi


fi
done
