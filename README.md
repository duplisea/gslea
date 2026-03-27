# What’s new, March 2026

- A lot of new data and variables:
  - fish data from the southern Gulf survey
  - ecological indicators from the northern and southern Gulf surveys
  - new trophic guild definitions and data from both regions of the Gulf
  - harp seal and grey seal abundance
  - stock status, biomass, landings, limit reference points
  - bluefin tuna abundance
  - gannet breedpair numbers
  - fish leCren condition factors
  - alkalinity, dissolved organic carbon, aragonite
- New EARs which needed to be developed to accommodate data that does
  not necessarily come from a fixed region but from a survey

# What is it?

An R package to house Gulf of St Lawrence environment and ecosystem data
to promote ecosystem research and analysis in the Gulf of St Lawrence
and move us closer to an ecosystem approach to fisheries. It should be
readily understandable to a large swath of the research community who
have extensive or minimal R skills.

# Quick start

Open R and install the gslea package and try some commands outlined in
?gslea:

    install.packages("devtools")
    devtools::install_github("duplisea/gslea")
    library(gslea)
    ?gslea

If it installed, it is recommended that you print out, or have handy on
your computer, gslea.cheat.sheet.pdf. This one-pager provides examples
of all the basic commands that you can modify for your needs. The
greatest asset of this is to have the Gulf of St. Lawrence map available
so you can quickly see the numbers for each ecosystem approach region.

The cheat sheet is available on the github repository and it is on your
computer hard disc if you installed the package from github.

## Installation troubleshooting

IF you are having trouble installing gslea, firstly, you should try to
update R and Rtools to the latest version. Unfortunately on DFO windows
computers, the R version and the Rtools version are likely to be
outdated and if you do not have administrator privileges, you are stuck
with that.

Rtools (you do not need Rtools for Linux or Mac):
<https://cran.r-project.org/bin/windows/Rtools/>

So if you do not have administrator privileges the error I suspect you
will get is:

“Error: (converted from warning) package ‘data.table’ was built under R
version 4.0.3”

The solution to this is to make sure you have devtools installed (above)
and then turnoff the convert warnings to error problem and then try to
reinstall.

    library(devtools)
    Sys.setenv("R_REMOTES_NO_ERRORS_FROM_WARNINGS"=TRUE)
    devtools::install_github("duplisea/gslea")
    library(gslea)

Hopefully, this will allow you to install gslea even though the default
windows binary for data.table was built under a newer version of R than
available on the DFO software repository.

# Purpose

This describes the building of, the structure of and the use of an R
package that gathers up physical, chemical, planktonic, plankton
phenological and fish survey data into one place. This is a standalone R
package that can be called from scripts or other packages for use. The
data are provided spatially by the GSL ecosystem approach regions (EAR)
determined in Quebec Region in Spring 2019 (Fig. 1). Some data indices
that cover areas larger than EARs are provided.

The package has been developed to allow for easy and consistent updating
via automated scripts from tables provides by several individuals. This
means that people should not have to keep pestering say Peter or
Marjolaine to fullfill specific data requests for them. The package has
a very simple data table structure with a minimal set of functions to
understand the structure, query data and plot data roughly for initial
data exploration. Data can then be brought into various analyses for the
GSL that may fall under the banner of an ecosystem approach.

The primary end-user for this work has been envisioned as DFO regional
biologists who are involved in stock assessment and want to begin doing
analyses that incorporate data outside measures of biology of their
specific stock in an effort to expand their analysis to something that
may be considered an ecosystem approach to fisheries. We also, however,
anticipate that this matrix will have a much wider appeal for
researchers in DFO and elsewhere and it should also serve data
dissemination and open data initiatives in the Government of Canada.

# Data coverage

Presently, this package consists of data for the Gulf of St Lawrence
where collection and management of the data is done out of the Quebec
Region. This means that physical, chemical and phenological data
generally cover the entire Gulf of St Lawrence but fish survey data (not
in the database yet) cover only the northern portion as the southern
portion of the Gulf is surveyed by the Gulf Region in Moncton and with a
different survey gear.

There are also some broad climatic, oceangraphic and atmospheric indices
in the database (coded with EAR=-1) such as the North Atlantic
Osciallation. We have presently reserved EAR=0 for GSL scale indices
even though there are none in the database yet.

<img src="README_files/figure-markdown_strict/gslmap.plain-1.png"
style="width:100.0%" />

# Design and development philosophy

