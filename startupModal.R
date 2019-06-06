library(shiny)
library(shinyBS)

ui <- fluidPage(
  mainPanel(
    bsModal(id = 'startupModal', title = 'Statup', trigger = '',
            size = 'large', p("add your info here!"))
    )
)

server <- function(input, output, session) {
  toggleModal(session, "startupModal", toggle = "open")
}

shinyApp(ui = ui, server = server)
