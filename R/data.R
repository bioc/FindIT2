# https://stackoverflow.com/questions/24434438/r-package-build-undocumented-code-objects/42094220

#' RNA normCount of E50h-72h in Chr5
#'
#' @usage data(RNA_normCount)
#'
#' @format A matrix
#'
#' @source \url{https://doi.org/10.1016/j.devcel.2020.07.003}
#'
"RNA_normCount"


#' ATAC normCount of E50h-72h in Chr5
#'
#' @usage data(ATAC_normCount)
#'
#' @format A matrix
#'
#' @source \url{https://doi.org/10.1016/j.devcel.2020.07.003}
#'
"ATAC_normCount"

#' RNA diff result from LEC2_GR VS LEC2_DMSO
#'
#' @usage data(RNADiff_LEC2_GR)
#'
#' @format a data frame
#'
#' @source \url{https://doi.org/10.1016/j.devcel.2020.07.003}
#'
"RNADiff_LEC2_GR"


#' TF-target database
#'
#' @usage data(TF_target_database)
#'
#' @format a data frame
#'
#' @examples
#' \dontrun{
#' # source
#' library(dplyr)
#' data <- read.table("~/reference/annoation/Athaliana/TF_target/iGRN_network_full.txt",
#'                   sep = "\t",
#'                   stringsAsFactors = FALSE)
#'
#' data %>%
#' rename(TF_id = V1, target_gene = V2) %>%
#' select(TF_id, target_gene) %>%
#' TF_target_database <- filter(TF_id %in% c("AT1G28300",
#' "AT5G63790", "AT5G24110", "AT3G23250")) %>%
#' as.data.frame()
#'
#' save(TF_target_database, file = "inst/extdata/TF_target_database.rda", version = 2,
#'      compress = "bzip2")
#'
#' }
#'
#' @source \url{http://bioinformatics.psb.ugent.be/webtools/iGRN/pages/download}
"TF_target_database"


#' test_geneSet
#'
#' @usage data(test_geneSet)
#'
#' @format character vector represent your interesting gene set
#'
#' @examples
#' \dontrun{
#' # source
#' if (require(TxDb.Athaliana.BioMart.plantsmart28)) {
#'     library(FindIT2)
#'     Txdb <- TxDb.Athaliana.BioMart.plantsmart28
#'     seqlevels(Txdb) <- paste0("Chr", c(1:5, "M", "C"))
#'     ChIP_peak_path <- system.file("extdata", "ChIP.bed.gz", package = "FindIT2")
#'     ChIP_peak_GR <- loadPeakFile(ChIP_peak_path)
#'     ATAC_peak_path <- system.file("extdata", "ATAC.bed.gz", package = "FindIT2")
#'     ATAC_peak_GR <- loadPeakFile(ATAC_peak_path)
#'
#'     mmAnno_geneScan <- mm_geneScan(
#'         peak_GR = ChIP_peak_GR,
#'         Txdb = Txdb,
#'         upstream = 2e4,
#'         downstream = 2e4
#'     )
#'
#'     peakRP_gene <- calcRP_TFHit(
#'         mmAnno = mmAnno_geneScan,
#'         Txdb = Txdb,
#'         report_fullInfo = FALSE
#'     )
#'
#'     data("RNADiff_LEC2_GR")
#'      merge_result <- integrate_ChIP_RNA(
#'         result_geneRP = peakRP_gene,
#'         result_geneDiff = RNADiff_LEC2_GR
#'     )
#'
#'     target_result <- merge_result$data
#'     test_geneSet <- target_result$gene_id[1:50]
#'
#'     related_peaks <- mm_geneBound(
#'         peak_GR = ATAC_peak_GR,
#'         Txdb = Txdb,
#'         input_genes = test_geneSet
#'     )
#'     test_featureSet <- unique(related_peaks$feature_id)
#'     # save(test_geneSet, file = "data/test_geneSet.rda", version = 2)
#'     # save(test_featureSet, file = "data/test_featureSet.rda", version = 2)
#' }
#' }
#'
"test_geneSet"


#' test_featureSet
#'
#' @usage data(test_featureSet)
#'
#' @format character vector represent your interesting feature_id set
#'
#' @details
#' For the detailed progress producing input_feature_id, you can see ?test_geneSet
#'
#'
"test_featureSet"
