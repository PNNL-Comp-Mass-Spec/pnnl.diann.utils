% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/msnset_maxLFQ.R
\name{msnset_maxLFQ}
\alias{msnset_maxLFQ}
\title{MaxLFQ quantites of precursors in msnset}
\usage{
msnset_maxLFQ(m, level = c("Protein.Group", "Genes"), log2_trans = TRUE)
}
\arguments{
\item{m}{DIA-NN precursors report as MSnSet from `pqreport_to_msnset()`; should be **log2 intensities**}

\item{level}{Level to perform MaxLFQ, either "Protein.Group" or "Genes"}

\item{log2_trans}{Default TRUE; pq intensities need to be in Log2 space for `iq::fast_maxlfq()`}
}
\value{
list of maxLFQ intensities
}
\description{
MaxLFQ quantites of precursors in msnset
}
