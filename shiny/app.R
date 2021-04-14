# Load libraries, assuming these have been installed
# First, gslea

# library(gslea) # all functions have been imported here, so for now just use local copies to avoid global variable mismatching after fetching new data
library(data.table)
library(shiny)
library(shinybusy)

# Pasted from previous tabbed setup
# Important features of 

ui <- fluidPage(
#  tags$div(class = "h2",
#           tags$strong("GSLEA - Gulf of St. Lawrence Ecosystem Approach")
#  ),
  tabsetPanel(
      id="tabs",
      tabPanel(title = "Variable selection & download",
      sidebarPanel(
          # Allow to scroll independently of the mainPanel()
          style = "position:fixed;width:30%;", 
          helpText("GSLEA data are automatically updated from GitHub. These represent the most up-to-date version of the data in the duplisea/gslea GitHub repository"),
          hr(),
          # uiOutput to contain names:
          h4("Filter data before analysis/download"),
          uiOutput("input.vartypes"), #,
          # actionButton("lookup""Lookup variable descriptions for this type"),
          #!# Action: if including shinyjs, hide these if insufficient input
          actionLink("input.maplink", "View a map of ecosystem approach regions (EARs) here"),
          br(),
          uiOutput("input.EAR"), 
          uiOutput("input.year"),
          hr(),
          uiOutput("input.selected"),
          # DOWNLOAD
          downloadButton("downloadFilteredData", label = "Download selected data", style = "width:100%;")
      ),
      mainPanel(
          h3("Filter GSLEA variables and download datasets"),
          helpText("After submitting variable type, you can read descriptions of variables of that type before choosing them for download."),
          textOutput("selected.vars"),
          tableOutput("var.descriptions")
      )
  ),
  tabPanel(title = "Time-series of variables", 
      sidebarPanel(
          h3("Variables selected in previous panel"),
          #!# Action: if including shinyjs, hide these if there is insufficient input
          uiOutput("plot.vars"), # choose up to 5 variables from the previous
          actionLink("plot.maplink", "View a map of ecosystem approach regions (EARs) here"),
          br(),
          uiOutput("plot.EAR"), # select up to 5 EARs
          hr(),
          # helpText("Filter to selected years:"), # Smoothing options
          uiOutput("plot.years"), # which years to plot
          # For now, ignore graphical parameters and only include smoothing
          hr(),
          checkboxInput("plot.smoothing", label="Plot with smoothing", value=F),
          actionButton("plot.plot", label="Create plot", width="100%")
      ),
      mainPanel(
        h3("Visualize how your variables of interest vary over select years"),
        helpText("Note: only variables selcted in `Variable selection & download` are available here."),
        plotOutput("multivar.comp.plot", height="750px")
      )
    ), 
    tabPanel(title = "Cross-correlation", 
      sidebarPanel(
          # h3("Variables selected in previous panel"),
          #!# Action: if including shinyjs, hide these if there is insufficient input
          h4("Select & filter independent variable data"),
          uiOutput("corr.varx"), # choose the ind/x variable for cross-correlation
          uiOutput("corr.EARx"), # select x EAR
          hr(),
          h4("Select & filter dependent variable data"),
          uiOutput("corr.vary"), # choose the ind/y variable for cross-correlation
          actionLink("corr.maplink", "View a map of ecosystem approach regions (EARs) here"),
          br(),
          uiOutput("corr.EARy"), # select y EAR
          hr(),
          h4("Select years for plotting"), 
          helpText("The largest continuous block of time in these years will be chosen. If you select years where data are not available, they are pairwise deleted before correlation is run. Only contiguous points (in time) are used because of the assumptions of lagged correlation analysis."),
          uiOutput("corr.years"), # which years to consider
          # For now, ignore graphical parameters and only include smoothing
          helpText("You can optionally difference the variables to make them stationary, and therefore correlate how the values of each of the variables change from year to year as opposed to their absolute values."),
          checkboxInput("corr.diff", label="Difference variables?", value=F)
      ),
      mainPanel(
          h3("Calculate cross-correlation between selected variables (with lags)"),
          helpText("Note: only variables selcted in `Variable selection & download` are available here."),
          plotOutput("cross.corr.plot")
      )
    ),
    tabPanel(title = "Map of GSLEA Areas", 
      # sidebarPanel(),
      mainPanel(
      imageOutput("gslea_ears", inline=T),
      # img(src="gslea_ears.jpg", width=600), style="display: block; margin-left: auto; margin-right: auto;"),
      h4("Figure 1. Map of EARs."),
      h5("Data are available for download under the 'Variable selection & download' tab spatially divided according to the Gulf of St. Lawrence ecosystem approach regions (EAR) determined in Quebec Region in Spring 2019 (see above map). Some data are larger than these regions - more expansive datasets (e.g. the North Atlantic Oscillation) are indicated with EAR -1. EAR 0 has been reserved for GSL-scale indices.")
    ))
  ) 
)