The package is GPL-3 licenced and thus is available globally without
warranty. The package is designed to have as few data containers as
possible and in a common and consistent format to allow generic
extraction. The package has only one dependence which is the library
data.table and data.table itself has no dependencies. The data.table
library is used because of its efficient use of computing resources
making it very fast for processing data
(<https://h2oai.github.io/db-benchmark/>) which is important if in
someone’s analysis they make repeated queries to the data in loops or in
bootstrapping directly from the full database. The data are structured
in what has become termed “tidy data” for people in the tidyverse as
opposed to messy data I suppose. You can use your own tidyverse code on
it. The data class “data.table” inherits a secondary class of
data.frame, therefore they are compatible with most of the base R
data.frame operations. The package is designed such that it is
consistent, should be scalable to when new data types become available
and should not break existing analyses when updated (I hope).

## List of development goals and guidelines

- The package needs to be technically accessible to as wide a swath of
  the envisioned end user community as possible (see Purpose section for
  an explanation of who this is).
- It must not require permissions to access and use the data and using
  it should be possible within minutes
- It must be fast to access and have minimal dependencies
- It must be operating system agnostic
- It should easily integrate into people’s work flow and analysis
- Data updates or functionality updates should not break existing
  analyses
- It should have only minimal data exploration functionality
- It must conform to Transparent, Traceable and Transferable (TTT) ideas
  (Edwards et al. 2018)
- It must create a clear flow from data supplier to user and make it
  easy to acknowledge and contact data suppliers
- It must be relatively easily updatable, updated often and not go
  data-stale
- It is a secondary data product and is not a primary relational
  database, i.e. it should not contain data that is not available or
  derivable from other existing databases. This also means that quality
  control in gslea is not on the data itself but only specific derived
  products.

These guidelines should be followed closely to prevent “mission creep”
which is likely to lead to failure of the usability of matrix at a later
point.

# Components of gslea

## Data objects

The package consists of three main tables presently:

<ins>
EA.data
</ins>

This is where all the measurements reside. The data.table (inherits
data.frame as second choice) has four columns: <b>year</b>, <b>EAR</b>,
<b>variable</b>, <b>value</b>. Where year is the year (integer) of data
collection, <b>EAR</b> is the ecosystem approach region (see fig 1)
(character), <b>variable</b> is the name of the variable (character),
<b>value</b> is the measured values (numeric). <b>variable</b> is set as
the key variable

<ins>
variable.descriptions
</ins>

this provides a description of the variable in EA.data. This table
contains five columns: <b>variable</b> is the name of the variable
(character), <b>description</b> is a description of the variable and
what is represents, <b>units</b> are the units of measure of the
variable, <b>contact</b> is the name of the contact person who provided
the data, <b>type</b> is the type of data (“physical”, “chemical”,
“planktonic”, “phenological”, “fish”), <b>extraction.date</b> is the
date which the contact person extracted the data from their database.
<b>variable</b> is the key variable. Some of the variables are not just
single measures per year but monthly measures. It was a conscious
decision not to make a sub-year time column in these cases which makes
the extraction result more difficult since often people want data in
two-dimensional tabular format. So for example some of the plankton data
are available by month. In these cases, there is a separate variable for
each month and if it were for September it would end in …month9.

<ins>
field.descriptions
</ins>

this gives a description of the field names in the EA.data especially as
these might need elaboration in some cases. The table contains three
columns: <b>field</b> which is the field name in the EA.data table,
<b>description</b> which describes what is represented by that column,
<b>elaboration</b> which provides more details on the column when
needed. So the elaboration column for <b>EAR</b> describes the areas
represented by each ecoregion code. Elaboration for variable describes
specifically what is meant by a variable containing a name that may
include “early summer”. <b>field</b> is the key variable.

Another data table describes the coordinates of the EAR boundaries in
decimal degrees but you never see that here.

## Functions

The package consists of limited number of functions:

<ins>
metadata.f(verbosity)
</ins>

a description of the data available with three levels of
<b>verbosity</b> (“low” “med”, “high”) or EASTER EGG information on
everyone’s favourite Dutch post-impressionist: metadata.f(“vangogh”).

<ins>
vars.f(variable.type)
</ins>

shows the variables available in a particular <b>variable.type</b>
e.g. “physical”, “chemical” gives a description of each and its units.

<ins>
find.vars.f(search.term)
</ins>

finds variable names based on partial matches. It search not just the
variable names but also their descriptions, sources and references.

<ins>
EA.query.f(variables, years, EARs)
</ins>

the function you use to query the data and the output is in long data
format. <b>variables</b> (e.g. “t150”,“sst”) is a character vector,
<b>years</b> is a numeric vector (e.g. 2002:2012), <b>EARs</b> is the
ecoregion and is a numeric vector (e.g. 1:3).

<ins>
EA.plot.f(variables, years, EARs, …)
</ins>

this will plot the variables over time. It will make a matrix of
variable x EAR with up to 25 plots per page (i.e. 25 variable\*EAR
combinations). <b>variables</b> (e.g. “t150”) is a character vector,
<b>years</b> is a numeric vector (e.g. 2002:2012), <b>EARs</b> is the
ecoregion and is a numeric vector (e.g. 1:3), <b>smoothing</b> is a
logical on whether the smooth.spline should be run through the data
series to help give a general idea of the tendencies in time. It will
only try to smooth if the data has more than 5 observations. <b>….</b>
will accept parameters to par for plotting. This is mostly for quick
exploration of the data rather than for making good quality graphics.

<ins>
EA.cor.f(variables, years, EARs, …)
</ins>

commputes the cross corelation between two variables with lags. It has
the option of differencing the variables to make them stationary and
therefore correlate on the how the values of each of the variables
changes from year to year as opposed to their absolute values. … gives
arguments to the <b>ccf</b> function.

<ins>
sources.f(variable.name)
</ins>

gives a source and reference for any variable in the database. If NULL
then it returns the full list of sources and references. Please cite
these references if using the data.

# Installing gslea

    devtools::install_github("duplisea/gslea", build_vignettes = TRUE)
    library(gslea)

# Accessing the data

## Data content overviews

A few minimal extraction functions are provided that should be fast and
relatively generic. A function called <b>metadata.f</b> is provided with
three levels of verbosity to give you an overview. “low” verbosity just
gives a few stats on the size of the database and the number of
variables and EARs. “med” verbosity will give you names of variables and
units. “high” is not that useful because it pretty well outputs the
entire content of the variable.description table.

    metadata.f(verbosity="low")

    ## $Number.of.variables
    ## [1] 948
    ## 
    ## $Number.of.EARS
    ## [1] 43
    ## 
    ## $Number.of.years
    ## [1] 243
    ## 
    ## $First.and.last.year
    ## [1] 1854 2096
    ## 
    ## $Number.of.observations
    ## [1] 422680

Another perhaps more useful way to know what the database contains is
with the function <b>var.f</b>. <b>var.f</b> accepts as an argument one
of the data types with the default being “all”. The options are the
adjectives for a data type, e.g. “physical”, “chemical”, “planktonic”
which for some data types seems awkward but it is consistent. It will
give you the exact name of the variable, its description and units. The
output can be long and the descriptions are sometimes quite wordy so it
is difficult to read. I suggest you save the result of a large query to
var.f as an object and then use the library formattable to make it into
a more readable table. So for example formattable, e.g.:

    phys.var= vars.f(variable.type="physical")
    formattable::formattable(phys.var)

<table class="table table-condensed">
<thead>
<tr>
<th style="text-align:right;">
variable
</th>
<th style="text-align:right;">
type
</th>
<th style="text-align:right;">
description
</th>
<th style="text-align:right;">
units
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
a.ge20.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature greater than 20
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.ge20.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature greater
than 20
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt0.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 0
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt0.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 0
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt0.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 0
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt1.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 1
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt1.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 1
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt1.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 1
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt10.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 10
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt10.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 10
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt10.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 10
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt11.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 11
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt11.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 11
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt11.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 11
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt12.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 12
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt12.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 12
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt12.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 12
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt13.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 13
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt13.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 13
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt13.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 13
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt14.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 14
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt14.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 14
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt14.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 14
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt15.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 15
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt15.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 15
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt15.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 15
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt16.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 16
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt16.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 16
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt16.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 16
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt17.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 17
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt17.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 17
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt17.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 17
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt18.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 18
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt18.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 18
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt18.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 18
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt19.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 19
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt19.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 19
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt19.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 19
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt2.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 2
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt2.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 2
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt2.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 2
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt20.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 20
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt20.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 20
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt20.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 20
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt3.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 3
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt3.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 3
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt3.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 3
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt4.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 4
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt4.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 4
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt4.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 4
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt5.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 5
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt5.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 5
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt5.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 5
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt6.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 6
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt6.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 6
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt6.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 6
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt7.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 7
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt7.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 7
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt7.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 7
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt8.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 8
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt8.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 8
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt8.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 8
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt9.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than 9
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt9.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than 9
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.lt9.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than 9
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.ltminus1.deep.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of deep water (&gt;100m) with temperature less than -1
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.ltminus1.shallow.august
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) with temperature less than -1
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
a.ltminus1.shallow.june
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
area (km2) of shallow water (&lt;100m) in June with temperature less
than -1
</td>
<td style="text-align:right;">
km squared
</td>
</tr>
<tr>
<td style="text-align:right;">
cil.vol.lt.1
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Volume of water in CIL defined by the &lt;1 C boundary
</td>
<td style="text-align:right;">
km cubed
</td>
</tr>
<tr>
<td style="text-align:right;">
decrease.10
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Timing of when water first cools to 10 C
</td>
<td style="text-align:right;">
week of the year
</td>
</tr>
<tr>
<td style="text-align:right;">
decrease.12
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Timing of when water first cools to 12 C
</td>
<td style="text-align:right;">
week of the year
</td>
</tr>
<tr>
<td style="text-align:right;">
first.ice
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Timing of the first appearance of ice
</td>
<td style="text-align:right;">
day of the year
</td>
</tr>
<tr>
<td style="text-align:right;">
ice.duration
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Duration of the ice season
</td>
<td style="text-align:right;">
number of days
</td>
</tr>
<tr>
<td style="text-align:right;">
ice.max
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Day of maximum ice coverage
</td>
<td style="text-align:right;">
day of the year
</td>
</tr>
<tr>
<td style="text-align:right;">
last.ice
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Timing of the last appearance of ice
</td>
<td style="text-align:right;">
day of the year
</td>
</tr>
<tr>
<td style="text-align:right;">
sst
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
sea surface temperature annual
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
sst.anomaly
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
anomaly in sea surface temperature annual
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
sst.month10
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
sea surface temperature in October
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
sst.month11
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
sea surface temperature in November
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
sst.month5
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
sea surface temperature in May
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
sst.month6
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
sea surface temperature in June
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
sst.month7
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
sea surface temperature in July
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
sst.month8
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
sea surface temperature in August
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
sst.month9
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
sea surface temperature in September
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
start.10
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Timing of when water first warms to 10 C
</td>
<td style="text-align:right;">
week of the year
</td>
</tr>
<tr>
<td style="text-align:right;">
start.12
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Timing of when water first warms to 12 C
</td>
<td style="text-align:right;">
week of the year
</td>
</tr>
<tr>
<td style="text-align:right;">
t.deep
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Bottom temperature in waters &gt; 200m deep august survey interpolated
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
t.shallow
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Bottom temperature in waters &lt; 200m deep august survey interpolated
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
t150
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Temperature at 150m
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
t200
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Temperature at 200m
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
t250
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Temperature at 250m
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
t300
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Temperature at 300m
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
tmax200.400
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Maximum temperature between 200 and 400m interpolated temperature
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
</tbody>
</table>

