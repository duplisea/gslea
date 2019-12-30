Gulf of St. Lawrence Ecosystem Approach package
===============================================

Quick start
-----------

Open R and install the gslea package and try some commands outlined in
?gslea:

    devtools::install_github(https://github.com/duplisea/gslea)
    library(gslea)
    ?gslea

Purpose
-------

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
-------------

Presently, this package consists of data for the Gulf of St Lawrence
where collection and management of the data is done out of the Quebec
Region. This means that physical, chemical and phenological data
generally cover the entire Gulf of St Lawrence but fish survey data
cover only the northern portion as the southern portion of the Gulf is
surveyed by the Gulf Region in Moncton and with a different survey gear.

<img src="README_files/figure-markdown_strict/gslmap.plain-1.png" style="width:100.0%" />

Design
------

The package is GPL-3 licenced and thus is available globally without
warranty. The package is designed to have as few data containers as
possible and in a common and consistent format to allow generic
extraction. The package has only one dependence which is the library
data.table and data.table itself has no dependencies. The data.table
library is used because of its very efficient use of computing resources
making it very fast for processing data which would be important if in
someone’s analysis they make queries to the data in loops or tried
bootstrapping directly from the full database
(<a href="https://h2oai.github.io/db-benchmark/" class="uri">https://h2oai.github.io/db-benchmark/</a>).
The data are structured in what has become termed “tidy data” for people
in the tidyverse as opposed to dirty data I suppose. You can use your
own tidyverse code with it if you like though but it will be slower. The
data class data.table is what tidyverse people will call “tibbles” and
they inherit a secondary class of data.frame, therefore they are
compatible with base R. The R package should be consistent and should
not break existing analyses when updated.

Components
----------

The package consists of three tables presently:

<u>EA.data</u>: This is where all the measurements reside. The
data.table (inherits data.frame as second choice) has four columns:
<b>year</b>, <b>EAR</b>, <b>variable</b>, <b>value</b>. Where year is
the year (integer) of data collection, <b>EAR</b> is the ecosystem
approach region (see fig 1) (character), <b>variable</b> is the name of
the variable (character), <b>value</b> is the measured values (numeric).
<b>variable</b> is set as the key variable

<u>variable.descriptions</u>: this provides a description of the
variable in EA.data. This table contains five columns: <b>variable</b>
is the name of the variable (character), <b>description</b> is a
description of the variable and what is represents, <b>units</b> are the
units of measure of the variable, <b>contact</b> is the name of the
contact person who provided the data, <b>type</b> is the type of data
(“physical”, “chemical”, “planktonic”, “phenological”, “fish”),
<b>extraction.date</b> is the date which the contact person extracted
the data from their database. <b>variable</b> is the key variable. Some
of the variables are not just single measures per year but monthly
measures. It was a conscious decision not to make a sub-year time column
in these cases which makes the extraction result more difficult since
often people want data in two-dimensional tabular format. So for example
some of the plankton data are available by month. In these cases, there
is a separate variable for each month and if it were for September it
would end in …month9.

<u>field.descriptions</u>: this gives a description of the field names
in the EA.data especially as these might need elaboration in some cases.
The table contains three columns: <b>field</b> which is the field name
in the EA.data table, <b>description</b> which describes what is
represented by that column, <b>elaboration</b> which provides more
details on the column when needed. So the elaboration column for
<b>EAR</b> describes the areas represented by each ecoregion code.
elaboration for variable describes specifically what is meant by a
variable containing a name that may include “early summer”. <b>field</b>
is the key variable.

Installation
------------

    devtools::install_github(https://github.com/duplisea/gslea)
    library(gslea)

Accessing the data
------------------

### Data content overviews

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
of the data types with the default being “all”. It will give you the
extact name of the variable, its description and units. The output can
be long and the descriptions are sometimes quite wordy so it is
difficult to read. I suggest you save the result of a large query to
var.f as an object and then use the library formattable to make it into
a more readable table. So for example formattable, e.g.:

    vars.f(variable.type="physical")

    ##        variable     type                               description
    ## 1           SST physical            sea surface temperature annual
    ## 2   SST.anomaly physical anomaly in sea surface temperature annual
    ## 3   SST.month10 physical        sea surface temperature in October
    ## 4   SST.month11 physical       sea surface temperature in November
    ## 5    SST.month5 physical            sea surface temperature in May
    ## 6    SST.month6 physical           sea surface temperature in June
    ## 7    SST.month7 physical           sea surface temperature in July
    ## 8    SST.month8 physical         sea surface temperature in August
    ## 9    SST.month9 physical      sea surface temperature in September
    ## 10       T.deep physical  Bottom temperature in waters > 200m deep
    ## 11    T.shallow physical  Bottom temperature in waters < 200m deep
    ## 12         T150 physical                      Temperature at 150 m
    ## 13         T200 physical                      Temperature at 200 m
    ## 14         T250 physical                      Temperature at 250 m
    ## 15         T300 physical                      Temperature at 300 m
    ## 16  Tmax200.400 physical Maximum temperature between 200 and 400 m
    ## 17  decrease.10 physical  Timing of when water first cools to 10 C
    ## 18  decrease.12 physical  Timing of when water first cools to 12 C
    ## 19    first.ice physical     Timing of the first appearance of ice
    ## 20 ice.duration physical                Duration of the ice season
    ## 21      ice.max physical               Day of maximum ice coverage
    ## 22     last.ice physical      Timing of the last appearance of ice
    ## 23     start.10 physical  Timing of when water first warms to 10 C
    ## 24     start.12 physical  Timing of when water first warms to 12 C
    ##              units
    ## 1  degrees celsius
    ## 2  degrees celsius
    ## 3  degrees celsius
    ## 4  degrees celsius
    ## 5  degrees celsius
    ## 6  degrees celsius
    ## 7  degrees celsius
    ## 8  degrees celsius
    ## 9  degrees celsius
    ## 10 degrees celsius
    ## 11 degrees celsius
    ## 12 degrees celsius
    ## 13 degrees celsius
    ## 14 degrees celsius
    ## 15 degrees celsius
    ## 16 degrees celsius
    ## 17 day of the year
    ## 18 day of the year
    ## 19 day of the year
    ## 20            days
    ## 21 day of the year
    ## 22 day of the year
    ## 23 day of the year
    ## 24 day of the year

### Data extraction

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

### Data plotting

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

Updating the package
--------------------

Unless you need to update this database, you do not need to read this.

It is important that the database can be updated consistently and
quickly. This is done through a series of system calls to bash while
running R in linux using text processing programs like awk and sed and
then manipulation in R.

To update the package you will need the standard packages for doing it
like roxygen and devtools. Computing requirements for updating

This package requires linux to update. The reason linux is needed is
because it uses BASH system calls and programs like awk and sed to
pre-process data to make names consisitent, e.g. “Year” to “year” or
other inconsistencies between how raw data is provided by different
people. If data gets provided by people differently between updates then
this will require updating of these scripts.

Once the data are processed and brought into the R package, then it
should be useable by any platform that runs R but I would not know how
to process the raw data in windows without days of clicking around and I
would make lots of errors.

### Raw data

Raw data has been provided in various forms by individual data
providers. Sometimes it is in tabular format while other times it is in
a long format. We need to turn it all into long format and this also
involves standardising variable names.

### Running the update script

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

### Updating the R package

#### Compiling documentation

If you changed the documentation for the datasets or functions, you need
to recompile the documentation using roxygen2.

#### Making the R package

Clean and rebuild

Project particpants
-------------------

Hugues Benoît, Daniel Duplisea, Peter Galbraith, David Merette, Stéphane
Plourde, Marie-Julie Roux, Bernard Sainte-Marie

Citation
--------

Duplisea, DE. 2020. gslea: Gulf of St Lawrence ecosystem approach. R
package version 1.0
<a href="https://github.com/duplisea/gslea" class="uri">https://github.com/duplisea/gslea</a>
