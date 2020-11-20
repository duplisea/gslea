#' Ecosystem Approach Data
#'
#' @description
#' A data.table with data useful in developing analysese that could be classified as an ecosystem approach data for the Gulf of St. Lawrence ecoregions.
#'
#' @details
#' This includes data on
#' physical oceanography (physical); chemical oceanographic (chemical); phyto and zooplankton abundance or biomass
#' (planktonic); timing of phyto and zooplankton dynamics (phenological); large scale indices of oceanography, atmosphere
#' at broad scales (climatic); atmospheric projections from the climateatlas.ca website that brings together predictions from
#' 24 global climate models (projection.atmospheric); fish survey biomass estimates are divided into three groups: core species
#' (fish.survey.core.species) are 19 species that are consistently captured by the survey, commercial species (fish.survey.commercial.species)
#' includes 9 species which have been or are commercially exploited. The commercial species biomass is provided for juveniles and adults with the division between juvenile
#' and adult being the regulations on the small fish protocol:
#'
#' Cod/ Morue – 43 cm
#' American Plaice/Plie canadienne – 30 cm
#' Witch Flounder/ Plie grise – 30 cm
#' White hake / Merluche blanche – 45 cm
#' Winter Flounder / Plie rouge – 25 cm
#' Yellowtail Flounder/ Limande à queue jaune - 25 cm
#' Atlantic Halibut/ Flétan de l’Atlantique – 85 cm
#' Greenland Halibut/ Flétan du Groenland – 44 cm
#' Redfish/ Sébaste – 22 cm.
#'
#' Finally fish biomass is also aggregated into functional guilds (fish.survey.guild) which is a hybrid guild concept based on
#' both the main food source of species in that guild as well as their primary habitat.
#'
#' @format
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
NULL

#' Variable descriptions in EA.data
#'
#' @description
#' Descriptions of the variables in EA.data, the units of measure and other information
#'
#' @format
#' \itemize{
#'   \item variable The name of the variable in EA.data
#'   \item description A description of the variable
#'   \item units The units of measure for the value of the variable
#'   \item contact The name of the contact person for each variable
#'   \item type The broad category of the variabl, e.g. "physical", "chemical", "planktonic", "phenological", "climatic", "projection.atmospheric", "fish.survey.core.species", "fish.survey.commercial.species", "fish.survey.guild"
#'   \item extraction.date The date which the data were extracted from the parent data base by the person named as the contact
#' }
#'
#' @docType data
#' @keywords ecosystem approach data
#' @seealso field.description
#' @name variable.description
#' @usage variable.description
#' @author Daniel Duplisea
NULL



#' Field description
#' @description
#' A description of the fields in the EA.data dataset. Elaboration of the meaning of some of the fields is provided
#' and these can be joined to the output of a data query if desired.
#'
#' @format
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
#' @author Daniel Duplisea
NULL



#' Fish survey species
#' @description
#' The various species codes and names used in the fish survey data
#'
#' @format
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
#'                   EA.plot.f(years=1900:2030, variables=c("T150", "ph_bot.fall", "T250"), EARs=1:4, type="p",pch=20, smoothing=T)
#'
#'
#'              You may just want to extract the data from the above plot:
#'
#'                   EA.query.f(variables=c("T150", "ph_bot.fall", "T250"), years=1900:2030, EARs=1:4)
#' @export

gslea= function(){}