You can also try to find a variable through partial matching of a term
(case insensitive). So for example if you were interested in just
temperature you might search “temp”. Or anything that is from 200m deep
then search “200”. It will then give you a list of variable that have
that term in their description.

    find.vars.f(search.term= "200")

    ##  [1] "alk_canesm2_rcp8.5_t26_rcp8.5_t26_bottom.above.200"             
    ##  [2] "alk_canesm2_rcp8.5_t26_rcp8.5_t26_bottom.deep.auguster.200"     
    ##  [3] "alk_hadgem2-es_rcp8.5_t26_rcp8.5_t26_bottom.above.200"          
    ##  [4] "alk_hadgem2-es_rcp8.5_t26_rcp8.5_t26_bottom.deep.auguster.200"  
    ##  [5] "alk_mpi-esm-lr_rcp8.5_t26_rcp8.5_t26_bottom.above.200"          
    ##  [6] "alk_mpi-esm-lr_rcp8.5_t26_rcp8.5_t26_bottom.deep.auguster.200"  
    ##  [7] "j.gsnw.q1"                                                      
    ##  [8] "j.gsnw.q2"                                                      
    ##  [9] "j.gsnw.q3"                                                      
    ## [10] "j.gsnw.q4"                                                      
    ## [11] "nh4_canesm2_rcp8.5_t26_rcp8.5_t26_200m"                         
    ## [12] "nh4_canesm2_rcp8.5_t26_rcp8.5_t26_bottom.above.200"             
    ## [13] "nh4_hadgem2-es_rcp8.5_t26_rcp8.5_t26_200m"                      
    ## [14] "nh4_hadgem2-es_rcp8.5_t26_rcp8.5_t26_bottom.above.200"          
    ## [15] "nh4_mpi-esm-lr_rcp8.5_t26_rcp8.5_t26_200m"                      
    ## [16] "nh4_mpi-esm-lr_rcp8.5_t26_rcp8.5_t26_bottom.above.200"          
    ## [17] "no3_canesm2_rcp8.5_t26_rcp8.5_t26_200m"                         
    ## [18] "no3_canesm2_rcp8.5_t26_rcp8.5_t26_bottom.above.200"             
    ## [19] "no3_hadgem2-es_rcp8.5_t26_rcp8.5_t26_200m"                      
    ## [20] "no3_hadgem2-es_rcp8.5_t26_rcp8.5_t26_bottom.above.200"          
    ## [21] "no3_mpi-esm-lr_rcp8.5_t26_rcp8.5_t26_200m"                      
    ## [22] "no3_mpi-esm-lr_rcp8.5_t26_rcp8.5_t26_bottom.above.200"          
    ## [23] "o2_canesm2_rcp8.5_t26_rcp8.5_t26_200m"                          
    ## [24] "o2_canesm2_rcp8.5_t26_rcp8.5_t26_bottom.above.200"              
    ## [25] "o2_hadgem2-es_rcp8.5_t26_rcp8.5_t26_200m"                       
    ## [26] "o2_hadgem2-es_rcp8.5_t26_rcp8.5_t26_bottom.above.200"           
    ## [27] "o2_mpi-esm-lr_rcp8.5_t26_rcp8.5_t26_200m"                       
    ## [28] "o2_mpi-esm-lr_rcp8.5_t26_rcp8.5_t26_bottom.above.200"           
    ## [29] "o2sat_canesm2_rcp8.5_t26_rcp8.5_t26_bottom.above.200"           
    ## [30] "o2sat_canesm2_rcp8.5_t26_rcp8.5_t26_bottom.deep.auguster.200"   
    ## [31] "o2sat_hadgem2-es_rcp8.5_t26_rcp8.5_t26_bottom.above.200"        
    ## [32] "o2sat_hadgem2-es_rcp8.5_t26_rcp8.5_t26_bottom.deep.auguster.200"
    ## [33] "o2sat_mpi-esm-lr_rcp8.5_t26_rcp8.5_t26_bottom.above.200"        
    ## [34] "o2sat_mpi-esm-lr_rcp8.5_t26_rcp8.5_t26_bottom.deep.auguster.200"
    ## [35] "t.deep"                                                         
    ## [36] "t.shallow"                                                      
    ## [37] "t200"                                                           
    ## [38] "tmax200.400"                                                    
    ## [39] "s.200.spatial"                                                  
    ## [40] "s.interp.200"                                                   
    ## [41] "t.interp.200"                                                   
    ## [42] "t.interp.max200to400"                                           
    ## [43] "amo.month1"                                                     
    ## [44] "amo.month10"                                                    
    ## [45] "amo.month11"                                                    
    ## [46] "amo.month12"                                                    
    ## [47] "amo.month2"                                                     
    ## [48] "amo.month3"                                                     
    ## [49] "amo.month4"                                                     
    ## [50] "amo.month5"                                                     
    ## [51] "amo.month6"                                                     
    ## [52] "amo.month7"                                                     
    ## [53] "amo.month8"                                                     
    ## [54] "amo.month9"                                                     
    ## [55] "pdo.month1"                                                     
    ## [56] "pdo.month10"                                                    
    ## [57] "pdo.month11"                                                    
    ## [58] "pdo.month12"                                                    
    ## [59] "pdo.month2"                                                     
    ## [60] "pdo.month3"                                                     
    ## [61] "pdo.month4"                                                     
    ## [62] "pdo.month5"                                                     
    ## [63] "pdo.month6"                                                     
    ## [64] "pdo.month7"                                                     
    ## [65] "pdo.month8"                                                     
    ## [66] "pdo.month9"

