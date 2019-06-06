library(shiny)
library(shinyWidgets)


logo <-  tags$a(href = "https://www.google.com", target = "_blank",
                tags$img(src = "logohere.png", height = '50', width = '50'),
                span('example', style = "color:white"))


ui <- dashboardPage(
  dashboardHeader(title = logo), 
  dashboardSidebar(), 
  dashboardBody(
    # CSS
    tags$head(tags$style(HTML('
                              
                              /* value box customize */
                              .small-box.bg-yellow { background-color: #EC9787 !important; color: #000000 !important; height:300px}
                              .small-box.bg-olive { background-color: #B4B7BA !important; color: #000000 !important; height:300px}
                              .small-box.bg-orange { background-color: #3F69AA !important; color: #000000 !important; height:300px}
                              
                              
                              /* value box buttons customize */
                              #clvaluebox { float:right; width:35%;}
                              #pdvaluebox { float:right; width:35%;}
                              #atvaluebox { float:right; width:35%;}
                              '))),
    
    
    fluidRow(
      box(title = "Title 1", status = "primary", width = 12, solidHeader = TRUE, "You can enter your text here", br(), br(),
          actionButton(inputId='ab1', label="Learn More", icon = icon("th"), onclick ="window.open('http://www.chop.edu/doctors/maris-john-m#.V172uOYrLVo', '_blank')"))
    ),
    fluidRow(
      valueBox(h4(tags$b("Box 1"), actionBttn(inputId = "clvaluebox",
                                                   label = "How to use",
                                                   style = "unite", 
                                                   color = "warning",
                                                   icon = icon("question"),
                                                   size = "xs"), hr()),
               color = "yellow", p("This is box 1")       
      ),
      valueBox(h4(tags$b("Box 2"), actionBttn(inputId = "pdvaluebox",
                                                     label = "How to use",
                                                     style = "unite", 
                                                     color = "warning",
                                                     icon = icon("question"),
                                                     size = "xs"),hr()),
               color = "olive", p("This is box 2")
      ),
      valueBox(h4(tags$b("Box 3"), actionBttn(inputId = "atvaluebox",
                                                       label = "How to use",
                                                       style = "unite", 
                                                       color = "warning",
                                                       icon = icon("question"),
                                                       size = "xs"), hr()),
               color = "orange", p("This is box 3")
      ) # end of value box
    )
    )
    )


shinyApp(ui, server = function(input, output, session) {
})
