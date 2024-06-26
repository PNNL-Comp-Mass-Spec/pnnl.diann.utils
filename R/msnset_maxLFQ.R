


#' MaxLFQ quantites of precursors in msnset
#'
#' @param m DIA-NN precursors report as MSnSet from `pqreport_to_msnset()`; should be **log2 intensities**
#' @param level Level to perform MaxLFQ, either "Protein.Group" or "Genes"
#' @param log2_trans Default TRUE; pq intensities need to be in Log2 space for `iq::fast_maxlfq()`
#' @return list of maxLFQ intensities
#' @export
#'
#' 
msnset_maxLFQ <- function(m, level = c("Protein.Group", "Genes"), log2_trans = TRUE){
  # To DO 
  # check for missing protein group info (could be general msnset function)
  # pipeline for msnset normalization 
  
  # to pass R CMD CHECK
    `MSnbase::fData(m)[, level]` <- `protein_list` <- `id` <- `quant` <- File.Name <- NULL 
  
  level <- match.arg(level)
  
  # Reshaping exprs data to work with iq::fast_maxlfq()
  ls <- MSnbase::exprs(m) |>
    as.data.frame() |>
    tibble::rownames_to_column(var= "id") |>
    cbind(MSnbase::fData(m)[, level]) |>
    dplyr::rename("protein_list" = `MSnbase::fData(m)[, level]`) |>
    dplyr::filter(protein_list != "") |>
    tidyr::pivot_longer(cols = -c(protein_list, id), 
                        names_to = "sample_list", 
                        values_to = "quant") |>
    dplyr::filter(!is.na(quant)) 
  
  # applying log 2 trans if TRUE
  if(log2_trans == TRUE){
    ls <- ls |>
      dplyr::mutate(quant = log2(quant))
  }
    
  ls <- ls |>
    as.list()
  
  
  # MaxLFQ exprs matrix
  ls_maxlfq <- iq::fast_MaxLFQ(ls) 
  
  exprs_new <- ls_maxlfq[["estimate"]]
  
  # New fData based on MaxLFQ level
  
  id_new <- rownames(exprs_new) 
  
  fData_new <- MSnbase::fData(m) |>
    dplyr::filter(.data[[level]] %in% id_new) |>
    dplyr::distinct() |>
    as.data.frame() |>
    `rownames<-`(NULL) |>
    tibble::column_to_rownames(var = level)
  
  # new msnset
  
  msnset_new <- MSnbase::MSnSet(
    exprs = as.matrix(exprs_new), 
    fData = fData_new, 
    pData = MSnbase::pData(m)
  )
  
  msnset_new
}

