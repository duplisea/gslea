#' Metadata with three levels of verbosity
#'
#' @param verbosity "low","med","high".
#' @description  Pulls out metadata from the various datasets to give an overview. "med" and "high" verbosity level data
#'               may need further display formatting to get a good overview. Try the library 'formattable' and run that
#'               function on the higher verbosity metadata to get a nicer looking table that you can make sense of.
#' @author Daniel Duplisea
#' @export
#' @examples
#' metadata.f("low")
#' data.desc= metadata.f("med"); library(formattable); formattable(data.desc$Descriptions, align="l")
#' metadata.f("vangogh")
metadata.f= function(verbosity="low"){
  if(verbosity=="low"){
    desc= list(
      Number.of.variables= EA.data[,uniqueN(variable)],
      Number.of.EARS= EA.data[,uniqueN(EAR)],
      Number.of.years= EA.data[,uniqueN(year)],
      First.and.last.year= range(EA.data$year),
      Number.of.observations= nrow(EA.data))
  }
  if(verbosity=="med"){
      Unique.variables= data.table(variable=EA.data[,unique(variable)],key="variable")
      Variables.with.descriptions= Unique.variables[variable.description[,.(variable, description, units)]]
#      formattable(Variables.with.descriptions,align="l")
      desc= list(Unique.Variables= Unique.variables,Descriptions=Variables.with.descriptions)
  }
  if(verbosity=="high"){
      Unique.variables= data.table(variable=EA.data[,unique(variable)],key="variable")
      Variables.with.descriptions= Unique.variables[variable.description[,.(variable, description, units)]]
#      formattable(Variables.with.descriptions,align="l")
      desc= list(Unique.Variables= Unique.variables,Descriptions=Variables.with.descriptions)
  }
  if(verbosity=="vangogh"){
    desc= list(Number.of.EARS= 1)
  }
  desc
}

#' Show  variables available in the data set
#' @param type The type of data you are interested in. Options: "all","physical","chemical","planktonic","phenological","fish"
#' @description  Lists all the variables in the database by data type
#' @author Daniel Duplisea
#' @export
#' @examples vars.f("phenological")
#' #consider using the library formattable to make a readable table that prints to the plot window
#' tmp= vars.f("all"); formattable(tmp)
vars.f= function(variable.type="all"){
  if (variable.type=="all"){
    vars= variable.description[,.(variable, type, description, units)]
  }
  if (variable.type!="all"){
    vars= variable.description[ type %in% variable.type, .(variable, type, description, units)]
  }
  vars= as.data.frame(as.matrix(vars,ncol=1))
  vars
}


#' Find variables with a keyword or phrase
#' @param search.term a term to search, e.g. "oxygen", "temperature", "temp", "saturat"
#' @param description if T then the description of the variable is also provided (this can be long). Default FALSE.
#' @param units if T then the units of measure of the variable is also provided. Default FALSE.
#' @description  Does a fuzzy search for the word in the variable description and returns the full variable names.
#' @author Daniel Duplisea
#' @export
#' @examples find.vars.f("temp", description=T)
#'        find.vars.f("satu")
find.vars.f= function(search.term, description=FALSE){
  vars1= variable.description[grep(search.term, variable.description$description, ignore.case=T),]$variable
  vars2= variable.description[grep(search.term, variable.description$variable, ignore.case=T),]$variable
  vars3= variable.description[grep(search.term, variable.description$source, ignore.case=T),]$variable
  vars4= variable.description[grep(search.term, variable.description$reference, ignore.case=T),]$variable
  vars5= variable.description[grep(search.term, variable.description$type, ignore.case=T),]$variable
  vars= unique(c(vars1,vars2,vars3,vars4,vars5))
  if (description) vars= as.data.frame(variable.description[match(vars, variable.description$variable),c(1:2,4)])
  vars
}

#' Query the data
#'
#' @param variables variable vector
#' @param years year vector
#' @param EARs EAR vector
#' @param crosstab logical. This will crosstabulate and show the NAs. For excel plotting you likely want it as cross tabulated
#'        data. Cross-tabulated data has somehow become known as "wide" data since data mining analytics has become such a huge
#'        field beginning in the first decade of the 2000s.
#' @description  creates a data.table based on the variables you selected. data.tables inherit data.frame. Cross-tabulated data
#'        will have the year as the first column and the variables in the columns thereafter. It will append _x to that variable
#'        to represent EAR x.
#' @author Daniel Duplisea
#' @export
#' @examples
#' EA.query.f(variables=c("T150", "ph_bot.fall", "T250"), years=1999:2012, EARs=1:2)
EA.query.f= function(variables, years, EARs, crosstab=F){
 out= EA.data[variable %in% variables & year %in% years & EAR %in% EARs]
 if(crosstab) out= dcast(out, year~ variable+EAR)
 out
}


