#!/bin/bash

for subject_cap in CONN136 CONN134 CONN133 CONN138

do
  subject="$(echo ${subject_cap} | awk '{print tolower($0)}')"
  echo ${subject}
  mkdir /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}


  ### Folders that are normally in second session 1
  if [ -d /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p1 ]
  then
    cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p1
    rsync -rv $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}
    Resting pe0 and SB Ref
    if [ -d *rsFmri24_pe0_ssg ]
    then
        # Get fmri_prefix
        s="$(find $PWD -type d -name '*rsFmri24_pe0_ssg*' | awk -F/ '{print $NF}')"
        echo ${s}
        fmri_prefix="$(echo $s | cut -d "_" -f 1)"
        echo ${fmri_prefix}
        sbref_prefix="$(($fmri_prefix - 1))"
        sbref_prefix_2="$(($fmri_prefix - 2))"
        #Resting State
        cd "$(find . -name *rsFmri24_pe0_ssg* -type d)"
        rsync -rv $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${fmri_prefix}_1_rsFmri24_1_pe0_ssg
        cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p1
        #Sbref
        if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
        then
          echo "Found SBref (1 folder before this acquisition), copying..."
          cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
          rsync -rv $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${sbref_prefix}_1_BOLD_SB_ref_RS_1
          cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p1
        elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
        then
          echo "Found SBref (2 folders before this acquisition), copying..."
          cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
          rsync -rv $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${sbref_prefix_2}_1_BOLD_SB_ref_RS_1
          cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p1
        fi
        cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p1
    fi
    # Resting pe1
    if [ -d *rsFmri24_pe1_ssg ]
    then
        # Get fmri_prefix
        s="$(find $PWD -type d -name '*rsFmri24_pe1_ssg*' | awk -F/ '{print $NF}')"
        echo ${s}
        fmri_prefix="$(echo $s | cut -d "_" -f 1)"
        sbref_prefix="$(($fmri_prefix - 1))"
        sbref_prefix_2="$(($fmri_prefix - 2))"
        #Resting State
        cd "$(find . -name *rsFmri24_pe1_ssg* -type d)"
        rsync -rav $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${fmri_prefix}_1_rsFmri24_1_pe1_ssg
        cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p1
    fi
    #Fieldmaps
    if [ -d *fieldmap_pe0 ]
    then
        s="$(find $PWD -type d -name '*fieldmap_pe0' | awk -F/ '{print $NF}')"
        echo ${s}
        fmri_prefix="$(echo $s | cut -d "_" -f 1)"
        sbref_prefix="$(($fmri_prefix - 1))"
        sbref_prefix_2="$(($fmri_prefix - 2))"
        cd "$(find . -name *fieldmap_pe0 -type d)"
        rsync -rav $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${fmri_prefix}_1_SE_fieldmap_1_pe0
        cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p1
    fi
    if [ -d *fieldmap_pe1 ]
    then
        s="$(find $PWD -type d -name '*fieldmap_pe1' | awk -F/ '{print $NF}')"
        fmri_prefix="$(echo $s | cut -d "_" -f 1)"
        echo ${fmri_prefix}
        sbref_prefix="$(($fmri_prefix - 1))"
        sbref_prefix_2="$(($fmri_prefix - 2))"
        cd "$(find . -name *fieldmap_pe1 -type d)"
        rsync -rav $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${fmri_prefix}_1_SE_fieldmap_1_pe1
        cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p1
    fi
    # Emotion SBref
    if [ -d *tFmri_Emotion_pe0_ssg ]
    then
        # Get fmri_prefix
        s="$(find $PWD -type d -name '*tFmri_Emotion_pe0_ssg' | awk -F/ '{print $NF}')"
        echo ${s}
        fmri_prefix="$(echo $s | cut -d "_" -f 1)"
        echo ${fmri_prefix}
        sbref_prefix="$(($fmri_prefix - 1))"
        sbref_prefix_2="$(($fmri_prefix - 2))"
        #Sbref
        if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
        then
          echo "Found SBref (1 folder before this acquisition), copying..."
          cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
          rsync -rv $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${sbref_prefix}_1_BOLD_SB_ref_Emo
          cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p1
        elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
        then
          echo "Found SBref (2 folders before this acquisition), copying..."
          cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
          rsync -rv $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${sbref_prefix_2}_1_BOLD_SB_ref_Emo
          cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p1
        fi
    fi
    # Gambling SBref
    if [ -d *tFmri_Gambling_pe0_ssg ]
    then
        # Get fmri_prefix
        s="$(find $PWD -type d -name '*tFmri_Gambling_pe0_ssg' | awk -F/ '{print $NF}')"
        echo ${s}
        fmri_prefix="$(echo $s | cut -d "_" -f 1)"
        echo ${fmri_prefix}
        sbref_prefix="$(($fmri_prefix - 1))"
        sbref_prefix_2="$(($fmri_prefix - 2))"
        #Sbref
        if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
        then
          echo "Found SBref (1 folder before this acquisition), copying..."
          cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
          rsync -rv $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${sbref_prefix}_1_BOLD_SB_ref_Gambl
          cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p1
        elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
        then
          echo "Found SBref (2 folders before this acquisition), copying..."
          cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
          rsync -rv $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${sbref_prefix_2}_1_BOLD_SB_ref_Gambl
          cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p1
        fi
    fi

    # WM SBref
    if [ -d *tFmri_WM_pe0_ssg ]
    then
        # Get fmri_prefix
        s="$(find $PWD -type d -name '*tFmri_WM_pe0_ssg' | awk -F/ '{print $NF}')"
        echo ${s}
        fmri_prefix="$(echo $s | cut -d "_" -f 1)"
        echo ${fmri_prefix}
        sbref_prefix="$(($fmri_prefix - 1))"
        sbref_prefix_2="$(($fmri_prefix - 2))"
        #Sbref
        if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
        then
          echo "Found SBref (1 folder before this acquisition), copying..."
          cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
          rsync -rv $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${sbref_prefix}_1_BOLD_SB_ref_WM
          cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p1
        elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
        then
          echo "Found SBref (2 folders before this acquisition), copying..."
          cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
          rsync -rv $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${sbref_prefix_2}_1_BOLD_SB_ref_WM
          cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p1
        fi
    fi
  fi


  ### Folders that are normally in second session 2
  if [ -d /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p2 ]
  then
    cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p2
    rsync -rav $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}
    #Resting pe0 and SB Ref
    if [ -d *rsFmri24_pe0_ssg ]
    then
        # Get fmri_prefix
        s="$(find $PWD -type d -name '*rsFmri24_pe0_ssg*' | awk -F/ '{print $NF}')"
        echo ${s}
        fmri_prefix="$(echo $s | cut -d "_" -f 1)"
        echo ${fmri_prefix}
        sbref_prefix="$(($fmri_prefix - 1))"
        sbref_prefix_2="$(($fmri_prefix - 2))"
        #Resting State
        cd "$(find . -name *rsFmri24_pe0_ssg* -type d)"
        rsync -rav $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${fmri_prefix}_1_rsFmri24_2_pe0_ssg
        cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p2
        #Sbref
        if [ -d ${sbref_prefix}_1_BOLD_SB_ref ]
        then
          echo "Found SBref (1 folder before this acquisition), copying..."
          cd "$(find $PWD -type d -name "${sbref_prefix}_1_BOLD_SB_ref")"
          rsync -rav $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${sbref_prefix}_1_BOLD_SB_ref_RS_2
          cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p2
        elif [ -d ${sbref_prefix_2}_1_BOLD_SB_ref ]
        then
          echo "Found SBref (2 folders before this acquisition), copying..."
          cd "$(find $PWD -type d -name "${sbref_prefix_2}_1_BOLD_SB_ref")"
          rsync -rav $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${sbref_prefix_2}_1_BOLD_SB_ref_RS_2
          cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p2
        fi
        cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p2
    fi
    # Resting pe1
    if [ -d *rsFmri24_pe1_ssg ]
    then
        # Get fmri_prefix
        s="$(find $PWD -type d -name '*rsFmri24_pe1_ssg*' | awk -F/ '{print $NF}')"
        echo ${s}
        fmri_prefix="$(echo $s | cut -d "_" -f 1)"
        sbref_prefix="$(($fmri_prefix - 1))"
        sbref_prefix_2="$(($fmri_prefix - 2))"
        #Resting State
        cd "$(find . -name *rsFmri24_pe1_ssg* -type d)"
        rsync -rav $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${fmri_prefix}_1_rsFmri24_2_pe1_ssg
        cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p2
    fi
    #Fieldmaps
    echo "finding fieldmap in ${pwd}"
    if [ -d *fieldmap_pe0 ]
    then
        s="$(find $PWD -type d -name '*fieldmap_pe0' | awk -F/ '{print $NF}')"
        echo ${s}
        fmri_prefix="$(echo $s | cut -d "_" -f 1)"
        sbref_prefix="$(($fmri_prefix - 1))"
        sbref_prefix_2="$(($fmri_prefix - 2))"
        cd "$(find . -name *fieldmap_pe0 -type d)"
        rsync -rav $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${fmri_prefix}_1_SE_fieldmap_2_pe0
        cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p2
    fi
    if [ -d *fieldmap_pe1 ]
    then
        s="$(find $PWD -type d -name '*fieldmap_pe1' | awk -F/ '{print $NF}')"
        echo ${s}
        fmri_prefix="$(echo $s | cut -d "_" -f 1)"
        sbref_prefix="$(($fmri_prefix - 1))"
        sbref_prefix_2="$(($fmri_prefix - 2))"
        cd "$(find . -name *fieldmap_pe1 -type d)"
        rsync -rav $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}/${fmri_prefix}_1_SE_fieldmap_2_pe1
        cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p2
    fi
  fi


  ### Folders that are normally in second session 3
  if [ -d /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p3 ]
  then
    cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}_p3
    rsync -rav $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}
    cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/
  fi
  if [ -d /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject} ]
  then
    cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/${subject}
    rsync -rav $PWD/ /share/leanew1/PANLab_Datasets/CONNECTOME/raw/000_data_archive/${subject}
    cd /share/leanew1/migration-snigroups/HCP_Raw/000_data_archive/
  fi

done
