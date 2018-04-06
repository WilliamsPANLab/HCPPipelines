#!/bin/bash

get_batch_options() {
    local arguments=("$@")

    unset command_line_specified_study_folder
    unset command_line_specified_subj_list
    unset command_line_specified_run_local

    local index=0
    local numArgs=${#arguments[@]}
    local argument

    while [ ${index} -lt ${numArgs} ]; do
        argument=${arguments[index]}

        case ${argument} in
            --StudyFolder=*)
                command_line_specified_study_folder=${argument#*=}
                index=$(( index + 1 ))
                ;;
            --Subject=*)
                command_line_specified_subj=${argument#*=}
                index=$(( index + 1 ))
                ;;
            --runlocal)
                command_line_specified_run_local="TRUE"
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

StudyFolder="${HOME}/Desktop/HCP_Pilots" # Location of Subject folders (named by subjectID)
Subjlist="CONN010"                                      # Space delimited list of subject IDs
EnvironmentScript="/Applications/Preprocessing/Pipelines/Examples/Scripts/SetUpHCPPipeline_CUSTOM.sh" # Pipeline environment script


if [ -n "${command_line_specified_study_folder}" ]; then
    StudyFolder="${command_line_specified_study_folder}"
fi

if [ -n "${command_line_specified_subj}" ]; then
    Subjlist="${command_line_specified_subj}"
fi

# Requirements for this script
#  installed versions of: FSL (version 5.0.6), FreeSurfer (version 5.3.0-HCP) , gradunwarp (HCP version 1.0.2)
#  environment: FSLDIR , FREESURFER_HOME , HCPPIPEDIR , CARET7DIR , PATH (for gradient_unwarp.py)

#Set up pipeline environment variables and software
source ${EnvironmentScript}

# Log the originating call
echo "$@"

#if [ X$SGE_ROOT != X ] ; then
#    QUEUE="-q long.q"
    QUEUE="-q hcp_priority.q"
#fi

PRINTCOM=""
#PRINTCOM="echo"

########################################## INPUTS ##########################################

#Scripts called by this script do assume they run on the outputs of the FreeSurfer Pipeline

######################################### DO WORK ##########################################

Tasklist=""
Tasklist="${Tasklist} rfMRI_REST1_PA"
PTasklist="${Tasklist} rfMRI_REST1_AP"
Tasklist="${Tasklist} rfMRI_REST2_PA"
Tasklist="${Tasklist} rfMRI_REST2_AP"
Tasklist="${Tasklist} tfMRI_EMOTION_PA"
Tasklist="${Tasklist} tfMRI_EMOTION_AP"
# Tasklist="${Tasklist} tfMRI_GAMBLING_PA"
# Tasklist="${Tasklist} tfMRI_GAMBLING_AP"
Tasklist="${Tasklist} tfMRI_WM_PA"
Tasklist="${Tasklist} tfMRI_WM_AP"

for Subject in $Subjlist ; do
  echo $Subject

  for fMRIName in $Tasklist ; do
    echo "  ${fMRIName}"
    LowResMesh="32" #Needs to match what is in PostFreeSurfer, 32 is on average 2mm spacing between the vertices on the midthickness
    FinalfMRIResolution="2" #Needs to match what is in fMRIVolume, i.e. 2mm for 3T HCP data and 1.6mm for 7T HCP data
    SmoothingFWHM="2" #Recommended to be roughly the grayordinates spacing, i.e 2mm on HCP data
    GrayordinatesResolution="2" #Needs to match what is in PostFreeSurfer. 2mm gives the HCP standard grayordinates space with 91282 grayordinates.  Can be different from the FinalfMRIResolution (e.g. in the case of HCP 7T data at 1.6mm)
    RegName="MSMSulc" #MSMSulc is recommended, if binary is not available use FS (FreeSurfer)


    if [ -n "${command_line_specified_run_local}" ] ; then
        echo "About to run ${HCPPIPEDIR}/fMRISurface/GenericfMRISurfaceProcessingPipeline.sh"
        queuing_command=""
    else
        echo "About to use fsl_sub to queue or run ${HCPPIPEDIR}/fMRISurface/GenericfMRISurfaceProcessingPipeline.sh"
        queuing_command="${FSLDIR}/bin/fsl_sub ${QUEUE}"
    fi

    ${queuing_command} ${HCPPIPEDIR}/fMRISurface/GenericfMRISurfaceProcessingPipeline.sh \
      --path=$StudyFolder \
      --subject=$Subject \
      --fmriname=$fMRIName \
      --lowresmesh=$LowResMesh \
      --fmrires=$FinalfMRIResolution \
      --smoothingFWHM=$SmoothingFWHM \
      --grayordinatesres=$GrayordinatesResolution \
      --regname=$RegName

  # The following lines are used for interactive debugging to set the positional parameters: $1 $2 $3 ...

      echo "set -- --path=$StudyFolder \
      --subject=$Subject \
      --fmriname=$fMRIName \
      --lowresmesh=$LowResMesh \
      --fmrires=$FinalfMRIResolution \
      --smoothingFWHM=$SmoothingFWHM \
      --grayordinatesres=$GrayordinatesResolution \
      --regname=$RegName"

      echo ". ${EnvironmentScript}"

   done
done
