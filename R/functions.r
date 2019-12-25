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
metadata.f= function(verbosity="low"){
  if(verbosity=="low"){
    desc= list(
      Number.of.variables= EA.data[,uniqueN(variable)],
      Number.of.EARS= EA.data[,uniqueN(EAR)],
      Number.of.years= EA.data[,uniqueN(year)],
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


#' Query the data
#'
#' @param variables variable vector
#' @param years year vector
#' @param EARs EAR vector
#' @tabular do you want the data output with few colums and repeated rows or a a more tabular format (often what you want for plotting in excel)
#' @description  creates a data.table based on the variables you selected. data.tables inherit data.frame
#' @author Daniel Duplisea
#' @export
#' @examples
#' EA.query.f(years=1999:2012, variables=c("T150", "ph_bot.fall", "T250"), EARs=1:2)
EA.query.f= function(variables, years, EARs){
 warning("GENERAL WARNING ABOUT FISH SURVEY DATA: there were fish survey vessel and gear changes in 1990 and 2004. New survey strata were added in 2007 and biodiversity protocols were changed in 2006. Careful with fish data intepretation spanning these years.", noBreaks.=T,immediate.=T)
 out= EA.data[variable %in% variables & year %in% years & EAR %in% EARs]
 out
}



#' Plot data time series
#'
#' @param variables variable vector
#' @param years year vector
#' @param EARs EAR vector
#' @param ... arguments to par for plotting
#' @description  Plots a matrix of variables with EAR as columns and variable as rows. If no data then a blank graph
#'               is plotted.
#' @author Daniel Duplisea
#' @export
#' @examples
#' EA.plot.f(years=1900:2030, variables=c("T150", "ph_bot.fall", "T250"), EARs=1:4, type="b",pch=20)
EA.plot.f= function(variables, years, EARs, ...){
  dat= EA.query.f(variables=variables, years=years, EARs=EARs)
  actual.EARs= sort(as.numeric(dat[,unique(EAR)]))
  no.plots= length(variables)*length(actual.EARs)
  if(no.plots>25) warning("this query generates more than 25 plots, consider fewer variables or EARs")
  par(mfcol=c(length(variables), length(actual.EARs)),mar=c(1.3,2,3.2,1),omi=c(.1,.1,.1,.1))
  counter=1
  for(i in actual.EARs){
    ear.dat= dat[EAR==i]
    for(ii in 1:length(variables)){
      var.dat= ear.dat[variable==variables[ii]]
      if(nrow(var.dat)<1) plot(0, xlab="", ylab="", xaxt="n",yaxt="n",main=paste("EAR",i,variables[ii]), ...)
      if(nrow(var.dat)>0) plot(var.dat$year, var.dat$value, xlab="", ylab="", main=paste("EAR",i,variables[ii]), ...)
    }
    counter= counter+1
  }
}

#EA.plot.f(years=1900:2030, variables=c("T150", "ph_bot.fall", "T250"), EARs=1:4, type="b",pch=20)

#EA.plot.f(years=1900:2030, variables=c("T150", "ph_bot.fall", "T250"), EARs=1:50, type="b",pch=20)

#EA.plot.f(years=1900:2030, variables=c("T150", "ph_bot.fall", "T250","ice.max","chl0_100.annual","chl0_100.early_summer"),EARs=1:50, type="b",pch=20,cex.main=.8)



#one will want to query by data type
# create a multipage plot option