You will see that t.deep and t.shallow come up in this because in their
descriptions, the distinction between shallow and deep waters is 200m.
You will also see AMO variable coming up and this is because the
reference for the AMO was published in 2001 and 200 is a substring of
that. So you can see it will find things fairly broadly

This search function will search most of the main fields of the
variable.description table. So for example you may be interested in
products which Peter Galbraith was involved with so you could try
find.vars.f(search.term= “galbra”) or say something to do with plankton
blooms find.vars.f(“bloom”).

## Data extraction

Extracting the data is done with a single function called
<b>EA.query.f</b>. This query wants a character vector or scalar for
variable, an integer vector or scalar for year and an integer vector or
scalar for EAR:

    EA.query.f(years=1999:2012, variables=c("t150", "t200", "t250"), EARs=1:2)

    ##      year    EAR variable value
    ##     <num> <char>   <char> <num>
    ##  1:  1999      1     t150  3.27
    ##  2:  1999      1     t200  4.43
    ##  3:  1999      1     t250  4.99
    ##  4:  1999      2     t150  2.97
    ##  5:  1999      2     t200  4.61
    ##  6:  1999      2     t250  5.37
    ##  7:  2000      1     t150  2.94
    ##  8:  2000      1     t200  4.26
    ##  9:  2000      1     t250  4.88
    ## 10:  2000      2     t150  2.88
    ## 11:  2000      2     t200  4.75
    ## 12:  2000      2     t250  5.59
    ## 13:  2001      1     t150  3.25
    ## 14:  2001      1     t200  4.40
    ## 15:  2001      1     t250  4.97
    ## 16:  2001      2     t150  2.19
    ## 17:  2001      2     t200  4.56
    ## 18:  2001      2     t250  5.53
    ## 19:  2002      1     t150  3.27
    ## 20:  2002      1     t200  4.42
    ## 21:  2002      1     t250  5.04
    ## 22:  2002      2     t150  2.68
    ## 23:  2002      2     t200  4.86
    ## 24:  2002      2     t250  5.74
    ## 25:  2003      1     t150  2.95
    ## 26:  2003      1     t200  4.44
    ## 27:  2003      1     t250  5.10
    ## 28:  2003      2     t150  2.56
    ## 29:  2003      2     t200  4.75
    ## 30:  2003      2     t250  5.79
    ## 31:  2004      1     t150  2.64
    ## 32:  2004      1     t200  4.09
    ## 33:  2004      1     t250  4.91
    ## 34:  2004      2     t150  1.68
    ## 35:  2004      2     t200  3.75
    ## 36:  2004      2     t250  5.49
    ## 37:  2005      1     t150  2.84
    ## 38:  2005      1     t200  4.22
    ## 39:  2005      1     t250  5.02
    ## 40:  2005      2     t150  2.29
    ## 41:  2005      2     t200  4.16
    ## 42:  2005      2     t250  5.46
    ## 43:  2006      1     t150  3.23
    ## 44:  2006      1     t200  4.35
    ## 45:  2006      1     t250  4.97
    ## 46:  2006      2     t150  3.16
    ## 47:  2006      2     t200  5.02
    ## 48:  2006      2     t250  5.65
    ## 49:  2007      1     t150  3.31
    ## 50:  2007      1     t200  4.42
    ## 51:  2007      1     t250  5.01
    ## 52:  2007      2     t150  1.74
    ## 53:  2007      2     t200  4.54
    ## 54:  2007      2     t250  5.63
    ## 55:  2008      1     t150  2.99
    ## 56:  2008      1     t200  4.28
    ## 57:  2008      1     t250  4.95
    ## 58:  2008      2     t150  1.45
    ## 59:  2008      2     t200  3.83
    ## 60:  2008      2     t250  5.37
    ## 61:  2009      1     t150  2.64
    ## 62:  2009      1     t200  3.99
    ## 63:  2009      1     t250  4.77
    ## 64:  2009      2     t150  2.06
    ## 65:  2009      2     t200  3.92
    ## 66:  2009      2     t250  5.04
    ## 67:  2010      1     t150  2.46
    ## 68:  2010      1     t200  3.76
    ## 69:  2010      1     t250  4.54
    ## 70:  2010      2     t150  2.42
    ## 71:  2010      2     t200  4.20
    ## 72:  2010      2     t250  5.14
    ## 73:  2011      1     t150  2.78
    ## 74:  2011      1     t200  3.94
    ## 75:  2011      1     t250  4.61
    ## 76:  2011      2     t150  2.56
    ## 77:  2011      2     t200  4.41
    ## 78:  2011      2     t250  5.39
    ## 79:  2012      1     t150  3.41
    ## 80:  2012      1     t200  4.34
    ## 81:  2012      1     t250  4.89
    ## 82:  2012      2     t150  2.86
    ## 83:  2012      2     t200  4.82
    ## 84:  2012      2     t250  5.71
    ##      year    EAR variable value
    ##     <num> <char>   <char> <num>

