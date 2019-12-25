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
#' @format data.table, data.frame
#' @author Denis Bernier, Peter Galbraith, Marjolaine Blais
#' @references
#'         Blais, M., Galbraith, P.S., Plourde, S., Scarratt, M., Devine, L. and Lehoux, C. 2019. Chemical and
#'         Biological Oceanographic Conditions in the Estuary and Gulf of St. Lawrence during 2017. DFO Can. Sci.
#'         Advis. Sec. Res. Doc. 2019/009. iv + 56 pp.
#'
#'         Galbraith, P.S., Chassé, J., Nicot, P., Caverhill, C., Gilbert, D., Pettigrew, B., Lefaivre,
#'         D., Brickman, D., Devine, L., and Lafleur, C. 2015. Physical Oceanographic Conditions in the Gulf of
#'         St. Lawrence in 2014. DFO Can. Sci. Advis. Sec. Res. Doc. 2015/032. v + 82 p
#'         http://www.dfo-mpo.gc.ca/csas-sccs/Publications/ResDocs-DocRech/2015/2015_032-eng.html
#'

NULL


#' Variable descriptions in EA.data
#'
#' Descriptions of the variables in EA.data, the units of measure and other information
#'
#' \itemize{
#'   \item variable The name of the variable in EA.data
#'   \item description A description of the variable
#'   \item units The units of measure for the value of the variable
#'   \item contact The name of the contact person for each variable
#'   \item type The broad category of the variabl, e.g. "physical", "chemical", "planktonic", "phenological"
#'   \item extraction.date The date which the data were extracted from the parent data base by the person named as the contact
#' }
#'
#' @docType data
#' @keywords ecosystem approach data
#' @seealso field.description
#' @name variable.description
#' @usage variable.description
#' @format data.table, data.frame
#' @author Daniel Duplisea
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
#' @format data.table, data.frame
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
#' @format data.table, data.frame
#' @author Daniel Duplisea
NULL


#' Gulf of St Lawrence Ecosystem Approach R package
#'
#' @description To get started you probably want some kind of metadata description:
#'
#'                   metadata.f(verbosity="low")
#'
#'
#'              You may be interested in what variables are available:
#'
#'                   vars.f(variable.type="all")
#'
#'              You may be interested in what variables are available of a particular type:
#'
#'                   vars.f(variable.type="chemical")
#'
#'
#'              You may want to explore data with simple plots:
#'
#'                   EA.plot.f(years=1900:2030, variables=c("T150", "ph_bot.fall", "T250"), EARs=1:4, type="b",pch=20)
#'
#'
#'              You may just want to extract the data from the above plot:
#'
#'                   EA.query.f(variables=c("T150", "ph_bot.fall", "T250"), years=1900:2030, EARs=1:4)
#' @export

gslea= function(){}