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
#' @description  Does a fuzzy search for the word in the variable description and returns the full variable names.
#' @author Daniel Duplisea
#' @export
#' @examples find.vars.f("temp")
#'        find.vars.f("satu")
find.vars.f= function(search.term){
  vars1= variable.description[grep(search.term, variable.description$description, ignore.case=T),]$variable
  vars2= variable.description[grep(search.term, variable.description$variable, ignore.case=T),]$variable
  vars3= variable.description[grep(search.term, variable.description$source, ignore.case=T),]$variable
  vars4= variable.description[grep(search.term, variable.description$reference, ignore.case=T),]$variable
  vars5= variable.description[grep(search.term, variable.description$type, ignore.case=T),]$variable
  vars= unique(c(vars1,vars2,vars3,vars4,vars5))
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
#'               is plotted.
#' @author Daniel Duplisea
#' @export
#' @examples
#' EA.plot.f(variables=c("T150", "ph_bot.fall", "T250"), years=1900:2030, EARs=1:4, type="b",pch=20)
EA.plot.f= function(variables, years, EARs, smoothing=T, ...){
  dat= EA.query.f(variables=variables, years=years, EARs=EARs)
  actual.EARs= sort(as.numeric(dat[,unique(EAR)]))
  no.plots= length(variables)*length(actual.EARs)
  if(no.plots>25) {par(mfcol=c(5, 5),mar=c(1.3,2,3.2,1),omi=c(.1,.1,.1,.1))}
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
  par(omi=c(0,0,0,0),mar= c(5.1, 4.1, 4.1, 2.1))
}

#' Compute and plot the cross correlation with lags between two E variables
#'
#' @param variables variable vector must be 2 or less variables
#' @param years year vector
#' @param EARs EAR vector
#' @param diff logical whether or not the variables should be differenced (removes non-stationarity)
#' @param ... other arguments to ccf function for plotting in base R (type ?ccf)
#' @description  Computes the cross correlation between two selected variables with different lags. Your
#'              variable X EAR combination must = 2. See examples for clarification. Not that the lagged
#'              variable is the one leading, i.e. the cause. So if the ccf plot title has reversed what you
#'              think is the wrong cause and effect variables then just look at the - lags. This function
#'              automatically differences the variables to make them stationary. The differencing leads to
#'              a slightly different question. For example with NAO causing SST:
#'              -without differencing your question is: does the state of the NAO affect SST at some later
#'              point in time?
#'              -with differencing your question is: does the magnitude of change in the NAO from one year
#'              to the next affect the magnitude of change in SST from one year to the next at a later time?
#' @author Daniel Duplisea
#' @export
#' @examples
#' EA.cor.f(c("SST","NAO.month7"),1900:2020,c(0,3)) #SST not in EAR 0, NAO not in EAR 3, i.e. two vars
#' EA.cor.f("SST",1900:2020,c(1,3)) # SST in EAR 1 vs EAR 3
EA.cor.f= function(variables, years, EARs, diff=F, ...){
  if (length(variables)>2) stop("you can only correlate two variables against each other at a time")
  E1= EA.query.f(variables=variables, years=years, EARs=EARs)
  uniq.vars= unique(paste(E1$EAR,E1$variable))
  if (length(uniq.vars)>2) stop("have more than two variables in your variable and EAR combination")
  E2= dcast(E1, year~ variable+EAR)
  E3= na.omit(E2)
  if(max(diff(E3$year))>1) stop("your two series are not contiguous in time")
  iv.name=names(E3[,2])
  dv.name=names(E3[,3])
  if (diff){
    ind.var= diff(as.data.frame(E3)[,2])
    dep.var= diff(as.data.frame(E3)[,3])
  }
  if (!diff){
    ind.var= as.data.frame(E3)[,2]
    dep.var= as.data.frame(E3)[,3]
  }
  # the first variable is lagged, e.g. if there is sig + correlation at lag +3 it means the x variable causes the y 3 years later
  ccf(x=ind.var, y=dep.var,main=paste0(iv.name," (lagged), " ,dv.name, " (dependent)"), ...)
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

