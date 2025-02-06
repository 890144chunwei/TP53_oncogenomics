# Pull the gsva docker image to the desired location (only need to do it once)
#apptainer pull --docker-login r_gsva_1_46_0.sif

R_file_path = "./Deploy_p53_score_ssgsea.R"
input_path = "XXX"
output_path = "XXX"

# Run cgc profile one at a time

## Case 1 - output directory is the same as genes.counts file (leave without specifying -o)
apptainer exec --bind /rsrch3,/rsrch5 r_gsva_1_46_0.sif Rscript --vanilla R_file_path -i ${input_path}

## Case 2 - output the p53.score file to a different directory
apptainer exec --bind /rsrch3,/rsrch5 r_gsva_1_46_0.sif Rscript --vanilla R_file_path -i ${input_path} -o ${output_path}



# Loop through all the profiles in a run
path_run = "XX"

# output to the same directory as the genes.counts file
for PROFILE in $path__run/ ; 
do
 apptainer exec --bind ${input_path},${output_path} r_gsva_1_46_0.sif Rscript --vanilla R_file_path -i ${PROFILE}task_outputs/*genes.results
done
