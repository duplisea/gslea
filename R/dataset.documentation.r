# dataset documentation


#' Ecosystem Approach Data
#'
#' A data.table with all the ecosystem.approach data for the Gulf of St. Lawrence ecoregions. This includes data on
#' physical oceanography (physical), chemical oceanographic (chemical), phyto and zooplankton abundance or biomass
#' (planktonic) and timing of phyto and zooplankton dynamics (phenological).
#'
#' \itemize{
#'   \item year The year of data collection
#'   \item EAR The Ecosystem Approach Region
#'   \item variable The name of the measured variable
#'   \item value The value of the measured variable
#' }
#'
#' @docType data
#' @keywords ecosystem approach data
#' @seealso field.description
#' @name EA.data
#' @usage EA.data
#' @format data.table
#' @author Peter Galbraith, Marjolaine Blais
NULL



#' Field description
#'
#' A description of the fields in the EA.data dataset. Elaboration of the meaning of some of the fields is provided
#' and these can be joined to the output of a data query if desired.
#'
#' \itemize{
#'   \item field the name of the field from the EA.data table
#'   \item description A description of the EA.data field
#'   \item elaboration Extra information on the field, for example what is the definition of "summer" used
#' }
#'
#' @docType data
#' @keywords datasets
#' @name field.description
#' @usage field.description
#' @format data.table
#' @author Daniel Duplisea
NULL



#' Fish survey species
#'
#' The various species codes and names used in the fish survey data
#'
#' \itemize{
#'   \item variable	The name of the variable in the EA.data table
#'   \item species.code The species code from the Quebec region survey
#'   \item english The common English name for the species
#'   \item french The common French name for the species
#'   \item latin The scientific latin name for the species
#'   \item aphiaid The aphiaid that is used in WoRMS and Fishbase
#' }
#'
#' @docType data
#' @keywords datasets
#' @references Vandepitte, L., Vanhoorne, B., Decock, W., Dekeyzer, S., Trias Verbeeck, A., Bovit, L., Hernandez, F. and Mees, J., 2015. How Aphia—The platform behind several online and taxonomically oriented databases—can serve both the taxonomic community and the field of biodiversity informatics. Journal of Marine Science and Engineering, 3(4), pp.1448-1473.
#'             Miller, R. et Chabot. D. 2014. Code list of marine plants, invertebrates and vertebrates used by the Quebec Region of DFO. Canadian Data Report of Fisheries and Aquatic Sciences 1254 : iv+ 115 p.
#' @name field.description
#' @usage field.description
#' @format data.table
#' @author Daniel Duplisea
NULL