server <- function(input, output, session){
  # To ensure that the gslea functions use the new global variables, paste the functions here:

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

  EA.query.f= function(variables, years, EARs, crosstab=F){
   out= EA.data[variable %in% variables & year %in% years & EAR %in% EARs]
   if(crosstab) out= dcast(out, year~ variable+EAR)
   out
  }

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

  sources.f= function(variable.name=NULL){
    if (is.null(variable.name)){
      v= variable.description[,.(variable, source, reference)]
    }
    if (!is.null(variable.name)){
      v= variable.description[variable %in% variable.name, .(variable, source, reference)]
    }
    v
  }
  ### 
  # Now shiny-exclusive code
  ### 
  # Download new data while showing a busy indicator
  EA.data.file <- "https://github.com/duplisea/gslea/raw/master/data/EA.data.rda"
  ecoregions.polyset.file <- "https://github.com/duplisea/gslea/raw/master/data/ecoregions.polyset.rda"
  field.description.file <- "https://github.com/duplisea/gslea/raw/master/data/field.description.rda"
  variable.description.file <- "https://github.com/duplisea/gslea/raw/master/data/variable.description.rda"
  # n for new, have to use here to create a non-global parameter
  shinybusy::show_modal_spinner(text="Please wait, fetching new GSLEA data")
  load(url(EA.data.file))
  load(url(ecoregions.polyset.file))
  load(url(field.description.file))
  load(url(variable.description.file))
  shinybusy::remove_modal_spinner()

  # Reactive inputs:
  observeEvent(input$input.maplink, {
    updateTabsetPanel(session, "tabs", "Map of GSLEA Areas")
  })
  observeEvent(input$plot.maplink, {
    updateTabsetPanel(session, "tabs", "Map of GSLEA Areas")
  })
  observeEvent(input$corr.maplink, {
    updateTabsetPanel(session, "tabs", "Map of GSLEA Areas")
  })
  
  datasetInput <- reactive({
      vars.f(variable.type=input$vartype.checkbox)
  })
  # Render map of GSLEA EARs
  output$gslea_ears <- renderImage({
    filename <- normalizePath(file.path('./images/gslea_ears.png'))
    list(src = filename, alt = "EARs of the GSLEA")
  }, deleteFile = F)

    # uniqueTypes <<- unique(gslea::variable.description$type)
    uniqueTypes <<- unique(as.character(vars.f(variable.type="all")$type))
    uniqueVars <<- unique(variable.description$label)
    uniqueYears <<- unique(EA.data$year)
    uniqueEARs <<- unique(EA.data$EAR)

    #!# Tab 1 input: Variable selection
    output$input.vartypes <- renderUI({
        selectInput(inputId = "vartype.checkbox", selectize = T, label = "Variable type(s) to include:", choices = c("all", uniqueTypes), selected = NULL)
    })
    output$input.maplink <- renderUI({
      
    })
    output$input.EAR <- renderUI({
        selectInput(inputId = "EAR.select", label = "Filter to these EAR(s):", choices = uniqueEARs, multiple = T, selected = '-1')
    })
    output$input.year <- renderUI({
        # selectInput(inputId = "year.select", label = "Filter to these year(s):", choices = uniqueYears, multiple = T, selected = NULL)
          sliderInput(inputId = "year.select",
                  label = "Time span to include:",
                  min = min(uniqueYears),
                  max = max(uniqueYears),
                  value = c(min(uniqueYears), max(uniqueYears)),
                  step = 1,
                  sep = "",
                  round = 0)
    })
    output$input.selected <- renderUI({
        selectInput(inputId = "var.select", 
                    label = "Which variables of the selected type would you like to download? (see descriptions to the right for more information)", 
                    choices = unique(datasetInput()$variable), 
                    multiple = T, 
                    selected = NULL)
    })
    #!# Tab 1 output: Variable descriptions
    output$var.descriptions <- renderTable(datasetInput())
    #!# Tab 1 actions: 
    # Change outputDF depending on which variables are selected
    observeEvent(input$var.select, {
      if(!is.null(input$var.select)){
          outputDF <<- reactive({
              EA.query.f(variables = input$var.select, years = seq(input$year.select[1], input$year.select[2]), EARs = as.numeric(input$EAR.select))
          })
      } else {
          outputDF <<- reactive({NULL})
      }
    })
    # Download selected data    
    output$downloadFilteredData <- downloadHandler(
    filename = function() {
      paste("gslea_data_", input$vartype.checkbox, "_", gsub("-", "_", gsub(" ", "_", Sys.time())), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(outputDF(), file, row.names = FALSE)
    }
  )
  #!# Tab 2: Plotting inputs
  # Select vars for plotting
  output$plot.vars <- renderUI({
      selectInput(inputId = "plot.vars.sel", 
                  label = "Select up to 5 variables to visualize (each variable = one row in the plot). Only the first 5 will be plotted.",
                  choices = unique(input$var.select),
                  multiple = T) 
  })
  # Updater to ensure that only five vars are selected
###  observeEvent(input$plot.vars.sel, {
###      if(length(input$plot.vars.sel) > 5){
###          # Select most recent 5
###          updateSelectInput(session, inputId = input$plot.vars.sel, selected = c(input$plot.vars.sel[c((length(input$plot.vars.sel)-5):length(input$plot.vars.sel))]))
###      }
###  })

  # Select EARs and years
  output$plot.EAR <- renderUI({
      selectInput(inputId = "plot.EAR.sel", 
                  label = "Select up to 5 EARs to visualize (each EAR = one column in the plot). Only the first 5 will be plotted.",
                  choices = uniqueEARs,
                  multiple = T)
  })
###  # Updater to ensure that only five EARs are selected
###  observeEvent(input$plot.EAR.sel, {
###      if(length(input$plot.EAR.sel) > 5){
###          # Select most recent 5
###          updateSelectInput(session, inputId = input$plot.EAR.sel, selected = c(input$plot.EAR.sel[c((length(input$plot.EAR.sel)-5):length(input$plot.EAR.sel))]))
###      }
###  })
  # Select years (unlimited)
  output$plot.years <- renderUI({
      sliderInput(inputId = "plot.years.sel",
                  label = "Which years should be included in the time-series?",
                  min = min(uniqueYears),
                  max = max(uniqueYears),
                  value = c(min(uniqueYears), max(uniqueYears)),
                  step = 1,
                  sep = "",
                  round = 0)
  })

  #!# Tab 2: Plotting outputs
  ### Only show up if there is something to plot here
  observeEvent(input$plot.plot, {
    output$multivar.comp.plot <- renderPlot({
      EA.plot.f(variables = input$plot.vars.sel, 
        years = seq(input$plot.years.sel[1], input$plot.years.sel[2]), 
        EARs = as.numeric(input$plot.EAR.sel),
        smoothing = input$plot.smoothing
      )
    })
  })

  #!# Tab 3: X-corr inputs
  # Select x variable
  output$corr.varx <- renderUI({
      selectInput(inputId = "corr.x", 
                  label = "Select the independent variable to plot on the x-axis (from those selected in the 'Variable selection & download' tab).",
                  choices = unique(input$var.select),
                  multiple = F) 
  })
  # Select y variable
  output$corr.vary <- renderUI({
      selectInput(inputId = "corr.y", 
                  label = "Select the dependent variable to plot on the y-axis (from those selected in the 'Variable selection & download' tab).",
                  choices = unique(input$var.select),
                  multiple = F) 
  })

  # Select x EAR
  output$corr.EARx <- renderUI({
      selectInput(inputId = "corr.EAR.x", 
                  label = "Filter the independent data to a specific EAR (choose '10' to select all EARs).",
                  choices = uniqueEARs,
                  multiple = F)
  })
  # Select y EAR
  output$corr.EARy <- renderUI({
      selectInput(inputId = "corr.EAR.y", 
                  label = "Filter the dependent data to a specific EAR (choose '10' to select all EARs).",
                  choices = uniqueEARs,
                  multiple = F)
  })

  # Select years (unlimited)
  output$corr.years <- renderUI({
      sliderInput(inputId = "corr.years.sel",
                  label = "Which years?",
                  min = min(uniqueYears),
                  max = max(uniqueYears),
                  value = c(min(uniqueYears), max(uniqueYears)),
                  step = 1,
                  sep = "",
                  round = 0)
  })

  #!# Tab 3: X-corr outputs
  output$cross.corr.plot <- renderPlot({
    EA.cor.f(x = input$corr.x, 
                    y = input$corr.y,
                    x.EAR = input$corr.EAR.x,
                    y.EAR = input$corr.EAR.y,
                    years = seq(input$corr.years.sel[1], input$corr.years.sel[2]),
                    diff = input$corr.diff
    )
  })
}

shiny::shinyApp(ui = ui, server = server)