You need to name all the variables you want to extract but you can
access all the years or all the EARs by putting a wide range on them

    EA.query.f(years=1900:2021, variables=c("t150", "t200", "t250"), EARs=1:99)

    ##        year    EAR variable value
    ##       <num> <char>   <char> <num>
    ##    1:  1915      2     t150 -0.21
    ##    2:  1915      2     t200  1.29
    ##    3:  1915      2     t250  3.75
    ##    4:  1915      3     t150  0.57
    ##    5:  1915      3     t200  2.46
    ##   ---                            
    ## 1695:  2021     30     t200  6.09
    ## 1696:  2021     30     t250  6.86
    ## 1697:  2021     31     t150  4.19
    ## 1698:  2021     31     t200  6.54
    ## 1699:  2021     31     t250  7.36

You may want to save the results of a query to an object and then export
it to csv (<b>fwrite</b>) or some other format.

### Recasting data and showing when there were no observations

The data are in long format (tidyverse speak = “tidy data”) which is the
common way to store data in databases. It means that for a variable x
year x EAR combination where there is no observation, there is not a row
in the database either. If you want tabular data (wide) to show when say
and observation was not made for a particular year and variable and EAR,
then you can widen the data using the “dcast” function from data.table

    dat= EA.query.f(years=1900:2021, variables=c("t150","ice.max","sst"), EARs=1)
    dcast(dat, year~ variable)

    ## Key: <year>
    ##      year ice.max   sst  t150
    ##     <num>   <num> <num> <num>
    ##  1:  1932      NA    NA  1.65
    ##  2:  1933      NA    NA  1.33
    ##  3:  1934      NA    NA  1.73
    ##  4:  1935      NA    NA  2.08
    ##  5:  1937      NA    NA  1.44
    ##  6:  1946      NA    NA  2.07
    ##  7:  1947      NA    NA  1.72
    ##  8:  1948      NA    NA  2.05
    ##  9:  1950      NA    NA  2.16
    ## 10:  1951      NA    NA  2.18
    ## 11:  1952      NA    NA  2.45
    ## 12:  1953      NA    NA  2.68
    ## 13:  1954      NA    NA  2.98
    ## 14:  1955      NA    NA  2.53
    ## 15:  1956      NA    NA  1.53
    ## 16:  1957      NA    NA  2.19
    ## 17:  1958      NA    NA  2.49
    ## 18:  1959      NA    NA  2.10
    ## 19:  1960      NA    NA  2.33
    ## 20:  1961      NA    NA  1.59
    ## 21:  1962      NA    NA  1.81
    ## 22:  1963      NA    NA  1.54
    ## 23:  1964      NA    NA  1.94
    ## 24:  1965      NA    NA  2.52
    ## 25:  1966      NA    NA  2.34
    ## 26:  1967      NA    NA  2.16
    ## 27:  1968      NA    NA  2.34
    ## 28:  1969    4.25    NA  2.51
    ## 29:  1970    6.61    NA  3.14
    ## 30:  1971   13.20    NA  3.02
    ## 31:  1972   10.96    NA  2.12
    ## 32:  1973    9.37    NA  3.01
    ## 33:  1974    8.82    NA  2.56
    ## 34:  1975      NA    NA  2.07
    ## 35:  1976    7.54    NA  2.78
    ## 36:  1977    9.61    NA  2.28
    ## 37:  1978   10.87    NA  3.52
    ## 38:  1979   16.86    NA  3.41
    ## 39:  1980    4.43    NA  3.19
    ## 40:  1981    9.05    NA  4.11
    ## 41:  1982    5.60  7.08  3.47
    ## 42:  1983    7.84  7.68  2.90
    ## 43:  1984    8.44  7.94  3.05
    ## 44:  1985    6.17  7.73  3.44
    ## 45:  1986    5.97  7.29  2.31
    ## 46:  1987    7.95  7.38  2.98
    ## 47:  1988   10.11  7.86  3.05
    ## 48:  1989    5.77  7.11  3.31
    ## 49:  1990    6.85  7.16  2.03
    ## 50:  1991    5.73  7.50  1.42
    ## 51:  1992   10.52  7.12  2.04
    ## 52:  1993   11.73  8.36  2.20
    ## 53:  1994    7.60  8.97  2.56
    ## 54:  1995   11.42  8.78  2.32
    ## 55:  1996    8.84  8.69  2.37
    ## 56:  1997    7.34  8.20  2.89
    ## 57:  1998    5.13  8.84  2.54
    ## 58:  1999    5.27  8.97  3.27
    ## 59:  2000    4.64  8.25  2.94
    ## 60:  2001    4.66  8.44  3.25
    ## 61:  2002    7.43  7.77  3.27
    ## 62:  2003    4.53  8.29  2.95
    ## 63:  2004    4.91  8.11  2.64
    ## 64:  2005    7.67  8.76  2.84
    ## 65:  2006    3.22  9.12  3.23
    ## 66:  2007    2.31  8.04  3.31
    ## 67:  2008    9.61  9.34  2.99
    ## 68:  2009    5.48  8.42  2.64
    ## 69:  2010    1.85  9.19  2.46
    ## 70:  2011    1.99  9.18  2.78
    ## 71:  2012    3.94  9.53  3.41
    ## 72:  2013    2.44  8.22  2.83
    ## 73:  2014    7.47  9.53  3.16
    ## 74:  2015    9.12  8.60  4.09
    ## 75:  2016    3.06  9.19  3.66
    ## 76:  2017    3.81  8.27  3.50
    ## 77:  2018    6.08  7.66  3.09
    ## 78:  2019    5.06  8.57  3.53
    ## 79:  2020    4.36  8.48  3.46
    ## 80:  2021    1.35 10.02  4.01
    ##      year ice.max   sst  t150
    ##     <num>   <num> <num> <num>

