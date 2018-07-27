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

# Setting the bvals and bvecs for diffusion to fix the inconsistent bvals/bvecs from CNI

bvals81='3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 0 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 0 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 0 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 0 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 0'
bvecs81='-0.3741 -0.3741 0.9615 -0.9615 -0.4274 0.4274 -0.2811 -0.2811 -0.3215 0.3215 0.4633 -0.4633 -0.1112 -0.1112 0.0000 0.4194 -0.4194 0.2093 0.2093 -0.1581 -0.1581 -0.7972 0.7972 0.5965 0.5965 0.7244 -0.7244 0.0155 -0.0155 0.0000 -0.4715 -0.4715 -0.3189 -0.3189 0.8012 0.8012 0.1640 -0.1640 0.1218 -0.1218 0.6417 -0.6417 -0.9708 -0.9708 -0.6723 0.6723 0.0000 0.7159 0.7159 -0.3304 0.3304 -0.8897 -0.8897 -0.4652 0.4652 0.5550 0.5550 0.5132 0.5132 0.7193 0.7193 0.0000 0.9902 0.9902 -0.7199 -0.7199 0.5951 -0.5951 0.6139 -0.6139 0.4711 -0.4711 0.8451 0.8451 0.2040 -0.2040 -0.9823 -0.9823 0.0000
0.0000 0.5614 -0.5614 0.9267 0.9267 -0.2277 0.2277 -0.5931 0.5931 -0.8694 -0.8694 0.8365 -0.8365 -0.3121 0.3121 -0.2639 -0.2639 0.0000 0.2995 -0.2995 -0.9568 -0.9568 -0.2723 -0.2723 0.4015 -0.4015 -0.4227 -0.4227 0.6587 -0.6587 -0.8925 0.8925 0.0000 0.2124 0.2124 -0.5069 -0.5069 0.1302 0.1302 -0.7789 0.7789 -0.7209 0.7209 0.3738 -0.3738 -0.0550 -0.0550 0.7394 -0.7394 0.0000 -0.6098 -0.6098 -0.8158 0.8158 -0.4393 -0.4393 -0.6652 0.6652 0.7679 0.7679 -0.8172 -0.8172 -0.2125 -0.2125 0.0000 -0.0855 -0.0855 -0.1275 -0.1275 0.0672 -0.0672 -0.6528 0.6528 0.8506 -0.8506 0.2626 0.2626 0.5076 -0.5076 -0.1854 -0.1854 0.0000
0.0000 0.7486 -0.7486 0.0354 0.0354 -0.1540 0.1540 -0.6823 0.6823 0.4064 0.4064 -0.4438 0.4438 -0.8294 0.8294 -0.9581 -0.9581 0.0000 0.8570 -0.8570 0.2018 0.2018 0.9491 0.9491 -0.4509 0.4509 0.6823 0.6823 0.2036 -0.2036 0.4509 -0.4509 0.0000 -0.8559 -0.8559 0.8008 0.8008 0.5840 0.5840 -0.6054 0.6054 0.6823 -0.6823 0.6697 -0.6697 0.2336 0.2336 0.0354 -0.0354 0.0000 -0.3401 -0.3401 -0.4747 0.4747 -0.1247 -0.1247 0.5840 -0.5840 -0.3199 -0.3199 -0.2624 -0.2624 -0.6614 -0.6614 0.0000 0.1106 0.1106 0.6823 0.6823 0.8008 -0.8008 0.4438 -0.4438 0.2336 -0.2336 -0.4656 -0.4656 0.8371 -0.8371 -0.0255 -0.0255 0.0000'
bvals79='3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 0 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 0 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 0 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 0 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 3000 1500 0'
bvecs79='-0.7710 -0.7710 0.2124 -0.2124 0.2385 -0.2385 0.0530 -0.0530 0.3529 -0.3529 0.0000 0.0000 0.0000 0.7266 -0.7266 -0.9327 0.9327 -0.1209 0.1209 0.4519 -0.4519 0.6304 -0.6304 -0.1854 -0.1854 -0.4531 -0.4531 0.6153 0.6153 0.0000 -0.9200 -0.9200 0.4057 0.4057 0.7347 0.7347 0.6035 0.6035 0.0799 -0.0799 0.9052 0.9052 -0.2860 -0.2860 0.0000 -0.2919 0.2919 0.5197 -0.5197 0.0777 0.0777 0.1549 -0.1549 0.8036 0.8036 -0.5936 0.5936 0.9079 0.9079 0.0134 0.0134 0.0000 0.3140 0.3140 -0.8470 -0.8470 -0.7820 0.7820 -0.8783 -0.8783 -0.1737 0.1737 0.0800 -0.0800 0.5458 0.5458 0.0000
0.0000 0.5008 -0.5008 0.6040 0.6040 0.9650 -0.9650 -0.9097 0.9097 0.9148 -0.9148 0.9291 -0.9291 0.0000 0.0000 0.0000 0.5419 -0.5419 -0.1665 0.1665 -0.7402 0.7402 0.2477 -0.2477 -0.4859 0.4859 0.2952 0.2952 0.7214 0.7214 0.4157 0.4157 0.0000 0.3546 0.3546 -0.6460 -0.6460 -0.1613 -0.1613 0.6473 0.6473 -0.5528 0.5528 -0.1242 -0.1242 0.0145 0.0145 0.0000 0.4648 -0.4648 -0.8274 0.8274 -0.9922 -0.9922 -0.2466 0.2466 0.4193 0.4193 -0.8044 0.8044 0.3665 0.3665 0.5170 0.5170 0.0000 0.0242 0.0242 0.3495 0.3495 -0.6107 0.6107 0.0566 0.0566 -0.7318 0.7318 0.9828 -0.9828 -0.0366 -0.0366 0.0000
0.0000 0.0980 -0.0980 -0.2018 -0.2018 0.1540 -0.1540 -0.3401 0.3401 0.4004 -0.4004 -0.1106 0.1106 1.0000 -1.0000 0.0000 -0.4224 0.4224 -0.3199 0.3199 -0.6614 0.6614 -0.8570 0.8570 -0.6054 0.6054 0.9373 0.9373 0.5237 0.5237 -0.6697 -0.6697 0.0000 -0.1667 -0.1667 0.6466 0.6466 0.6590 0.6590 0.4656 0.4656 -0.8294 0.8294 0.4064 0.4064 0.9581 0.9581 0.0000 -0.8359 0.8359 0.2127 -0.2127 -0.0980 -0.0980 0.9566 -0.9566 0.4224 0.4224 0.0255 -0.0255 -0.2036 -0.2036 -0.8559 -0.8559 0.0000 0.9491 0.9491 0.4004 0.4004 0.1247 -0.1247 0.4747 0.4747 0.6590 -0.6590 -0.1667 0.1667 -0.8371 -0.8371 0.0000'

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
  echo $bvals81>$origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_PA.bval
  echo $bvecs81>$origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_PA.bvec
  echo "Cutting first two calibration volumes"
  fslroi $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_PA.nii.gz $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_PA.nii.gz 2 -1
  cd ..
