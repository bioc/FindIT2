% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mmPeakAnno_parse.R
\name{getAssocPairNumber}
\alias{getAssocPairNumber}
\title{getAssocPairNumber}
\usage{
getAssocPairNumber(
  mmAnno,
  output_type = c("gene_id", "feature_id"),
  output_summary = FALSE
)
}
\arguments{
\item{mmAnno}{the annotated GRange object from mm_geneScan or mm_nearestGene}

\item{output_type}{one of 'gene_id' or 'feature_id'}

\item{output_summary}{whether you want to detailed info}
}
\value{
data.frame
}
\description{
get associated peak number of gene and vice verse.
}
\examples{
if (require(TxDb.Athaliana.BioMart.plantsmart28)) {
    Txdb <- TxDb.Athaliana.BioMart.plantsmart28
    seqlevels(Txdb) <- paste0("Chr", c(1:5, "M", "C"))

    peak_path <- system.file("extdata", "ChIP.bed.gz", package = "FindIT2")
    peak_GR <- loadPeakFile(peak_path)
    peakAnno <- mm_nearestGene(peak_GR, Txdb)

    getAssocPairNumber(peakAnno)

}
}