This puts each variable as a separate column, it preserves all the years
where at least one of the variables had an observation and it puts NA
for variable x year combinations where there was no observation.

It is important to know that when you do this as above, you are making
2-dimensional table data which is fine if your data are two dimensional.
If you have more than one EAR, then your initial data are 3-dimensional
and when you cast the data to 2-dimensions, a decision needs to made on
how to reduce it to 2-dimensions. This is done with a “group by”
function. By default, dcast will do a group-by as count but you can also
specify other groub-by functions such as sum or mean. You can also,
however, cast multidimension data into a table but it will repeat the
columns for each EAR (note that “EAR” is now in the right hand side of
the formula)

    dat= EA.query.f(years=2015:2021, variables=c("t150","ice.max","sst"), EARs=1:100)
    dcast(dat, year~ variable+EAR)

    ## Key: <year>
    ##     year ice.max_1 ice.max_10 ice.max_11 ice.max_2 ice.max_3 ice.max_30
    ##    <num>     <num>      <num>      <num>     <num>     <num>      <num>
    ## 1:  2015      9.12       1.85       7.28     15.42     12.98       9.99
    ## 2:  2016      3.06       0.74       2.32      2.21      1.21       1.20
    ## 3:  2017      3.81       0.94       2.88      5.98      1.41       1.20
    ## 4:  2018      6.08       1.25       4.83      4.62      5.67       4.83
    ## 5:  2019      5.06       1.15       4.02     18.94     13.83       9.28
    ## 6:  2020      4.36       1.19       3.47      9.86      5.57       4.15
    ## 7:  2021      1.35       0.88       0.52      0.41      0.12       0.05
    ##    ice.max_31 ice.max_4 ice.max_5 ice.max_50 ice.max_6 ice.max_7 sst_1 sst_10
    ##         <num>     <num>     <num>      <num>     <num>     <num> <num>  <num>
    ## 1:       4.71      7.39     29.53       1.32      4.76     11.42  8.60   7.89
    ## 2:       0.02      1.90      8.27       0.54      1.26      0.03  9.19   8.42
    ## 3:       0.21     12.17      9.91       0.79      2.73      0.99  8.27   7.51
    ## 4:       0.84      5.04     16.18       1.10      2.76      1.29  7.66   7.05
    ## 5:       6.20      4.93     27.17       1.14      3.63      4.14  8.57   7.61
    ## 6:       1.42      7.81     17.06       1.35      2.75      1.71  8.48   7.81
    ## 7:       0.07      1.80      6.80       0.65      1.41      0.31 10.02   9.06
    ##    sst_11 sst_2 sst_3 sst_30 sst_31 sst_4 sst_5 sst_50 sst_6 sst_7 t150_1
    ##     <num> <num> <num>  <num>  <num> <num> <num>  <num> <num> <num>  <num>
    ## 1:   8.79  9.17  9.80   9.69  10.04  7.09 11.64  12.10 13.27 10.74   4.09
    ## 2:   9.38  9.22 10.13   9.98  10.48  6.91 11.67  12.12 13.59 11.05   3.66
    ## 3:   8.46  9.12 10.35  10.10  10.95  6.96 11.92  11.63 13.73 11.26   3.50
    ## 4:   7.82  8.55  9.37   9.11  10.04  6.84 11.22  11.33 13.05 10.58   3.09
    ## 5:   8.81  8.55  9.41   9.33   9.57  6.68 11.25  11.54 13.21 10.19   3.53
    ## 6:   8.65  8.95  9.90   9.70  10.41  7.75 11.80  11.81 13.78 11.01   3.46
    ## 7:  10.26 10.51 11.17  11.01  11.53  8.29 12.42  12.93 14.26 11.81   4.01
    ##    t150_10 t150_11 t150_2 t150_3 t150_30 t150_31 t150_4
    ##      <num>   <num>  <num>  <num>   <num>   <num>  <num>
    ## 1:    3.84    4.20   4.01   4.01    4.02    3.96  -0.11
    ## 2:    3.61    3.83   3.15   3.62    3.71    3.78  -0.40
    ## 3:    3.46    3.45   2.01   2.85    2.98    2.75  -1.02
    ## 4:    3.06    3.03   2.83   2.95    3.19    2.49  -0.85
    ## 5:    3.57    3.68   2.94   3.52    3.31    3.46  -0.85
    ## 6:    3.51    3.57   3.59   3.92    3.81    4.38   0.17
    ## 7:    3.95    4.23   4.13   4.16    4.17    4.19   0.98

This wide data now has as many rows as years and as many columns as
variable x EAR. The columns are named with the variable followed by
“\_EAR” to identify the EAR it represents.

## Data plotting

