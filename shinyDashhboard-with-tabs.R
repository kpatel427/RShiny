library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Your Title",
                  tags$li(a(onclick = "openTab('home')",
                            href = NULL,
                            icon("home"),
                            title = "Homepage",
                            style = "cursor: pointer;"),
                          class = "dropdown",
                          tags$script(HTML("
                                           var openTab = function(tabName){
                                           $('a', $('.sidebar')).each(function() {
                                           if(this.getAttribute('data-value') == tabName) {
                                           this.click()
                                           };
                                           });
                                           }"))),
                  tags$li(a(onclick = "openTab('tab1')",
                            href = NULL,
                            icon("chart"),'Tab1',
                            title = "Homepage",
                            style = "cursor: pointer;"),
                          class = "dropdown",
                          tags$script(HTML("
                                           var openTab = function(tabName){
                                           $('a', $('.sidebar')).each(function() {
                                           if(this.getAttribute('data-value') == tabName) {
                                           this.click()
                                           };
                                           });
                                           }"))),
                  tags$li(a(onclick = "openTab('tab2')",
                            href = NULL,
                            icon("line-chart"),'Tab2',
                            title = "Homepage",
                            style = "cursor: pointer;"),
                          class = "dropdown",
                          tags$script(HTML("
                                           var openTab = function(tabName){
                                           $('a', $('.sidebar')).each(function() {
                                           if(this.getAttribute('data-value') == tabName) {
                                           this.click()
                                           };
                                           });
                                           }"))),
                  tags$li(a(onclick = "openTab('tab3')",
                            href = NULL,
                            icon("line-chart"),'Tab3',
                            title = "Homepage",
                            style = "cursor: pointer;"),
                          class = "dropdown",
                          tags$script(HTML("
                                           var openTab = function(tabName){
                                           $('a', $('.sidebar')).each(function() {
                                           if(this.getAttribute('data-value') == tabName) {
                                           this.click()
                                           };
                                           });
                                           }")))
                  
                          ),  dashboardSidebar(sidebarMenu(id = "sidebar", # id important for updateTabItems
                                                           menuItem("Home", tabName = "home", icon = icon("house")),
                                                           menuItem("Tab1", tabName = "tab1", icon = icon("table")),
                                                           menuItem("Tab2", tabName = "tab2", icon = icon("line-chart")),
                                                           menuItem("Tab3", tabName = "tab3", icon = icon("line-chart"))),collapsed = T
                          ),
  
  dashboardBody(
    tags$head(
      tags$style(
        HTML('.skin-blue .wrapper .main-header .navbar .navbar-custom-menu { float: left;}
             .skin-blue .main-header .navbar .sidebar-toggle {display: none;}
             .skin-blue .main-header .navbar{background-color: #005daa;}
             .skin-blue .main-header .logo {background-color: #005daa;}
             .skin-blue .main-header .logo:hover {background-color: #005daa;}'))),
    tabItems(
      tabItem("home", "This is the home tab"),
      tabItem("tab1", "This is Tab1"),
      tabItem("tab2", "This is Tab2"),
      tabItem("tab3", "This is Tab3")
    ))
      )
server = function(input, output, session){
  observeEvent(input$home, {
    updateTabItems(session, "sidebar", "home")
  })
  
  observeEvent(input$tab1, {
    updateTabItems(session, "sidebar", "tab1")
  })
  observeEvent(input$tab2, {
    updateTabItems(session, "sidebar", "tab2")
  })
  observeEvent(input$tab3, {
    updateTabItems(session, "sidebar", "tab3")
  })
}
shinyApp(ui, server)
