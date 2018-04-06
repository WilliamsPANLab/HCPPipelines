#!/bin/bash

# echo "Pre FreeSurfer Pipeline"
# sh ./PreFreeSurferPipelineBatch.sh
# echo "FreeSurfer Pipeline"
# sh ./FreeSurferPipelineBatch.sh
# echo "Post FreeSurfer Pipeline"
# sh ./PostFreeSurferPipelineBatch.sh
echo "Generic Volume Pipeline"
sh ./GenericfMRIVolumeProcessingPipelineBatch.sh
echo "Surface Volume Pipeline"
sh ./GenericfMRISurfaceProcessingPipelineBatch.sh
