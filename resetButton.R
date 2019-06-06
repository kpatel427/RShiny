# working example for resetting selected rows in DT Shiny
library(shiny)
library(shinyWidgets)
data("iris")

ui <- basicPage(
       h2("Select Rows"),
       DT::dataTableOutput('mytable'),
       actionButton("clear1", label = "Reset"))

    
    
server <- function(input, output,session) {
      
      mydata <- reactive({ iris })
      
      
      output$mytable = DT::renderDataTable(datatable(mydata(),
                                                     rownames = FALSE, escape = FALSE,
                                                     selection = list(mode = 'multiple',target = 'row'),
                                                     filter = 'top',
                                                     extensions = c('Buttons'),
                                                     options = list(
                                                       dom = 'Bfrtip',
                                                       autoWidth = TRUE,
                                                       buttons = list('pageLength'),
                                                       searchHighlight = TRUE,
                                                       initComplete = JS("function(settings, json) {",
                                                                         "$(this.api().table().header()).css({'background-color': '#4C4C4C', 'color': '#fff'});",
                                                                         "}"),
                                                       scrollX = TRUE,
                                                       scrollY = TRUE,
                                                       escape = FALSE
                                                     ),
                                                     class = 'nowrap display')) 
      
      
      # for resetting selection
      proxy = dataTableProxy('mytable')
      observeEvent(input$selectButton, {
        proxy %>% selectRows(as.numeric(selectedRow()))
      })
      
      observeEvent(input$clear1, {
        proxy %>% selectRows(NULL)
      })
    
      
}

runApp(list(ui = ui, server = server))