The data plotting function <b>EA.plot.f</b> just queries the EA.data
with <b>EA.query.f</b> and then plots them. It puts all the plots on one
page as a matrix of plots with each row being a variable and each column
being an EAR:

    EA.plot.f(years=1900:2021, variables=c("t150","t250"), EARs=1:4, smoothing=T)

![](README_files/figure-markdown_strict/plotting1-1.png)

It will plot a maximum of 25 plots per page. What you might want to do
is call pdf(“EA.plots.pdf”) xxx dev.off() when doing this and it will
put them all in one pdf in your working directory.

Another example of the plot without smoothing and different graphical
parameters:

    EA.plot.f(years=1900:2021, variables=c("t150", "t.deep", "t250"), EARs=1:4, smoothing=F, pch=20, lwd=2, col="blue", type="b")

![](README_files/figure-markdown_strict/plotting2-1.png)

You can see that if there are no data for the variable by EAR
combination, a blank plot is produced in the plot matrix.

## Finding variables and data

You might be interested in anything to do with large scale oscillation
indices, e.g. North Atlantic Oscillation. These all have an EAR=-1
indicating that the they are measures at scales larger than the EA
regions. You can do search for them with a key word or partial string
and then with that information select the NAO monthly data.

    find.vars.f("oscilla")

    ##  [1] "amo.month1"  "amo.month10" "amo.month11" "amo.month12" "amo.month2" 
    ##  [6] "amo.month3"  "amo.month4"  "amo.month5"  "amo.month6"  "amo.month7" 
    ## [11] "amo.month8"  "amo.month9"  "ao.month1"   "ao.month10"  "ao.month11" 
    ## [16] "ao.month12"  "ao.month2"   "ao.month3"   "ao.month4"   "ao.month5"  
    ## [21] "ao.month6"   "ao.month7"   "ao.month8"   "ao.month9"   "h.nao"      
    ## [26] "nao.month1"  "nao.month10" "nao.month11" "nao.month12" "nao.month2" 
    ## [31] "nao.month3"  "nao.month4"  "nao.month5"  "nao.month6"  "nao.month7" 
    ## [36] "nao.month8"  "nao.month9"  "pdo.month1"  "pdo.month10" "pdo.month11"
    ## [41] "pdo.month12" "pdo.month2"  "pdo.month3"  "pdo.month4"  "pdo.month5" 
    ## [46] "pdo.month6"  "pdo.month7"  "pdo.month8"  "pdo.month9"

    # ah ha, seems that something like "NAO.mon" will do it for us but you don't need to worry about the case
    NAO.vars= find.vars.f("nao.mon")
    #but because variable names are character and you may want them ordered by month you need to sort the names vector
    NAO.vars= NAO.vars[order(nchar(NAO.vars), NAO.vars)]
    EA.plot.f(years=1800:2021, variables=NAO.vars[1:5], EARs=-1, smoothing=T,pch=20)

![](README_files/figure-markdown_strict/plotting4-1.png)

## Discovering relationship between variables in the database

If you have a hunch that one variable may be driving another, you can do
a fairly simple analysis to at least give you a first crack at testing
your hypothesis by using cross correlation (ccf). ccf is a base R
function that looks at the correlation between two variables at
different time lags. It has been repackaged here to query the data from
the EA.data table with the function <b>EA.cor.f</b>.

So let’s assume for this example that you think that sea surface
temperature in the central Gulf (EAR 3) is related to the North Atlantic
Oscillation at some earlier time (<b>climatic</b> variables always have
EAR=-1) but you are not sure what time lag might be most appropriate.
Here you are assuming NAO is the independent variable and, SST is the
dependent variable

    EA.plot.f(variables=c("h.nao","sst"), years=1900:2021, EARs=c(-1,1), smoothing=T,pch=20)

![](README_files/figure-markdown_strict/crosscor1-1.png)

It is hard to say from just pltotting the data because the length of the
time series are quite different. The cross correlation testing at
various temporal lags will probably help you formulate your hypotheses
better.

    EA.cor.f(x="h.nao", y="sst", years=1900:2021, x.EAR=-1, y.EAR=3)

![](README_files/figure-markdown_strict/crosscor2-1.png)

It is a bit of a downer because your best correlations is between NAO
and SST in the same year (0 lag) and the relationship is not that strong
(about -0.3) and not significant.

To imply the causality you are looking for in such an analysis (because
you specified x as the independent variable and y as the dependent), you
are looking for negative or 0 lags. Positive lags suggest that the y
variable is leading the x. These are all just correlations, only your
hypothesis implies causality.

Let’s try an easy one by choosing two variable you know must be related:
SST in EAR 3 (central Gulf) and SST in EAR 1 (NW Gulf).

    EA.cor.f(x="sst",y="sst", years=1900:2021, x.EAR=1, y.EAR=3)

![](README_files/figure-markdown_strict/crosscor3-1.png)

Yes indeed, they are very tightly positively correlated.

An important thing to note with cross correlation is that it will give
the same result as “cor” only with lag 0. That is, if you try truncating
series yourself and then run “cor” between the two series, you will not
get the same result as ccf. This has to do with the normalisation of the
data at the beginning before lagging in ccf. See the help for EA.cor.f
for more details.

## Using down-scaled atmospheric climate projections to predict oceanographic variables

The database contains atmospheric projections from 24 different global
climate models that have been down-scaled to boxes roughly in the same
area as the EARs. The ensemble medians and confidence intervals of
selected variables are provided and for some variables the
distributional characteristics over the ensemble are also provided.
Ideally, we want and will include the direct oceanographic variable
projections under different carbon emission scenarios but this is
detailed work that is currently underway at IML. The atmospheric
variables are provided here in the meantime (and they will remain)
having been downloaded from www.climateatlas.ca (this is an excellent
site, please check it out).

So as an example of what could be done with this, the annual mean
surface temperature for an EAR has been correlated against the deep
water temperature. The linear model resulting from this is not too bad
and could potential inform a semi-trustable projection (or at least
better than guessing). Follow this code as an example of what could be
done.

      EA.cor.f("ann.mean.t.med.rcp45","t.deep",1950:2021,1,1)

![](README_files/figure-markdown_strict/climproject-1.png)

    # lets look from 2009 when the deep water really started warming up, it is a pretty good predictor
      EA.cor.f("ann.mean.t.med.rcp45","t.deep",2009:2021,1,1)

