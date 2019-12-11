


#' a map of the Gulf of St. Lawrence with ecoregions and options to include survey points and bathymetry
#'
#' @param survey.points logical. Plot the fish survey points from all years from the set file
#' @param pch the point type for depicting fish survey points
#' @param bathymetry show bathymetry lines
#' @param isobath bamthymetric depths to show
#' @param bathycols a vector of bathymetric colour, recycled
#' @description A map of the Gulf of St Lawrence showing the ecoregions and with options to plot different
#'        bathymetric contours and fish survey points
#' @export
gslea.map.f= function(xlim=c(-70,-55), ylim=c(42,53),
  bathymetry=F, isobath=c(150,300), bathycols= c("yellow","blue")){
  #data prep
  data("worldLLhigh")
  gsl= clipPolys(worldLLhigh, xlim = c(286, 310), ylim = c(43, 53)) #clip the world to gsl polyset
  gsl$X= gsl$X-360
  pdata = calcCentroid(EcoRegions)
  pdata$col = grey.colors(9)#1:9#paste0("grey",11:19)
  pdata$label = c("1-NW","2-NE","3-Centre","4-Mecatina","5-MS","6-NS","7-LH","10/1-Est","50-BdC")
  pdata = as.PolyData(pdata, projection = "LL")

  #plot the ecoregions then the land then the bathymetry
  plotMap(EcoRegions,col="lightblue",bg=rgb(224,253,254,maxColorValue=255),polyProps = pdata,
    xlim=xlim,ylim=ylim,las=1,xaxt="n", yaxt="n",xlab="",ylab="")
  xint= seq(xlim[1],xlim[2],length=5)
  yint= seq(ylim[1],ylim[2],length=6)
  mtext("Longitude west",side=1,line=3)
  mtext("Latitude north",side=2,line=3)
  axis(1, at=xint, labels=xint*-1, lty=1,lwd=1,lwd.ticks= 1, cex.axis=.7)
  axis(2, at=yint, labels=yint*1, lty=1,lwd=1,lwd.ticks=1,las=1, cex.axis=.7)
  addPolys(EcoRegions, polyProps = pdata)
  addPolys(gsl,col="tan")

  #add depth contours
  if(bathymetry){
    ocCL = contourLines(ocBathy, levels=isobath)
    ocCP = convCP(ocCL, projection = "LL")
    ocPoly = ocCP$PolySet
    addLines(thinPolys(ocPoly, tol=1,filter = 5), col =bathycols)
    legend("bottomright", bty = "n", col = bathycols, lwd = 1, legend = as.character(isobath), inset = 0.05,
    title = "Isobaths (m)",cex=0.7)
  }
  boxtext(pdata$X, pdata$Y, labels = pdata$label,cex=0.7,col.bg="beige")
}



#years=2003:2005; variables=c("T150", "ph_bot.fall")

#extract.f= function(years, EARs, variables, verbosity=1){
 # EA.data[.(year %in% years),variable %in% variables,c(year,EAR)]
