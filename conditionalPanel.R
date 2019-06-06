library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  header = dashboardHeader(title = 'Menu'),
  sidebar = dashboardSidebar(
    conditionalPanel(
      condition = "input.conditional_panel == 'Show_only_item1'",
      sidebarMenu(menuItem(
        'Item 1', tabName = 'item1',
        menuSubItem('Item A', tabName = 'item1A'),
        menuSubItem('Item B', tabName = 'item1B')
      ))
    ),
    conditionalPanel(
      condition = "input.conditional_panel == 'Show_item1_item2'",
      sidebarMenu(
        menuItem('Item 1', tabName = 'item1',
                 menuSubItem('Item A', tabName = 'item1A')
        ),
        menuItem('Item 2', tabName = 'item2',
                 menuSubItem('Item C', tabName = 'item2C'),
                 menuSubItem('Item D', tabName = 'item2D')
        )
      )
    )
  ),
  body = dashboardBody(
    selectInput(inputId = 'conditional_panel', label = 'Data type',
                choices = c('Show_only_item1', 'Show_item1_item2'))
  )
)

server <- function(...){}

shinyApp(ui = ui, server = server)
