require(dplyr)
require(readr)
require(GSVA)
require(Biobase)
require(optparse)
require(stringr)

option_list <- list(
  make_option(c("-i", "--input_file"), action="store",
                help="path for input genes.counts file with tpm value", type="character"),
  make_option(c("-o", "--output_path"), action="store",
                help="output file directory, leave blank if using the same directory as input file",type="character")
)
args <- parse_args(OptionParser(option_list=option_list))

##### test #########
#args <- list()
#args$input_file <- "/rsrch5/home/tdccct/cchen21/cgcrun_0117/cgc_02239/task_outputs/cgc_02239.genes.results"
#args$outut_file <- "/rsrch5/home/tdccct/cchen21/cgcrun_0117/cgc_02239/task_outputs"
###################

# Check input file
if(file.exists(args$input_file)){
  tpm <- read_tsv(args$input_file)
} else{
  warning("tpm file does not exist")
}

# Column name for tpm values in genes.results
column_name_results <- "TPM"

# Chek output directory and use the same as input_file if blank
if(is.null(args$output_path)){
  args$output_path <- sub("/[^/]+$","",args$input_file)
}

# Load reference for gene_id <> gene_name
ref_path <- "/rsrch3/home/tdccct/shared/platforms/data/cgc/"
anno_file_path <- paste0(ref_path, "datasets/gencode.v31.basic.ensg.anno")

# Load TCGA_up (20 genes) signature
gs <- list()
gs[["TCGA_up_name"]] <- c("SPATA18", "EDA2R", "DDB2", "MDM2", "CDKN2A", "RPS27L", "PHLDA3", "PTCHD4", "FDXR" ,"TNFRSF10C", "ZMAT3", "AEN", "SESN1", "CYFIP2", "CCNG1", "FAS", "BBC3", "GLS2", "GDF15", "TRIM22")

# Gene name to gene id
anno_file <- read_tsv(anno_file_path)
anno_file$gene_id <- gsub(pattern = "[.].*", replacement = "", x= anno_file$gene_id)
gs[["TCGA_up_score"]] <- anno_file %>% filter(gene_name %in% gs[["TCGA_up_name"]]) %>% pull(gene_id)

# Path to cgc_RNA
tpm_sub <- tpm %>% tibble::column_to_rownames(var = "gene_id") %>% select(TPM) 
profile_id <- str_split(args$input_file, "/") %>% unlist() %>% dplyr::last() %>% 
  str_split(., "[.]") %>% unlist() %>% dplyr::first()
colnames(tpm_sub) <- profile_id

# ssGSEA score for p53 signature
eset <- Biobase::ExpressionSet(as.matrix(tpm_sub))
ssgsea <- gsva(eset, gset.idx.list = gs, verbose=FALSE, method = "ssgsea", ssgsea.norm = F)

# Export p53 score output
score <- cbind(ssgsea@phenoData@data,t(exprs(ssgsea))) 
result <- data.frame("profile_id" = profile_id, "p53_score" = round(score, 3))
write_csv(result, paste0(args$output_path, "/", profile_id, ".p53.score"))

print(paste0("p53 scoring for ", profile_id))
print(score)
print(paste0("Output path is ", args$output_path, "/", profile_id, ".p53.score"))