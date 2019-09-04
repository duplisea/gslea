#' Invertebrate to fish biomass ratio
#'
#' @param
#' @param
#' @param
#' @param
#' @param
#' @description The ratio of total invertebrates biomass to total fish biomass in each trawl. Individual trawl
#'       biomass was calculated and standardized in kg per km2, based on individual tow swept area (product of
#'       tow distance derived from tow duration and trawling speed and trawl horizontal opening or wing spread).
#' @details
#' @seealso
#' @references
#' @export
inv.over.fish.f= function(){
}

#' pelagic to demersal fish biomass ratio
#'
#' @param
#' @param
#' @param
#' @param
#' @param
#' @description Individual fish species were classified into four vertical habitat groupings: 1) benthic
#'       species living and feeding on the bottom; 2) demersal species living and feeding on or near the
#'       bottom; 3) benthopelagic species living and feeding near the bottom as well as in midwaters or near
#'       the surface; and 4) pelagic species living and feeding in midwaters or near the surface.
#' @details
#' @seealso
#' @references
#' @export
pel.over.dem.f= function(){
}

#' Trophic level 2 to Trophic levels 3 and more fish biomass ratio
#'
#' @param
#' @param
#' @param
#' @param
#' @param
#' @description Fish species were classified into four feeding categories: 1) Planktivorous; 2) Benthivorous;
#'       3) Piscivorous one and two (where piscivorous-one refers to shrimp (micronekton) consumers and
#'       piscivorous-two refers to both shrimp and fish consumers); and 4) Detritivorous/Scavenger. Species
#'       that undergo ontogenetic dietary shifts were assigned to a feeding category based on their adult
#'       stage diet (e.g., Sebastes sp. switch from a planktivorous to a piscivorous diet with increasing
#'       size and were assigned to the piscivorous category).
#' @details
#' @seealso
#' @references
#' @export
TL2.overTL3.f= function(){
}

#' Guild biomass
#'
#' @param
#' @param
#' @param
#' @param
#' @param
#' @description The biomass of each functional guild was calculated for each trawl-year combination. Biomass
#'       trajectories for individual functional guilds, or ratios of functional guilds biomass to total
#'       biomass in each trawl-year, may be used as ecological indicators (e.g., the proportion of predatory
#'       fish in individual trawl (bio_pel.bpel.pisc+bio_dem.bent.pisc /Trawl.Biomass)
#' @details Fish and invertebrate species were classified into 11 functional guilds:
#'      Planktivorous fish (F) (bio_pkt.fish)
#'      Benthivorous fish (F) (bio_benthiv.fish)
#'      Pelagic and Benthopelagic piscivores (F, I) (bio_pel.bpel.pisc)
#'      Demersal and Benthic piscivores (F, I) (bio_dem.bent.pisc)
#'      Parasitic and Detritivorous fish (F) (bio_par.det)
#'      Benthic infauna (I) (bio_benthic.infauna)
#'      Benthic motile invertebrates (I) (bio_benthic.mot.inv)
#'      Crab (I) (bio_crab)
#'      Demersal and benthic Micronekton (I) (bio_dem.bent.micronekton)
#'      Pelagic and benthopelagic Micronekton (I) (bio_pel.bpel.micronekton)
#'      Sessile invertebrates (I) (bio_sess.inv)
#' @seealso
#' @references
#'       Baker, M. R., and A. B. Hollowed. 2014. Delineating ecological regions in marine systems:
#'       Integrating physical structure and community composition to inform spatial management in the eastern
#'       Bering Sea. Deep Sea Research Part II: Topical Studies in Oceanography 109:215-240.
#'
#'       Coll, M., L. Shannon, K. Kleisner, M. Juan-Jordá, A. Bundy, A. Akoglu, D. Banaru, J. Boldt,
#'       M. Borges, and A. Cook. 2016. Ecological indicators to capture the effects of fishing on biodiversity
#'       and conservation status of marine ecosystems. Ecological Indicators 60:947-962.
#' @export
guild.biomass.f= function(){
}


