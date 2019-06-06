library(shiny)


logo <-  tags$a(href = "https://www.google.com", target = "_blank",
                tags$img(src = "logohere.png", height = '50', width = '50'),
                span('example', style = "color:white"))


ui <- dashboardPage(
  dashboardHeader(title = logo), 
  dashboardSidebar(), 
  dashboardBody()
  )


shinyApp(ui, server = function(input, output, session) {
})