fi

if [ -d *DTI_pe0_g79 ]
then
  echo "DTI PA g79 found in session $session, copying..."
  cd "$(find . -name *DTI_pe0_g79 -type d)"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_PA.nii.gz
  echo $bvals79>$origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_PA.bval
  echo $bvecs79>$origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_PA.bvec
  echo "Cutting first two calibration volumes"
  fslroi $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_PA.nii.gz $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_PA.nii.gz 2 -1
  cd ..
fi

if [ -d *DTI_pe1_g81 ]
then
  echo "DTI AP g81 found in session $session, copying..."
  cd "$(find . -name *DTI_pe1_g81 -type d)"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_AP.nii.gz
  echo $bvals81>$origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_AP.bval
  echo $bvecs81>$origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_AP.bvec
  echo "Cutting first two calibration volumes"
  fslroi $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_AP.nii.gz $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir81_AP.nii.gz 2 -1
  cd ..
fi

if [ -d *DTI_pe1_g79 ]
then
  echo "DTI AP g79 found in session $session, copying..."
  cd "$(find . -name *DTI_pe0_g79 -type d)"
  cp *.nii.gz $origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_AP.nii.gz
  echo $bvals79>$origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_AP.bval
  echo $bvecs79>$origdir/$1_hcp/unprocessed/3T/Diffusion/$1_3T_DWI_dir79_AP.bvec
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