#' Species richness and diversity
#'
#' @param
#' @param
#' @param
#' @param
#' @param
#' @description This approach reduced the total number of individual taxa recorded in the trawl survey data
#'       in 2006-2018 from 477 to 252. Richness was calculated as the total number of individual taxa in each
#'       trawl-year combination. This index could be further improved by i) distinguishing commercial
#'       invertebrate taxa from the broader taxonomic groups described above; and ii) by further refining
#'       and standardising invertebrate taxonomic resolution, for example by identifying dominant taxa that
#'       should be distinguished to species versus infrequent taxa that could remain pooled into higher-order
#'       taxonomic groups.
#'       Continuous improvement and standardisation of taxonomic resolution in the trawl survey data will also
#'       allow for the development of reliable, fisheries-independent species diversity indicators for the
#'       EGSL.
#' @details For the purpose of evaluating species richness, invertebrate taxa belonging to the following three
#'       functional guilds were pooled into higher-order taxonomic groupings in order to minimise the effect
#'       of recently increasing taxonomic resolution for these guilds in the survey data:
#'       Sessile invertebrates were pooled into the following 11 groups: Actiniaria, Alyconacea, Ascidiacea,
#'       Bryozoa, Cirripedia, Crinoidea, Hydrozoa, Pennatulacea, Porifera, Scleractinia and Zoanthidea.
#'
#'       Benthic motile invertebrates were pooled into the following 9 groups: Asteroidea, Cumacea,
#'       Echinoidea, Gastropoda, Holothuroidea, Hydrozoa, Ophiuroidea, Picnogonida and Polyplacophora.
#'
#'       Benthic infauna were pooled into the following 10 groups: Bivalvia, Brachiopoda, Echiura, Isopoda,
#'       Nematoda, Nemertea, Polycheate, Priapulidae, Scaphopoda and Sipuncula.
#' @seealso
#' @references
#' @export
species.diversity.f= function(){
}

#' Cold to warm water species biomass ratio
#'
#' @param
#' @param
#' @param
#' @param
#' @param
#' @description The following species were identified as candidate indicator taxa for cold water habitat in
#'       the EGSL: Boreogadus saida, Artediellus uncinatus, Eumicrotremus terraenovae, Pandalus borealis and
#'       Reinhardtius hippoglossoides. The following species were identified as candidate indicator taxa for
#'       warm water habitat in the EGSL: Merluccius bilinearis, Illex illecebrosus, Argentina silus.
#'
#'       The biomass of each candidate indicator taxa in each trawl-year combination was calculated. These
#'       can be examined as individual indicator taxa or as indicator groups (by summing the biomass of all
#'       cold or warm indicator taxa for each trawl-year combination).
#'
#'       Next steps: Calculate frequency of occurrence and index of relative importance (IRI) for these taxa
#'       at different spatial scales. Calculate and examine trajectories of mean and max length for candidate
#'       indicator taxa. Produce and investigate the usefulness of a length-unbiased condition factor for
#'       candidate indicator taxa.
#' @details
#' @seealso
#' @references
#' @export
cold.over.warm.f= function(){
}

#' Inverse biomass temporal variance
#'
#' @param
#' @param
#' @param
#' @param
#' @param
#' @description This could be an interesting one to compute when scaling up to AE boxes and the entire
#'      ecosystem.
#' @details
#' @seealso
#' @references
#'       Coll, M., L. Shannon, K. Kleisner, M. Juan-Jordá, A. Bundy, A. Akoglu, D. Banaru, J. Boldt,
#'       M. Borges, and A. Cook. 2016. Ecological indicators to capture the effects of fishing on biodiversity
#'       and conservation status of marine ecosystems. Ecological Indicators 60:947-962.
#' @export
inv.cv.f= function(){
}
