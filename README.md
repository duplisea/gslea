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
-   [Updating the package](#updating-the-package)
    -   [Computing requirements for
        updating](#computing-requirements-for-updating)
    -   [Raw data](#raw-data)
    -   [Running the update script](#running-the-update-script)
    -   [Updating the R package](#updating-the-r-package)
        -   [Compiling documentation](#compiling-documentation)
        -   [Making the R package](#making-the-r-package)
-   [Project participants](#project-participants)
-   [If you have issues](#if-you-have-issues)
-   [Citation](#citation)

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
data are provided spatially by the GSL ecoregions determined in Quebec
Region in Spring 2019 (Fig. 1).

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
secondary class of data.frame, therefore they are compatible with all
the base R data.frame operations. The package is designed such that it
is consistent, should be scalable to when new data types become
available and should not break existing analyses when updated (I hope).

Components of gslea
===================

Data objects
------------

The package consists of three tables presently:

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

Functions
---------

The package consists of just four functions:

<ins>
metadata.f(verbosity)
</ins>

a description of the data available with three levels of
<b>verbosity</b> (“low” “med”, “high”) or information on everyone’s
favourite Dutch post-impressionist (lowercase no spaces).

<ins>
vars.f(variable.type)
</ins>

shows the variables available in a particular <b>variable.type</b>
(“physical”, “chemical”, “planktonic”, “phenologic”), gives a
description of each and its units.

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
    ## [1] 110
    ## 
    ## $Number.of.EARS
    ## [1] 9
    ## 
    ## $Number.of.years
    ## [1] 56
    ## 
    ## $First.and.last.year
    ## [1] 1964 2019
    ## 
    ## $Number.of.observations
    ## [1] 15099

Another perhaps more useful way to know what the database contains is
with the function <b>var.f</b>. <b>var.f</b> accepts as an argument one
of the data types with the default being “all”. The options are the
adjectives for a data type: “physical”, “chemical”, “planktonic”,
“phenological” which for some data types seems awkward but it is
consistent. It will give you the extact name of the variable, its
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
day of the year
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
day of the year
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
days
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
day of the year
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
day of the year
</td>
</tr>
</tbody>
</table>

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
access all the years or all the EARs by putting a wide range on them:

    EA.query.f(years=1900:2020, variables=c("T150", "ph_bot.fall", "T250"), EARs=1:99)

    ##      year EAR    variable    value
    ##   1: 1969   1        T150 2.640000
    ##   2: 1970   1        T150 2.950000
    ##   3: 1971   1        T150 3.350000
    ##   4: 1974   1        T150 2.970000
    ##   5: 1979   1        T150 4.330000
    ##  ---                              
    ## 291: 2014   5 ph_bot.fall 7.779244
    ## 292: 2015   5 ph_bot.fall 7.744043
    ## 293: 2016   5 ph_bot.fall 7.797067
    ## 294: 2017   5 ph_bot.fall 7.788932
    ## 295: 2018   5 ph_bot.fall 7.845360

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
    ## 50: 2018 3.26    6.08                      82.21718    7.640820
    ## 51: 2019   NA    4.76                            NA          NA
    ##     year T150 ice.max O2.Late_summer.sat.mean50_100 ph_bot.fall

This puts each variable as a separate column, it preserves all the years
where at least one of the variables had an observation and it puts NA
for variable x year combinations where there was no observation.

It is important to know that when you do this as above, you are
effectively make a table of year x variable, i.e. you make it two
dimensional. So if you have more than 1 EAR, your initial data are three
dimensional and when you cast the data to two dimensions, a decision
needs to made to know how to reduce the dimensionality. This is done
with a “group by” function. by default, dcast will do a group-by as
count. This is both dangerous and convenient because then you can do
other group by functions like sum or mean. You can however also cast
data into two dimensions but it will repeat the columns for each EAR
(note that “EAR” is now in the right hand side of the formula)

    dat= EA.query.f(years=2015:2020, variables=c("T150","ph_bot.fall","ice.max","O2.Late_summer.sat.mean50_100"), EARs=1:100)
    dcast(dat, year~ variable+EAR)

    ##    year T150_1 T150_2 T150_3 T150_4 ice.max_1 ice.max_10 ice.max_2 ice.max_3
    ## 1: 2015   4.19   3.69   4.01   0.33      9.12       1.85     15.42     12.98
    ## 2: 2016   4.26   3.60   4.03  -0.21      3.06       0.74      2.22      1.21
    ## 3: 2017   3.81   2.16   3.35  -0.92      3.81       0.94      5.98      1.41
    ## 4: 2018   3.26   2.32   2.69  -0.19      6.08       1.25      4.62      5.67
    ## 5: 2019     NA     NA     NA     NA      4.76       1.15     18.94     13.83
    ##    ice.max_4 ice.max_5 ice.max_50 ice.max_6 ice.max_7
    ## 1:      7.39     29.53       1.32      4.76     11.41
    ## 2:      1.90      8.27       0.54      1.26      0.03
    ## 3:     12.17      9.28       0.79      2.73      0.99
    ## 4:      5.04     16.18       1.07      2.76      1.29
    ## 5:      4.93     27.17       1.14      3.63      4.14
    ##    O2.Late_summer.sat.mean50_100_1 O2.Late_summer.sat.mean50_100_10
    ## 1:                        77.00939                         78.11792
    ## 2:                        73.53504                         70.87260
    ## 3:                        76.16029                         77.69411
    ## 4:                        82.21718                         83.13097
    ## 5:                              NA                               NA
    ##    O2.Late_summer.sat.mean50_100_2 O2.Late_summer.sat.mean50_100_3
    ## 1:                        88.50907                        85.78378
    ## 2:                        89.20817                        86.30571
    ## 3:                        88.95445                        86.48652
    ## 4:                        91.13842                        88.21394
    ## 5:                              NA                              NA
    ##    O2.Late_summer.sat.mean50_100_4 ph_bot.fall_1 ph_bot.fall_10 ph_bot.fall_2
    ## 1:                        90.53384      7.666830       7.584211      7.816374
    ## 2:                        91.21765      7.633863       7.572334      7.761814
    ## 3:                        90.02184      7.612828       7.561805      7.733547
    ## 4:                        93.54802      7.640820       7.592093      7.734545
    ## 5:                              NA            NA             NA            NA
    ##    ph_bot.fall_3 ph_bot.fall_5
    ## 1:      7.763617      7.744043
    ## 2:      7.744903      7.797067
    ## 3:      7.753033      7.788932
    ## 4:      7.766139      7.845360
    ## 5:            NA            NA

This wide data now has as many rows as years and as many columns as
variable x EAR. The columns are named with the variable followed by
"\_EAR".

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
to process the raw data in windows without days of clicking around and I
would make lots of errors. You may be able to do this in windows10
powershell but I have never tried it so I cannot say it will work. I do
note that powershell does not have “sed” installed by default and you
cannot run R from powershell so I am not sure you could send R
systemcalls to the powershell and if you could the script will will fail
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

Project participants
====================

Hugues Benoît, Marjolaine Blais, Daniel Duplisea, Peter Galbraith, David
Merette, Stéphane Plourde, Marie-Julie Roux, Bernard Sainte-Marie

If you have issues
==================

For comments, questions, bugs etc, you can send this to the package
maintainer, Daniel Duplisea, by email
(<a href="mailto:daniel.duplisea@gmail.com" class="email">daniel.duplisea@gmail.com</a>)
or file a bug report or issue on github.

Citation
========

Duplisea, DE. 2020. gslea: Gulf of St Lawrence ecosystem approach. R
package version 1.0
<a href="https://github.com/duplisea/gslea" class="uri">https://github.com/duplisea/gslea</a>
