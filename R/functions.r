


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



#' Add text with background box to a plot
#'
#' \code{boxtext} places a text given in the vector \code{labels}
#' onto a plot in the base graphics system and places a coloured box behind
#' it to make it stand out from the background.
#'
#' @param x numeric vector of x-coordinates where the text labels should be
#' written. If the length of \code{x} and \code{y} differs, the shorter one
#' is recycled.
#' @param y numeric vector of y-coordinates where the text labels should be
#' written.
#' @param labels a character vector specifying the text to be written.
#' @param col.text the colour of the text
#' @param col.bg color(s) to fill or shade the rectangle(s) with. The default
#' \code{NA} means do not fill, i.e., draw transparent rectangles.
#' @param border.bg color(s) for rectangle border(s). The default \code{NA}
#' omits borders.
#' @param adj one or two values in [0, 1] which specify the x (and optionally
#' y) adjustment of the labels.
#' @param pos a position specifier for the text. If specified this overrides
#' any adj value given. Values of 1, 2, 3 and 4, respectively indicate
#' positions below, to the left of, above and to the right of the specified
#' coordinates.
#' @param offset when \code{pos} is specified, this value gives the offset of
#' the label from the specified coordinate in fractions of a character width.
#' @param padding factor used for the padding of the box around
#' the text. Padding is specified in fractions of a character width. If a
#' vector of length two is specified then different factors are used for the
#' padding in x- and y-direction.
#' @param cex numeric character expansion factor; multiplied by
#' code{par("cex")} yields the final character size.
#' @param font the font to be used
#'
#' @return Returns the coordinates of the background rectangle(s). If
#' multiple labels are placed in a vactor then the coordinates are returned
#' as a matrix with columns corresponding to xleft, xright, ybottom, ytop.
#' If just one label is placed, the coordinates are returned as a vector.
#' @author Ian Kopacka
#' @examples
#' ## Create noisy background
#' plot(x = runif(1000), y = runif(1000), type = "p", pch = 16,
#' col = "#40404060")
#' boxtext(x = 0.5, y = 0.5, labels = "some Text", col.bg = "#b2f4f480",
#'     pos = 4, font = 2, cex = 1.3, padding = 1)
#' @export
boxtext <- function(x, y, labels = NA, col.text = NULL, col.bg = NA,
        border.bg = NA, adj = NULL, pos = NULL, offset = 0.5,
        padding = c(0.5, 0.5), cex = 1, font = graphics::par('font')){

    ## The Character expansion factro to be used:
    theCex <- graphics::par('cex')*cex

    ## Is y provided:
    if (missing(y)) y <- x

    ## Recycle coords if necessary:
    if (length(x) != length(y)){
        lx <- length(x)
        ly <- length(y)
        if (lx > ly){
            y <- rep(y, ceiling(lx/ly))[1:lx]
        } else {
            x <- rep(x, ceiling(ly/lx))[1:ly]
        }
    }

    ## Width and height of text
    textHeight <- graphics::strheight(labels, cex = theCex, font = font)
    textWidth <- graphics::strwidth(labels, cex = theCex, font = font)

    ## Width of one character:
    charWidth <- graphics::strwidth("e", cex = theCex, font = font)

    ## Is 'adj' of length 1 or 2?
    if (!is.null(adj)){
        if (length(adj == 1)){
            adj <- c(adj[1], 0.5)
        }
    } else {
        adj <- c(0.5, 0.5)
    }

    ## Is 'pos' specified?
    if (!is.null(pos)){
        if (pos == 1){
            adj <- c(0.5, 1)
            offsetVec <- c(0, -offset*charWidth)
        } else if (pos == 2){
            adj <- c(1, 0.5)
            offsetVec <- c(-offset*charWidth, 0)
        } else if (pos == 3){
            adj <- c(0.5, 0)
            offsetVec <- c(0, offset*charWidth)
        } else if (pos == 4){
            adj <- c(0, 0.5)
            offsetVec <- c(offset*charWidth, 0)
        } else {
            stop('Invalid argument pos')
        }
    } else {
      offsetVec <- c(0, 0)
    }

    ## Padding for boxes:
    if (length(padding) == 1){
        padding <- c(padding[1], padding[1])
    }

    ## Midpoints for text:
    xMid <- x + (-adj[1] + 1/2)*textWidth + offsetVec[1]
    yMid <- y + (-adj[2] + 1/2)*textHeight + offsetVec[2]

    ## Draw rectangles:
    rectWidth <- textWidth + 2*padding[1]*charWidth
    rectHeight <- textHeight + 2*padding[2]*charWidth
    graphics::rect(xleft = xMid - rectWidth/2,
            ybottom = yMid - rectHeight/2,
            xright = xMid + rectWidth/2,
            ytop = yMid + rectHeight/2,
            col = col.bg, border = border.bg)

    ## Place the text:
    graphics::text(xMid, yMid, labels, col = col.text, cex = theCex, font = font,
            adj = c(0.5, 0.5))

    ## Return value:
    if (length(xMid) == 1){
        invisible(c(xMid - rectWidth/2, xMid + rectWidth/2, yMid - rectHeight/2,
                        yMid + rectHeight/2))
    } else {
        invisible(cbind(xMid - rectWidth/2, xMid + rectWidth/2, yMid - rectHeight/2,
                        yMid + rectHeight/2))
    }
}




#years=2003:2005; variables=c("T150", "ph_bot.fall")

#extract.f= function(years, EARs, variables, verbosity=1){
 # EA.data[.(year %in% years),variable %in% variables,c(year,EAR)]