![](README_files/figure-markdown_strict/climproject-2.png)

    # fit a linear model and project that model based on the ensemble median prediction until 2095
      tmp= EA.query.f(c("ann.mean.t.med.rcp45","t.deep"),1950:2100,1)
      tmp2= dcast(tmp, year~variable)
      plot(tmp2$ann.mean.t.med.rcp45,tmp2$t.deep)
      rug(tmp2$ann.mean.t.med.rcp45)

![](README_files/figure-markdown_strict/climproject-3.png)

      pred.lm= lm(t.deep~ann.mean.t.med.rcp45,data=tmp2)
      summary(pred.lm)

    ## 
    ## Call:
    ## lm(formula = t.deep ~ ann.mean.t.med.rcp45, data = tmp2)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.58423 -0.20219 -0.09002  0.16261  0.79366 
    ## 
    ## Coefficients:
    ##                      Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)           3.16055    0.27115  11.656 6.00e-14 ***
    ## ann.mean.t.med.rcp45  0.76053    0.09019   8.433 3.85e-10 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.3269 on 37 degrees of freedom
    ##   (107 observations deleted due to missingness)
    ## Multiple R-squared:  0.6578, Adjusted R-squared:  0.6485 
    ## F-statistic: 71.11 on 1 and 37 DF,  p-value: 3.848e-10

      tmp2$t.deep.pred= predict(pred.lm,newdata=tmp2)
      plot(tmp2$ann.mean.t.med.rcp45,tmp2$t.deep.pred,type="l",col="blue",lwd=3,
           xlab="Annual mean surface temperature down-scaled to EAR 1", ylab= "Bottom temperature of deep (>200 m) waters EAR 1")
      points(tmp2$ann.mean.t.med.rcp45,tmp2$t.deep,pch=20)
      rug(tmp2$ann.mean.t.med.rcp45)
      title(main="RCP 4.5 climate projection until 2095, ensemble median")

![](README_files/figure-markdown_strict/climproject-4.png)

If one thinks it is valid to link the atmospheric variable so closely
with deep water temperature at such scales 70+ years into the future
then it can be a basis for extrapolation. As above, perhaps it is better
than guessing but one needs to put a bit of water in their wine for the
interpretation.

# Source and references for data

It is important to acknowledge to the individuals and organisation who
collected the data and or processed it to come up with the indices that
are presented here. In some cases, this downstream acknowledgement may
be the primary means of showing efficacy of their work so please be
diligent about including citations and acknowledgements in your work.

The function sources.f accept a variable name as an argument. It will
give you the name and or link to the person or organisation responsible
for the data represented by that variable. It will also provide the main
citation for that variable.

    formattable::formattable(sources.f(c("t200","h.nao")))

<table class="table table-condensed">
<thead>
<tr>
<th style="text-align:right;">
variable
</th>
<th style="text-align:right;">
source
</th>
<th style="text-align:right;">
reference
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
h.nao
</td>
<td style="text-align:right;">
<https://climatedataguide.ucar.edu/sites/default/files/nao_station_annual.txt>
</td>
<td style="text-align:right;">
Hurrell, J.W., 1995: Decadal trends in the North Atlantic Oscillation
and relationships to regional temperature and precipitation. Science
269, 676-679.
</td>
</tr>
<tr>
<td style="text-align:right;">
t200
</td>
<td style="text-align:right;">
Peter Galbraith (<peter.galbraith@dfo-mpo.gc.ca>)
</td>
<td style="text-align:right;">
Galbraith, P.S., Chassé, J., Caverhill, C., Nicot, P., Gilbert, D.,
Lefaivre, D. and Lafleur, C. 2018. Physical Oceanographic Conditions in
the Gulf of St. Lawrence during 2017. DFO Can. Sci. Advis. Sec. Res.
Doc. 2018/050. v + 79 p. 
</td>
</tr>
</tbody>
</table>

If you just type source.f() you will get the person/organisation
responsible and main reference for all variables in the database.

# Forget the R-package, I just want the data

You are not obliged to use this R-package if you just want the data. The
data table and variable description table have been merged and written
to an excel file sheet. The field descriptions have been written to
another sheet in the same excel file. This will be downloaded as part of
the R package from github but you can access just that file directly
from the gslea github root directory if you do not want to download the
R package. It is call “<b>EAdata.dump.xlsx</b>”. You might just download
it and filter the variable column or other columns to choose the data
you want from excel. This file is automatically updated everytime the
gslea library is updated so there should be no discrepency in the data
from the two places.

Please do not forget to acknowledge the sources of the data and cite the
appropriate references that are included in the excel file.

# Citation for this package

Daniel E Duplisea, Marie-Julie Roux, Stéphane Plourde, Peter S
Galbraith, Marjolaine Blais, Hugues P Benoît, Bernard Sainte-Marie,
Diane Lavoie, Hugo Bourdages, Facilitating an ecosystem approach through
open data and information packaging, ICES Journal of Marine Science,
Volume 81, Issue 4, May 2024, Pages 724–732,
<https://doi.org/10.1093/icesjms/fsae024>

<https://github.com/duplisea/gslea>.

# References

Edwards, A.M., Duplisea, D.E., Grinnell, M.H., Anderson, S.C., Grandin,
C.J., Ricard, D., Keppel, E.A., Anderson, E.D., Baker, K.D., Benoît,
H.P., Cleary, J.S., Connors, B.M., Desgagnés, M., English, P.A.,
Fishman, D.J., Freshwater, C., Hedges, K.J., Holt, C.A., Holt, K.R.,
Kronlund, A.R., Mariscak, A., Obradovich, S.G., Patten, B.A., Rogers,
B., Rooper, C.N., Simpson, M.R., Surette, T.J., Tallman, R.F., Wheeland,
L.J., Wor, C., and Zhu, X. 2018. Proceedings of the Technical Expertise
in Stock Assessment (TESA) national workshop on ‘Tools for transparent,
traceable, and transferable assessments,’ 27–30 November 2018 in
Nanaimo, British Columbia. Can. Tech. Rep. Fish. Aquat. Sci. 3290: v +
10 p. <https://waves-vagues.dfo-mpo.gc.ca/Library/40750152.pdf>