#' Plot data time series
#'
#' @param variables variable vector
#' @param years year vector
#' @param EARs EAR vector
#' @param smoothing if TRUE and n>5, then a smooth.spline is drawn through the data with df=n/3
#' @param ... arguments to par for plotting
#' @description  Plots a matrix of variables with EAR as columns and variable as rows. If no data then a blank graph
#'               is plotted. If there are more than 25 individual plots (5x5) then it will ask for an enter from the
#'               keyboard before presenting a page of plots.
#' @author Daniel Duplisea
#' @export
#' @examples
#' EA.plot.f(variables=c("T150", "ph_bot.fall", "T250"), years=1900:2030, EARs=1:4, type="b",pch=20)
EA.plot.f= function(variables, years, EARs, smoothing=T, ...){
  dat= EA.query.f(variables=variables, years=years, EARs=EARs)
  actual.EARs= sort(as.numeric(dat[,unique(EAR)]))
  no.plots= length(variables)*length(actual.EARs)
  if(no.plots>25) {par(mfcol=c(5, 5),mar=c(1.3,2,3.2,1),omi=c(.1,.1,.1,.1), ask=T)}
  if(no.plots<=25){ par(mfcol=c(length(variables), length(actual.EARs)),mar=c(1.3,2,3.2,1),omi=c(.1,.1,.1,.1))}
  counter=1

  for(i in actual.EARs){
    ear.dat= dat[EAR==i]
    for(ii in 1:length(variables)){
      var.dat= ear.dat[variable==variables[ii]]
      if(nrow(var.dat)<1) plot(0, xlab="", ylab="", xaxt="n",yaxt="n",main=paste("EAR",i,variables[ii]), ...)
      if(nrow(var.dat)>0) plot(var.dat$year, var.dat$value, xlab="", ylab="", main=paste("EAR",i,variables[ii]), ...)
      if(nrow(var.dat)>5 && smoothing==T) lines(predict(smooth.spline(var.dat$year, var.dat$value,df=length(var.dat$value)/3)), ...)
      #if(nrow(var.dat)>5 && smoothing==T) lines(lowess(var.dat$year, var.dat$value))
    }
    counter= counter+1
  }
  par(mfcol=c(1,1),omi=c(0,0,0,0),mar= c(5.1, 4.1, 4.1, 2.1), ask=F)
}

#' Compute and plot the cross correlation with lags between two E variables
#'
#' @param x independent variable. E.g. "SST"
#' @param y dependent variable E.g. "T.deep"
#' @param years a vector of years you want to consider (the largest contiguous block in these years will be chosen)
#' @param x.EAR the ecosystem approach region for the independent variables
#' @param y.EAR the ecosystem approach region for the dependent variables
#' @param diff logical whether or not the variables should be differenced (removes non-stationarity)
#' @param ... other arguments to ccf function for plotting in base R (type ?ccf)
#' @description  Computes the cross correlation between two selected variables with different lags. Given that you specify
#'    the independent and dependent variables, you are interested in negative or zero lags as an test of your hypothesis.
#'    If you selected years where data are not available, they are pairwise deleted before correlation and because of the
#'    hypothesis involved in lagged correlation analysis, only contiguous points (in time) are used. The largest of these
#'    contiguous blocks is selected as the data input for the analysis.
#'@details The ccf/acf function works differently than cor in a loop because it normalises the series only once at the beginning
#'    while every call to "cor" will renormalise with the truncated (lagged series). They will be the same for lag=0 though. They
#'    can, however, differ considerably especially for series with outliers at the ends and which is perhaps what we most often
#'    see with environmental data series under climate change. Given the increased probability of having an outlier presently
#'    under rapid climate change, it also means that causality inferred from a correlation analysis, especially a lagged one, is
#'    more susceptible to being overturned with a data update.
#' @author Daniel Duplisea
#' @export
#' @examples
#'       EA.cor.f("J.GSNW.Q3","T.deep",1800:2019,x.EAR=-1,y.EAR=1)
EA.cor.f= function(x, y, years, x.EAR, y.EAR, diff=F, ...){
  E1= EA.query.f(variables=x, years=years, EARs=x.EAR)
  E2= EA.query.f(variables=y, years=years, EARs=y.EAR)
  E1= dcast(year~variable,data=E1)
  E2= dcast(year~variable,data=E2)
  E= E1[E2]

  # remove any year where NA and choose the longest contiguous block of years to perform ccf
    E= na.omit(E)
    E[, contiguous.years := paste0("x", cumsum(c(TRUE, diff(year) != 1)))]
    Emax= E[, .N, by=contiguous.years]
    longest.contiguous.group= Emax$contiguous.years[match(max(Emax$N),Emax$N)]
    E= E[contiguous.years==longest.contiguous.group]

  iv.name=names(E[,2])
  dv.name=names(E[,3])
  if (diff){
    ind.var= diff(as.data.frame(E)[,2])
    dep.var= diff(as.data.frame(E)[,3])
  }
  if (!diff){
    ind.var= as.data.frame(E)[,2]
    dep.var= as.data.frame(E)[,3]
  }
  # the first variable is lagged, e.g. if there is sig + correlation at lag +3 it means the x variable causes the y 3 years later
  tmp= ccf(x=ind.var, y=dep.var,main="", ...)
  best.pos= match(max(abs(tmp$acf)),abs(tmp$acf))
  points(tmp$lag[best.pos],tmp$acf[best.pos],pch=20,col="red")
  text(tmp$lag[best.pos],tmp$acf[best.pos],round(tmp$acf[best.pos],2),cex=0.7, pos=4)
  statement= paste0("The best explanation of ", y, " is the ", x, " value ", tmp$lag[best.pos], " years from ", y)
  title(main=statement,cex.main=0.9)
  legend("bottomright",legend=paste0("Year block used ", min(E$year),":",max(E$year)),bty="n",cex=0.7)
}



