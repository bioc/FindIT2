#' @importFrom GenomeInfoDb seqlevels
check_seqlevel <- function(peak_GR, Txdb, print_ChrN = 10) {
    if (length(seqlevels(peak_GR)) > print_ChrN) {
        peakGR_level <- paste(seqlevels(peak_GR)[seq_len(print_ChrN)],
                              collapse = " ")
    } else {
        peakGR_level <- paste(seqlevels(peak_GR), collapse = " ")
    }

    if (length(seqlevels(Txdb)) > print_ChrN) {
        Txdb_level <- paste(seqlevels(Txdb)[seq_len(print_ChrN)],
                            collapse = " ")
    } else {
        Txdb_level <- paste(seqlevels(Txdb), collapse = " ")
    }

    message(
        ">> checking seqlevels match...\t\t",
        format(Sys.time(), "%Y-%m-%d %X")
    )
    message(">> your peak_GR seqlevel:", peakGR_level, "...")
    message(">> your Txdb seqlevel:", Txdb_level, "...")

    if (all(!seqlevels(peak_GR) %in% seqlevels(Txdb))) {
        stop(
            "\nSorry, it seems that peak_GR and Txdb have no sequence levels in common",
             call. = FALSE
            )
    } else if (any(!seqlevels(peak_GR) %in% seqlevels(Txdb))) {
        chrNotIn <- seqlevels(peak_GR)[!seqlevels(peak_GR) %in% seqlevels(Txdb)]
        if(length(chrNotIn) > print_ChrN){
            chr_msg <- paste(chrNotIn[seq_len(print_ChrN)],
                             collapse = " ")
        } else {
            chr_msg <- paste(chrNotIn,
                             collapse = " ")
        }

        msg <- paste0(
            "some peak's Chr is nor in your Txdb, for example: ",
            chr_msg, "...",
            "\nI have filtered peaks in these Chr, though seqlevels still retain."
        )
        warning(msg,call. = FALSE)
    } else {
        message("Good, your Chrs in peak_GR is all in Txdb")
    }
}


# addfeatureIdSuggsesion <- function() {
#     # cat(">> sorry, it seems that you do not have column named 'feature_id' in peak_GR\n")
#     # cat(">> if you do have 'name' column or 1th column in metacolumn, which represent your peak name in peak_GR\n")
#     # cat("\n>> you can rename this column with 'feature_id' like\n")
#     # cat('colnames(S4Vectors::mcols(peak_GR))[1] <- "feature_id"\n')
#     # cat("\n>> or you can just add a new column like\n")
#     # cat('peak_GR$feature_id <- paste0("peakName_", seq_len(length(peak_GR)))\n')
#     msg <- c(
#         "\n>> sorry, it seems that you do not have column named 'feature_id' in peak_GR\n",
#         ">> if you do have 'name' column in Nth metacolumn,",
#         "which represent your peak name in peak_GR\n",
#         "\n>> you can rename this column with 'feature_id' like\n",
#         'colnames(S4Vectors::mcols(peak_GR))[N] <- "feature_id"\n',
#         ">> most of the time, the name column will appear in 1th metacolumn, so you can just\n",
#         'colnames(S4Vectors::mcols(peak_GR))[1] <- "feature_id"\n',
#         "\n>> or you can just add a new column like\n",
#         'peak_GR$feature_id <- paste0("peakName_", seq_len(length(peak_GR)))\n',
#         "\n>>please prepare peak_GR again"
#     )
#     stop(msg, call. = FALSE)
# }

check_parameter_length <- function(mmAnno, decay_dist) {
    length_upstream <- mmAnno@metadata$upstream
    length_downstream <- mmAnno@metadata$downstream

    if (!"upstream" %in% names(mmAnno@metadata)) {
        stop("please using mm_geneScan to get mmAnno first", call. = FALSE)
    } else if (max(length_upstream, length_downstream) < decay_dist) {
        stop("your scan length is smaller than deacy_dist you set", call. = FALSE)
    } else if (length_upstream != length_downstream) {
        warning("your scan length of upstream and downstream is not same",
                call. = FALSE
        )
    }
}

#' @importFrom methods is
check_colnames <- function(colnames,
                           data) {

    if (is(data, "GRanges")) {
        check_result <- colnames %in% colnames(mcols(data))
    } else {
        check_result <- colnames %in% colnames(data)
    }

    if (any(!check_result)) {
        msg <- paste("\nsorry, there is no column named", colnames[!check_result],
                     "in your", deparse(substitute(data)),
                     sep = " "
        )
        stop(msg, call. = FALSE)
    }
}

check_duplicated <- function(peak_GR){
    N <- length(peak_GR)
    feature_id_N <- length(unique(peak_GR$feature_id))
    if (feature_id_N < N){
        msg <- paste0(
            "sorry, it seems that your peak_GR have duplicated feature_id. ",
            "please de-duplicated your peak_GR"
        )
        stop(msg, call. = FALSE)
    }
}


utils::globalVariables(c("tmp_start", "tmp_end", "gene_id"))
report_geneInfo <- function(gene_GR) {
    geneInfo <- data.frame(gene_GR, stringsAsFactors = FALSE) %>%
        dplyr::mutate(
            tmp_start = dplyr::case_when(
                strand == "-" ~ end,
                TRUE ~ start
            ), # in case of "*"
            tmp_end = dplyr::case_when(
                strand == "-" ~ start,
                TRUE ~ end
            )
        ) %>%
        dplyr::select(seqnames, tmp_start, tmp_end, width, strand, gene_id) %>%
        dplyr::rename(
            start = tmp_start,
            end = tmp_end
        )

    return(geneInfo)
}

# print_msgParallel <- function() {
#     msg <- c(
#         "if you want to set cores/seesions number by yourself, you can use",
#         "future::plan() function\n",
#         "if additional processes do not terminate after completion, ",
#         'you can try future:::ClusterRegistry("stop")\n',
#         "see https://github.com/HenrikBengtsson/future/issues/117"
#     )
#     message(msg)
# }

# https://stackoverflow.com/questions/34208564/how-to-hide-or-disable-in-function-printed-message
# quiet <- function(x) {
#     sink(tempfile())
#     on.exit(sink())
#     invisible(force(x))
# }

#' @importFrom methods is
calcQvalue <- function(pvalue){
    # compare with BH, qvalue is more soft
    qvalue_result <- tryCatch(qvalue::qvalue(
        p = pvalue,
        fdr.level = 0.05,
        pi0.method = "bootstrap"
    ),
    error = function(e) NULL
    )

    if (is(qvalue_result, "qvalue")) {
        qvalues <- qvalue_result$qvalues
    } else {
        qvalues <- NA
    }

    return(qvalues)
}
