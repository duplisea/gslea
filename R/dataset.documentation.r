# dataset documentation

#' physical.oceanographic.data
#'
#' A list with physical oceanographic time series objects for the AE ecoregion of the Gulf of St. Lawrence.
#' The list contains several sublists with descriptive names. The first element of each of these sublists is
#' a descriptive header file including what it is, date of extraction, who to contact and column names. The
#' second element of each sublist is a data frame with the time series data and descriptive (but very long)
#' column names. An example of how to access and one of the data objects is shown. Missing value code is -99
#'
#' \itemize{
#'   \item CIL_Volume_AE Volume of the Cold Intermediate Layer
#' }
#'
#' @docType data
#' @keywords datasets
#' @name physical.oceanographic.data
#' @usage physical.oceanographic.data$CIL_Volume_AE$data
#' @format A list with several elements
#' @author Peter Galbraith <peter.galbraith@dfo-mpo.gc.ca>
NULL


# dataset documentation

#' biological.oceanographic.data
#'
#' A list with biological oceanographic time series objects for the AE ecoregions of the Gulf of St. Lawrence.
#' The list contains several data frame with descriptive names and named columns. An example of how to access
#' and one of the data objects is shown. Missing value code is na
#'
#' \itemize{
#'   \item Riki_Zoo_Mean_2018 annual mean abundance of zooplankton species or species group abundance at the
#'        Rimouski station updated in 2018.
#' }
#'
#' @docType data
#' @keywords datasets
#' @name biological.oceanographic.data
#' @usage biological.oceanographic.data$Riki_Zoo_Mean_2018
#' @format A list with several elements
#' @author Marjolaine Blais <marjolaine.blais@dfo-mpo.gc.ca>
NULL

#' fish.survey.data
#'
#' A list with fish survey data. Imported from PACES outputs.
#'
#' \itemize{
#'   \item r
#' }
#'
#' @docType data
#' @keywords datasets
#' @name fish.survey.data
#' @usage
#' @format A list with several elements
#' @author Denis Bernier <denis.bernier@dfo-mpo.gc.ca>
NULL