#EA.plot.f(years=1900:2030, variables=c("T150", "ph_bot.fall", "T250"), EARs=1:4, type="b",pch=20)

#EA.plot.f(years=1900:2030, variables=c("T150", "ph_bot.fall", "T250"), EARs=1:50, type="b",pch=20)

#EA.plot.f(years=1900:2030, variables=c("T150", "ph_bot.fall", "T250","ice.max","chl0_100.annual","chl0_100.early_summer"),EARs=1:50, type="b",pch=20,cex.main=.8)


# Join ecoregion descriptions and locations to EA.data
#' Plot data time series
#'
#' @description  Joins the English names of the ecoregions to the EA.data to aid graph descriptions. It also joins
#'               columns for  the longitude (- degrees from prime meridian) and latitude (+ degrees from equator)
#'               of the centre of each ecoregion polygon.
#' @author Daniel Duplisea
#' @export
#' @examples EA.data2= EAR.name.location.f()
EAR.name.location.f=function(){
  tmp= EA.data
  tmp[EAR==1, ":=" (EAR.name="Northwest", EAR.lon= -66.35653, EAR.lat= 49.48379)]
  tmp[EAR==2, ":=" (EAR.name = "Northeast", EAR.lon= -59.98879, EAR.lat= 49.79361)]
  tmp[EAR==3, ":=" (EAR.name = "Centre", EAR.lon= -60.81041, EAR.lat= 48.38774)]
  tmp[EAR==4, ":=" (EAR.name = "Mecatina", EAR.lon= -57.68665, EAR.lat= 51.23615)]
  tmp[EAR==5, ":=" (EAR.name = "Magdallen Shallows", EAR.lon= -63.54881, EAR.lat= 47.51097)]
  tmp[EAR==6, ":=" (EAR.name = "Northumberland Strait", EAR.lon= -63.60993, EAR.lat= 46.21545)]
  tmp[EAR==7, ":=" (EAR.name = "Laurentian-Heritage", EAR.lon= -58.41857, EAR.lat= 46.86941)]
  tmp[EAR==10, ":=" (EAR.name = "Estuary", EAR.lon= -68.52829, EAR.lat= 48.69118)]
  tmp[EAR==50, ":=" (EAR.name = "Baie-des-Chaleurs", EAR.lon= -65.78367, EAR.lat= 48.02761)]
  tmp
}

#' Sources and references for each variable
#' @description  creates a three column data.table with variable, source and reference columns. Please cite the authors if you use their data.
#' @author Daniel Duplisea
#' @export
#' @examples sources.f()
sources.f= function(variable.name=NULL){
  if (is.null(variable.name)){
    v= variable.description[,.(variable, source, reference)]
  }
  if (!is.null(variable.name)){
    v= variable.description[variable %in% variable.name, .(variable, source, reference)]
  }
  v
}

