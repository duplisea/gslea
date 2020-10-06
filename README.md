-   [What is it?](#what-is-it)
-   [Quick start](#quick-start)
-   [Purpose](#purpose)
-   [Data coverage](#data-coverage)
-   [Design](#design)
-   [Components of gslea](#components-of-gslea)
    -   [Data objects](#data-objects)
    -   [Functions](#functions)
-   [Installing gslea](#installing-gslea)
-   [Accessing the data](#accessing-the-data)
    -   [Data content overviews](#data-content-overviews)
    -   [Data extraction](#data-extraction)
        -   [Recasting data and showing when there were no
            observations](#recasting-data-and-showing-when-there-were-no-observations)
    -   [Data plotting](#data-plotting)
    -   [Finding variables and data](#finding-variables-and-data)
    -   [Discovering relationship between variables in the
        database](#discovering-relationship-between-variables-in-the-database)
    -   [Using down-scaled atmospheric climate projections to predict
        oceanographic
        variables](#using-down-scaled-atmospheric-climate-projections-to-predict-oceanographic-variables)
-   [Source and references for data](#source-and-references-for-data)
-   [Forget the R-package, I just want the
    data](#forget-the-r-package-i-just-want-the-data)
-   [Updating the package](#updating-the-package)
    -   [Computing requirements for
        updating](#computing-requirements-for-updating)
    -   [Raw data](#raw-data)
    -   [Running the update script](#running-the-update-script)
    -   [Updating the R package](#updating-the-r-package)
        -   [Compiling documentation](#compiling-documentation)
        -   [Making the R package](#making-the-r-package)
-   [Project participants (past and
    present)](#project-participants-past-and-present)
-   [If you have issues](#if-you-have-issues)
-   [Citation](#citation)

What is it?
===========

An R package to house Gulf of St Lawrence environment and ecosystem data
to promote ecosystem research and analysis in the Gulf of St Lawrence
and move us closer to an ecosystem approach to fisheries. It should be
readily understandable to a large swath of the research community who
have extensive or minimal R skills.

Currently version 0.1 - beta. It will not be fixed until version 1
afterwhich updates should not break existing analyses. That could still
happen now with updates.

Quick start
===========

Open R and install the gslea package and try some commands outlined in
?gslea:

    devtools::install_github("duplisea/gslea", build_vignettes = TRUE)
    library(gslea)
    ?gslea

Purpose
=======

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

Data coverage
=============

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

<img src="README_files/figure-markdown_strict/gslmap.plain-1.png" style="width:100.0%" />

Design
======

The package is GPL-3 licenced and thus is available globally without
warranty. The package is designed to have as few data containers as
possible and in a common and consistent format to allow generic
extraction. The package has only one dependence which is the library
data.table and data.table itself has no dependencies. The data.table
library is used because of its efficient use of computing resources
making it very fast for processing data
(<a href="https://h2oai.github.io/db-benchmark/" class="uri">https://h2oai.github.io/db-benchmark/</a>)
which is important if in someone’s analysis they make repeated queries
to the data in loops or in bootstrapping directly from the full
database. The data are structured in what has become termed “tidy data”
for people in the tidyverse as opposed to dirty data I suppose. You can
use your own tidyverse code on it. The data class “data.table” inherit a
secondary class of data.frame, therefore they are compatible with most
of the base R data.frame operations. The package is designed such that
it is consistent, should be scalable to when new data types become
available and should not break existing analyses when updated (I hope).

Components of gslea
===================

Data objects
------------

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

Functions
---------

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
(“physical”, “chemical”, “planktonic”, “phenologic”, “climatic”), gives
a description of each and its units.

<ins>
find.vars.f(search.term)
</ins>

finds variable names based on partial matches. It search not just the
variable names but also their descriptions, sources and references.

<ins>
EA.query.f(variables, years, EARs)
</ins>

the function you use to query the data and the output is in long data
format. <b>variables</b> (e.g. “T150”,“SST”) is a character vector,
<b>years</b> is a numeric vector (e.g. 2002:2012), <b>EARs</b> is the
ecoregion and is a numeric vector (e.g. 1:3).

<ins>
EA.plot.f(variables, years, EARs, …)
</ins>

this will plot the variables over time. It will make a matrix of
variable x EAR with up to 25 plots per page (i.e. 25 variable\*EAR
combinations). <b>variables</b> (e.g. “T150”) is a character vector,
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

Installing gslea
================

    devtools::install_github("duplisea/gslea", build_vignettes = TRUE)
    library(gslea)

Accessing the data
==================

Data content overviews
----------------------

A few minimal extraction functions are provided that should be fast and
relatively generic. A function called <b>metadata.f</b> is provided with
three levels of verbosity to give you an overview. “low” verbosity just
gives a few stats on the size of the database and the number of
variables and EARs. “med” verbosity will give you names of variables and
units. “high” is not that useful because it pretty well outputs the
entire content of the variable.description table.

    metadata.f(verbosity="low")

    ## $Number.of.variables
    ## [1] 304
    ## 
    ## $Number.of.EARS
    ## [1] 10
    ## 
    ## $Number.of.years
    ## [1] 244
    ## 
    ## $First.and.last.year
    ## [1] NA NA
    ## 
    ## $Number.of.observations
    ## [1] 129376

Another perhaps more useful way to know what the database contains is
with the function <b>var.f</b>. <b>var.f</b> accepts as an argument one
of the data types with the default being “all”. The options are the
adjectives for a data type: “physical”, “chemical”, “planktonic”,
“phenological” which for some data types seems awkward but it is
consistent. It will give you the exact name of the variable, its
description and units. The output can be long and the descriptions are
sometimes quite wordy so it is difficult to read. I suggest you save the
result of a large query to var.f as an object and then use the library
formattable to make it into a more readable table. So for example
formattable, e.g.:

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
CIL.vol.LT.1
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
SST
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
SST.anomaly
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
SST.month10
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
SST.month11
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
SST.month5
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
SST.month6
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
SST.month7
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
SST.month8
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
SST.month9
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
T.deep
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Bottom temperature in waters &gt; 200m deep
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
T.shallow
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Bottom temperature in waters &lt; 200m deep
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
T150
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Temperature at 150 m
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
T200
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Temperature at 200 m
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
T250
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Temperature at 250 m
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
T300
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Temperature at 300 m
</td>
<td style="text-align:right;">
degrees celsius
</td>
</tr>
<tr>
<td style="text-align:right;">
Tmax200.400
</td>
<td style="text-align:right;">
physical
</td>
<td style="text-align:right;">
Maximum temperature between 200 and 400 m
</td>
<td style="text-align:right;">
degrees celsius
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
</tbody>
</table>

You can also try to find a variable through partial matching of a term
(case insensitive). So for example if you were interested in just
temperature you might search “temp”. Or anything that is from 300m deep
then search “300”. It will then give you a list of variable that have
that term in their description.

    find.vars.f(search.term= "200")

    ##  [1] "J.GSNW.Q1"   "J.GSNW.Q2"   "J.GSNW.Q3"   "J.GSNW.Q4"   "T.deep"     
    ##  [6] "T.shallow"   "T200"        "Tmax200.400" "AMO.month1"  "AMO.month10"
    ## [11] "AMO.month11" "AMO.month12" "AMO.month2"  "AMO.month3"  "AMO.month4" 
    ## [16] "AMO.month5"  "AMO.month6"  "AMO.month7"  "AMO.month8"  "AMO.month9" 
    ## [21] "PDO.month1"  "PDO.month10" "PDO.month11" "PDO.month12" "PDO.month2" 
    ## [26] "PDO.month3"  "PDO.month4"  "PDO.month5"  "PDO.month6"  "PDO.month7" 
    ## [31] "PDO.month8"  "PDO.month9"

You will see that T.deep and T.shallow come up in this because in their
descriptions, the distinction between shallow and deep waters is 200m.
You will also see AMO variable coming up and this is because the
reference for the AMO was published in 2001 and 200 is a substring of
that. So you can see it will find things fairly broadly

This search function will search most of the main fields of the
variable.description table. So for example you may be interested in
products which Peter Galbraith was involved with so you could try
find.vars.f(search.term= “galbra”) or say something to do with plankon
blooms find.vars.f(“bloom”).

Data extraction
---------------

Extracting the data is done with a single function called
<b>EA.query.f</b>. This query wants a character vector or scalar for
variable, an integer vector or scalar for year and an integer vector or
scalar for EAR:

    EA.query.f(years=1999:2012, variables=c("T150", "ph_bot.fall", "T250"), EARs=1:2)

    ##     year EAR    variable    value
    ##  1: 1999   1        T150 3.170000
    ##  2: 2000   1        T150 3.100000
    ##  3: 2001   1        T150 3.290000
    ##  4: 2002   1        T150 3.320000
    ##  5: 2003   1        T150 2.880000
    ##  6: 2004   1        T150 3.030000
    ##  7: 2005   1        T150 3.030000
    ##  8: 2006   1        T150 3.580000
    ##  9: 2007   1        T150 2.970000
    ## 10: 2008   1        T150 2.920000
    ## 11: 2009   1        T150 2.920000
    ## 12: 2010   1        T150 2.710000
    ## 13: 2011   1        T150 3.140000
    ## 14: 2012   1        T150 3.380000
    ## 15: 1999   2        T150 3.100000
    ## 16: 2000   2        T150 2.880000
    ## 17: 2001   2        T150 2.480000
    ## 18: 2002   2        T150 2.780000
    ## 19: 2003   2        T150 2.060000
    ## 20: 2004   2        T150 2.100000
    ## 21: 2005   2        T150 2.450000
    ## 22: 2006   2        T150 3.110000
    ## 23: 2007   2        T150 2.320000
    ## 24: 2008   2        T150 1.930000
    ## 25: 2009   2        T150 2.140000
    ## 26: 2010   2        T150 2.650000
    ## 27: 2011   2        T150 2.690000
    ## 28: 2012   2        T150 3.150000
    ## 29: 1999   1        T250 5.060000
    ## 30: 2000   1        T250 4.960000
    ## 31: 2001   1        T250 5.050000
    ## 32: 2002   1        T250 5.130000
    ## 33: 2003   1        T250 5.170000
    ## 34: 2004   1        T250 5.220000
    ## 35: 2005   1        T250 5.220000
    ## 36: 2006   1        T250 5.260000
    ## 37: 2007   1        T250 5.200000
    ## 38: 2008   1        T250 5.050000
    ## 39: 2009   1        T250 5.000000
    ## 40: 2010   1        T250 4.870000
    ## 41: 2011   1        T250 4.980000
    ## 42: 2012   1        T250 5.090000
    ## 43: 1999   2        T250 5.390000
    ## 44: 2000   2        T250 5.580000
    ## 45: 2001   2        T250 5.590000
    ## 46: 2002   2        T250 5.750000
    ## 47: 2003   2        T250 5.750000
    ## 48: 2004   2        T250 5.700000
    ## 49: 2005   2        T250 5.510000
    ## 50: 2006   2        T250 5.640000
    ## 51: 2007   2        T250 5.730000
    ## 52: 2008   2        T250 5.340000
    ## 53: 2009   2        T250 5.060000
    ## 54: 2010   2        T250 5.140000
    ## 55: 2011   2        T250 5.520000
    ## 56: 2012   2        T250 5.890000
    ## 57: 2009   1 ph_bot.fall 7.670815
    ## 58: 2011   1 ph_bot.fall 7.652947
    ## 59: 2011   2 ph_bot.fall 7.700699
    ##     year EAR    variable    value

You need to name all the variables you want to extract but you can
access all the years or all the EARs by putting a wide range on them

    EA.query.f(years=1900:2020, variables=c("T150", "ph_bot.fall", "T250"), EARs=1:99)

    ##      year EAR    variable    value
    ##   1: 1969   1        T150 2.640000
    ##   2: 1970   1        T150 2.950000
    ##   3: 1971   1        T150 3.350000
    ##   4: 1974   1        T150 2.970000
    ##   5: 1979   1        T150 4.330000
    ##  ---                              
    ## 298: 2014   5 ph_bot.fall 7.779244
    ## 299: 2015   5 ph_bot.fall 7.744043
    ## 300: 2016   5 ph_bot.fall 7.797067
    ## 301: 2017   5 ph_bot.fall 7.788932
    ## 302: 2018   5 ph_bot.fall 7.845360

You may want to save the results of a query to an object and then export
it to csv (<b>fwrite</b>) or some other format.

### Recasting data and showing when there were no observations

The data are in long format (tidyverse speak = “tidy data”) which is the
common way to store data in databases. It means that for a variable x
year x EAR comination where there is no observation, there is not a row
in the database either. If you want tabular data (wide) to show when say
and observation was not made for a particular year and variable and EAR,
then you can widen the data using the “dcast” function from data.table

    dat= EA.query.f(years=1900:2020, variables=c("T150","ph_bot.fall","ice.max","O2.Late_summer.sat.mean50_100"), EARs=1)
    dcast(dat, year~ variable)

    ##     year T150 ice.max O2.Late_summer.sat.mean50_100 ph_bot.fall
    ##  1: 1969 2.64    4.03                            NA          NA
    ##  2: 1970 2.95    6.27                            NA          NA
    ##  3: 1971 3.35   12.18                            NA          NA
    ##  4: 1972   NA   10.13                            NA          NA
    ##  5: 1973   NA    8.74                            NA          NA
    ##  6: 1974 2.97    8.47                            NA          NA
    ##  7: 1975   NA    7.24                            NA          NA
    ##  8: 1976   NA    7.21                            NA          NA
    ##  9: 1977   NA    8.86                            NA          NA
    ## 10: 1978   NA   10.05                            NA          NA
    ## 11: 1979 4.33   15.36                            NA          NA
    ## 12: 1980   NA    4.38                            NA          NA
    ## 13: 1981   NA    8.63                            NA          NA
    ## 14: 1982   NA    5.46                            NA          NA
    ## 15: 1983   NA    7.84                            NA          NA
    ## 16: 1984   NA    8.44                            NA          NA
    ## 17: 1985   NA    6.17                            NA          NA
    ## 18: 1986   NA    5.97                            NA          NA
    ## 19: 1987 3.12    7.95                            NA          NA
    ## 20: 1988 3.36   10.11                            NA          NA
    ## 21: 1989   NA    5.77                            NA          NA
    ## 22: 1990 2.76    6.85                            NA          NA
    ## 23: 1991 1.71    5.74                            NA          NA
    ## 24: 1992 2.11   10.52                            NA          NA
    ## 25: 1993 2.21   11.74                            NA          NA
    ## 26: 1994 2.86    7.60                            NA          NA
    ## 27: 1995 2.23   11.42                            NA          NA
    ## 28: 1996 2.21    8.84                            NA          NA
    ## 29: 1997 2.62    7.34                            NA          NA
    ## 30: 1998 2.98    5.13                            NA          NA
    ## 31: 1999 3.17    5.27                            NA          NA
    ## 32: 2000 3.10    4.64                            NA          NA
    ## 33: 2001 3.29    4.66                            NA          NA
    ## 34: 2002 3.32    7.43                      74.62483          NA
    ## 35: 2003 2.88    4.53                      77.94894          NA
    ## 36: 2004 3.03    4.91                      79.23847          NA
    ## 37: 2005 3.03    7.67                      75.06227          NA
    ## 38: 2006 3.58    3.22                      69.31014          NA
    ## 39: 2007 2.97    2.31                      78.79188          NA
    ## 40: 2008 2.92    9.61                      79.47174          NA
    ## 41: 2009 2.92    5.48                      77.52256    7.670815
    ## 42: 2010 2.71    1.85                      79.09986          NA
    ## 43: 2011 3.14    1.99                      78.65502    7.652947
    ## 44: 2012 3.38    3.94                      76.33686          NA
    ## 45: 2013 3.26    2.44                      80.67675          NA
    ## 46: 2014 3.34    7.47                      83.08551    7.646517
    ## 47: 2015 4.19    9.12                      77.00939    7.666830
    ## 48: 2016 4.26    3.06                      73.53504    7.633863
    ## 49: 2017 3.81    3.81                      76.16029    7.612828
    ## 50: 2018 3.24    6.08                      82.21718    7.640820
    ## 51: 2019 3.64    4.76                            NA          NA
    ##     year T150 ice.max O2.Late_summer.sat.mean50_100 ph_bot.fall

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

    dat= EA.query.f(years=2015:2020, variables=c("T150","ph_bot.fall","ice.max","O2.Late_summer.sat.mean50_100"), EARs=1:100)
    dcast(dat, year~ variable+EAR)

    ##    year T150_1 T150_2 T150_3 T150_4 ice.max_1 ice.max_2 ice.max_3 ice.max_4
    ## 1: 2015   4.19   3.69   4.01   0.33      9.12     15.42     12.98      7.39
    ## 2: 2016   4.26   3.60   4.03  -0.21      3.06      2.22      1.21      1.90
    ## 3: 2017   3.81   2.16   3.35  -0.92      3.81      5.98      1.41     12.17
    ## 4: 2018   3.24   2.32   2.72  -0.19      6.08      4.62      5.67      5.04
    ## 5: 2019   3.64   3.14   3.66  -0.32      4.76     18.94     13.83      4.93
    ##    ice.max_5 ice.max_6 ice.max_7 ice.max_10 ice.max_50
    ## 1:     29.53      4.76     11.41       1.85       1.32
    ## 2:      8.27      1.26      0.03       0.74       0.54
    ## 3:      9.28      2.73      0.99       0.94       0.79
    ## 4:     16.18      2.76      1.29       1.25       1.07
    ## 5:     27.17      3.63      4.14       1.15       1.14
    ##    O2.Late_summer.sat.mean50_100_1 O2.Late_summer.sat.mean50_100_2
    ## 1:                        77.00939                        88.50907
    ## 2:                        73.53504                        89.20817
    ## 3:                        76.16029                        88.95445
    ## 4:                        82.21718                        91.13842
    ## 5:                              NA                              NA
    ##    O2.Late_summer.sat.mean50_100_3 O2.Late_summer.sat.mean50_100_4
    ## 1:                        85.78378                        90.53384
    ## 2:                        86.30571                        91.21765
    ## 3:                        86.48652                        90.02184
    ## 4:                        88.21394                        93.54802
    ## 5:                              NA                              NA
    ##    O2.Late_summer.sat.mean50_100_10 ph_bot.fall_1 ph_bot.fall_2 ph_bot.fall_3
    ## 1:                         78.11792      7.666830      7.816374      7.763617
    ## 2:                         70.87260      7.633863      7.761814      7.744903
    ## 3:                         77.69411      7.612828      7.733547      7.753033
    ## 4:                         83.13097      7.640820      7.734545      7.766139
    ## 5:                               NA            NA            NA            NA
    ##    ph_bot.fall_5 ph_bot.fall_10
    ## 1:      7.744043       7.584211
    ## 2:      7.797067       7.572334
    ## 3:      7.788932       7.561805
    ## 4:      7.845360       7.592093
    ## 5:            NA             NA

This wide data now has as many rows as years and as many columns as
variable x EAR. The columns are named with the variable followed by
"\_EAR" to identify the EAR it represents.

Data plotting
-------------

The data plotting function <b>EA.plot.f</b> just queries the EA.data
with <b>EA.query.f</b> and then plots them. It puts all the plots on one
page as a matrix of plots with each row being a variable and each column
being an EAR:

    EA.plot.f(years=1900:2020, variables=c("T150", "ph_bot.fall", "T250"), EARs=1:4, smoothing=T)

![](README_files/figure-markdown_strict/plotting1-1.png)

It will plot a maximum of 25 plots per page. What you might want to do
is call pdf(“EA.plots.pdf”) xxx dev.off() when doing this and it will
put them all in one pdf in your working directory.

Another example of the plot without smoothing and different graphical
parameters:

    EA.plot.f(years=1900:2020, variables=c("T150", "ph_bot.fall", "T250"), EARs=1:4, smoothing=F, pch=20, lwd=2, col="blue", type="b")

![](README_files/figure-markdown_strict/plotting2-1.png)

You can see that if there are no data for the variable by EAR
combination, a blank plot is produced in the plot matrix.

You may want to plot all variables of a particular type. You can do this
by selecting the variables with the vars.f function and selecting just
the <b>variable</b> column from its output using “$”

    EA.plot.f(years=1900:2020, variables=vars.f(variable.type="phenological")$variable, EARs=1:2, smoothing=T)

![](README_files/figure-markdown_strict/plotting3-1.png)

Finding variables and data
--------------------------

You might be interested in anything to do with large scale oscillation
indices, e.g. North Atlantic Oscillation. These all have an EAR=-1
indicating that the they are measures at scales larger than the EA
regions. You can do search for them with a key word or partial string
and then with that information select the NAO monthly data.

    find.vars.f("oscilla")

    ##  [1] "AMO.month1"  "AMO.month10" "AMO.month11" "AMO.month12" "AMO.month2" 
    ##  [6] "AMO.month3"  "AMO.month4"  "AMO.month5"  "AMO.month6"  "AMO.month7" 
    ## [11] "AMO.month8"  "AMO.month9"  "AO.month1"   "AO.month10"  "AO.month11" 
    ## [16] "AO.month12"  "AO.month2"   "AO.month3"   "AO.month4"   "AO.month5"  
    ## [21] "AO.month6"   "AO.month7"   "AO.month8"   "AO.month9"   "H.NAO"      
    ## [26] "NAO.month1"  "NAO.month10" "NAO.month11" "NAO.month12" "NAO.month2" 
    ## [31] "NAO.month3"  "NAO.month4"  "NAO.month5"  "NAO.month6"  "NAO.month7" 
    ## [36] "NAO.month8"  "NAO.month9"  "PDO.month1"  "PDO.month10" "PDO.month11"
    ## [41] "PDO.month12" "PDO.month2"  "PDO.month3"  "PDO.month4"  "PDO.month5" 
    ## [46] "PDO.month6"  "PDO.month7"  "PDO.month8"  "PDO.month9"

    # ah ha, seems that something like "NAO.mon" will do it for us but you don't need to worry about the case
    NAO.vars= find.vars.f("nao.mon")
    #but because variable names are character and you may want them ordered by month you need to sort the names vector
    NAO.vars= NAO.vars[order(nchar(NAO.vars), NAO.vars)]
    EA.plot.f(years=1800:2020, variables=NAO.vars[1:5], EARs=-1, smoothing=T,pch=20)

![](README_files/figure-markdown_strict/plotting4-1.png)

Discovering relationship between variables in the database
----------------------------------------------------------

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

    EA.plot.f(variables=c("H.NAO","SST"), years=1900:2020, EARs=c(-1,3), smoothing=T,pch=20)

![](README_files/figure-markdown_strict/crosscor1-1.png)

It is hard to say from just plotting the data because the length of the
time series are quite different. The cross correlation testing at
various temporal lags will probably help you formulate your hypotheses
better.

    EA.cor.f(x="H.NAO", y="SST", years=1900:2020, x.EAR=-1, y.EAR=3)

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

    EA.cor.f(x="SST",y="SST", years=1900:2020, x.EAR=1, y.EAR=3)

![](README_files/figure-markdown_strict/crosscor3-1.png)

Yes indeed, they are very tightly positively correlated.

An important thing to note with cross correlation is that it will give
the same result as “cor” only with lag 0. That is, if you try truncating
series yourself and then run “cor” between the two series, you will not
get the same result as ccf. This has to do with the normalisation of the
data at the beginning before lagging in ccf. See the help for EA.cor.f
for more details.

Using down-scaled atmospheric climate projections to predict oceanographic variables
------------------------------------------------------------------------------------

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

      EA.cor.f("Ann.mean.T.med.RCP45","T.deep",1950:2020,1,1)

![](README_files/figure-markdown_strict/climproject-1.png)

    # lets look from 2009 when the deep water really started warming up, it is a pretty good predictor
      EA.cor.f("Ann.mean.T.med.RCP45","T.deep",2009:2020,1,1)

![](README_files/figure-markdown_strict/climproject-2.png)

    # fit a linear model and project that model based on the ensemble median prediction until 2095
      tmp= EA.query.f(c("Ann.mean.T.med.RCP45","T.deep"),1950:2100,1)
      tmp2= dcast(tmp, year~variable)
      plot(tmp2$Ann.mean.T.med.RCP45,tmp2$T.deep)
      rug(tmp2$Ann.mean.T.med.RCP45)

![](README_files/figure-markdown_strict/climproject-3.png)

      pred.lm= lm(T.deep~Ann.mean.T.med.RCP45,data=tmp2)
      summary(pred.lm)

    ## 
    ## Call:
    ## lm(formula = T.deep ~ Ann.mean.T.med.RCP45, data = tmp2)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.42450 -0.15178 -0.05905  0.08596  0.58004 
    ## 
    ## Coefficients:
    ##                      Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)           3.66998    0.22421  16.368  < 2e-16 ***
    ## Ann.mean.T.med.RCP45  0.55454    0.07796   7.113 5.43e-08 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.2393 on 31 degrees of freedom
    ##   (113 observations deleted due to missingness)
    ## Multiple R-squared:  0.6201, Adjusted R-squared:  0.6078 
    ## F-statistic: 50.59 on 1 and 31 DF,  p-value: 5.427e-08

      tmp2$T.deep.pred= predict(pred.lm,newdata=tmp2)
      plot(tmp2$Ann.mean.T.med.RCP45,tmp2$T.deep.pred,type="l",col="blue",lwd=3,
           xlab="Annual mean surface temperature down-scaled to EAR 1", ylab= "Bottom temperature of deep (>200 m) waters EAR 1")
      points(tmp2$Ann.mean.T.med.RCP45,tmp2$T.deep,pch=20)
      rug(tmp2$Ann.mean.T.med.RCP45)
      title(main="RCP 4.5 climate projection until 2095, ensemble median")

![](README_files/figure-markdown_strict/climproject-4.png) If one thinks
it is valid to link the atmospheric variable so closely with deep water
temperature at such scales 70+ years into the future then it can be a
basis for extrapolation. As above, perhaps it is better than guessing
but one needs to put a bit of water in their wine for the
interpretation.

Source and references for data
==============================

It is important to acknowledge to the individuals and organisation who
collected the data and or processed it to come up with the indices that
are presented here. In some cases, this downstream acknowledgement may
be the primary means of showing efficacy of their work so please be
diligent about including citations and acknowledgements in your work.

The function sources.f accept a variable name as an argument. It will
give you the name and or link to the person or organisation responsible
for the data represented by that variable. It will also provide the main
citation for that variable.

    formattable::formattable(sources.f(c("T200","H.NAO","O2.Fall.DOXY2.bottom")))

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
H.NAO
</td>
<td style="text-align:right;">
<a href="https://climatedataguide.ucar.edu/sites/default/files/nao_station_annual.txt" class="uri">https://climatedataguide.ucar.edu/sites/default/files/nao_station_annual.txt</a>
</td>
<td style="text-align:right;">
Hurrell, J.W., 1995: Decadal trends in the North Atlantic Oscillation
and relationships to regional temperature and precipitation. Science
269, 676-679.
</td>
</tr>
<tr>
<td style="text-align:right;">
O2.Fall.DOXY2.bottom
</td>
<td style="text-align:right;">
Marjolaine Blais
(<a href="mailto:marjolaine.blais@dfo-mpo.gc.ca" class="email">marjolaine.blais@dfo-mpo.gc.ca</a>)
</td>
<td style="text-align:right;">
Blais, M., Galbraith, P.S., Plourde, S., Scarratt, M., Devine, L. and
Lehoux, C. 2019. Chemical and Biological Oceanographic Conditions in the
Estuary and Gulf of St. Lawrence during 2017. DFO Can. Sci. Advis. Sec.
Res. Doc. 2019/009. iv + 56 pp. 
</td>
</tr>
<tr>
<td style="text-align:right;">
T200
</td>
<td style="text-align:right;">
Peter Galbraith
(<a href="mailto:peter.galbraith@dfo-mpo.gc.ca" class="email">peter.galbraith@dfo-mpo.gc.ca</a>)
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

Forget the R-package, I just want the data
==========================================

You are not obliged to use this R-package if you want the data. The data
table and variable description table have been merged and written to an
excel file sheet. The field descriptions have been written to another
sheet in the same excel file. This will be downloaded as part of the R
package from github but you can access just that file directly from the
gslea github root directory if you do not want to download the R
package. It is call “<b>EAdata.dump.xlsx</b>”. You might just download
it and filter the variable column or other columns to choose the data
you want from excel. This file is automatically updated everytime the
gslea library is updated so there should be no discrepency in the data
from the two places.

Please do not forget to acknowledge the sources of the data and cite the
appropriate references that are included in the excel file.

Updating the package
====================

<mark>Unless you need to update this database, you do not need to read
this</mark>

It is important that the database can be updated consistently and
quickly. This is done through a series of system calls to bash while
running R in linux using text processing programs like awk and sed and
then manipulation in R.

To update the package you will need the standard packages for doing it
like roxygen and devtools.

Computing requirements for updating
-----------------------------------

This package requires linux to update. The reason linux is needed is
because it uses BASH system calls and programs like awk and sed to
pre-process data to make names consisitent, e.g. “Year” to “year” or
other inconsistencies between how raw data is provided by different
people. If data gets provided by people differently between updates then
this will require updating of these scripts.

Once the data are processed and brought into the R package, then it
should be useable by any platform that runs R but I would not know how
to process the raw data in windows. You may be able to do this in
windows10 powershell but I have never tried it so I cannot say it will
work. I do note that powershell does not have “sed” installed by default
and you cannot run R from powershell so I am not sure you could send R
systemcalls to the powershell and if you can the script will fail
without “sed”.

Raw data
--------

Raw data has been provided in various forms by individual data
providers. Sometimes it is in tabular format while other times it is in
a long format. We need to turn it all into long format and this also
involves standardising variable names.

Running the update script
-------------------------

The update script is XXXX which is run from R. It makes system calls to
the working directory you set. That working directory can be anywhere on
your machine and you need to make sure there are sub-directories of that
which are named by the data provider. So Peter Galbraith has supplied
the physical oceanographic data and therefore the subdirectory is called
galbraith. His raw .dat files are located there. These are text files of
a sort that Peter extracts with commented (\#) header lines describing
the data and finishing with the data itself. Marjolaine Blais has
supplied the chemical, planktonic and phenological variables is various
forms. The subdirectory blais also has subdirectories for zooplankton,
oxygen, pH etc. Aside from the data itself, the two other tables need to
be imported into R. These sheets in an excel file describing the data.
At first I was pulling this information from the headers but there were
a lot of differences and this was creating very one-off fragile scripts
that I knew would likely break on each update. Therefore, the excel
sheets have been created to keep this information. You will need to edit
them in excel. The good thing is that all you will have to alter for a
simple update is the extraction date. If you add new variables though,
you will need to add a new line with all the information about that
variable.

If this is all in order on your machine, you just need to run the update
script in the R command line. The script will manipulate the data and
save each data.table as an .rda file in your data directory for the R
package.

I doubt it will go this smoothly but I hope so.

Updating the R package
----------------------

### Compiling documentation

If you changed the documentation for the datasets or functions, you need
to recompile the documentation using roxygen2.

### Making the R package

Clean and rebuild

Project participants (past and present)
=======================================

Jérôme Beaulieu, Hugues Benoît, Marjolaine Blais, Hugo Bourdages, Daniel
Duplisea, Peter Galbraith, Mike Hammill, Cédric Juillet, David Merette,
Stéphane Plourde, Marie-Julie Roux, Bernard Sainte-Marie, Antoine
Rivierre

If you have issues
==================

For comments, questions, bugs etc, you can send this to the package
maintainer, Daniel Duplisea, by email
(<a href="mailto:daniel.duplisea@gmail.com" class="email">daniel.duplisea@gmail.com</a>)
or file a bug report or issue on github.

Citation
========

Duplisea, DE. 2020. Gulf of St Lawrence ecosystem approach: gslea. R
package version 0.1
<a href="https://github.com/duplisea/gslea" class="uri">https://github.com/duplisea/gslea</a>.
