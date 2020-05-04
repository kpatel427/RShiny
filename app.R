library(shiny)
library(shinydashboard)
library(dplyr)
library(shinyjs)
library(glue)
library(shinyauthr)

user_base <- data_frame(
  user = c("user1", "user2"),
  password = c("pass1", "pass2"), 
  password_hash = sapply(c("pass1", "pass2"), sodium::password_store), 
  permissions = c("admin", "standard"),
  name = c("User One", "User Two")
)

cellBank <- read_excel('testData.xlsx')


# UI CODE ------------------------------------------------------
ui <- dashboardPage(
  
  dashboardHeader(title = "shinyauthr",
                  tags$li(class = "dropdown", style = "padding: 8px;",
                          shinyauthr::logoutUI("logout")),
                  tags$li(class = "dropdown", 
                          tags$a(icon("github"), 
                                 href = "https://github.com/paulc91/shinyauthr",
                                 title = "See the code on github"))
  ),
  
  dashboardSidebar(collapsed = TRUE, 
                   div(textOutput("welcome"), style = "padding: 20px"),
                   actionButton(inputId = 'EditButton', label = 'Edit'),
                   actionButton(inputId = 'newEntry', label = 'Add new record'),
                   actionButton(inputId = 'editEntry', label = 'Edit Existing record'),
                   # components to add new entry
                   textInput(inputId = 'name', label = 'Name'),
                   textInput(inputId = 'age', label = 'Age'),
                   textInput(inputId = 'gender', label = 'Gender'),
                   textInput(inputId = 'code', label = 'Code'),
                   actionButton(inputId = 'insertData', label = 'Add Data')
  ),
  
  dashboardBody(
    shinyjs::useShinyjs(),
    tags$head(tags$style(".table{margin: 0 auto;}"),
              tags$script(src="https://cdnjs.cloudflare.com/ajax/libs/iframe-resizer/3.5.16/iframeResizer.contentWindow.min.js",
                          type="text/javascript")
              #includeScript("returnClick.js")
    ),
    shinyauthr::loginUI("login"),
    uiOutput("user_table"),
    uiOutput("testUI"),
    HTML('<div data-iframe-height></div>')
  )
)

# SERVER CODE ---------------------------------------------
server <- function(input, output, session) {
  
  # ...credentials module -----------------------------------
  credentials <- callModule(shinyauthr::login, "login", 
                            data = user_base,
                            user_col = user,
                            pwd_col = password_hash,
                            sodium_hashed = TRUE,
                            log_out = reactive(logout_init()))
  
  logout_init <- callModule(shinyauthr::logout, "logout", reactive(credentials()$user_auth))
  
  observe({
    if(credentials()$user_auth) {
      shinyjs::removeClass(selector = "body", class = "sidebar-collapse")
    } else {
      shinyjs::addClass(selector = "body", class = "sidebar-collapse")
    }
  })
  
  # ...user table -----------------------------------
  output$user_table <- renderUI({
    # only show pre-login
    if(credentials()$user_auth) return(NULL)
    
    tagList(
      tags$p("test the different outputs from the sample logins below 
             as well as an invalid login attempt.", class = "text-center"),
      
      renderTable({user_base[, -3]})
      )
  })
  
  # ...making user info from credentials reactive -----------------------------------
  user_info <- reactive({credentials()$info})
  
  # ...button/options show and hide based on user authorization (show/hide) ---------------------------
  observe({
    req(credentials()$user_auth)
    if (user_info()$permissions == "admin") {
      
      shinyjs::show('EditButton')
      shinyjs::hide('newEntry')
      shinyjs::hide('editEntry')
      # new entry components
      shinyjs::hide('name')
      shinyjs::hide('age')
      shinyjs::hide('gender')
      shinyjs::hide('code')
      shinyjs::hide('insertData')
      
    } else if (user_info()$permissions == "standard") {
      
      shinyjs::hide('EditButton')
      shinyjs::hide('newEntry')
      shinyjs::hide('editEntry')
      # new entry components
      shinyjs::hide('name')
      shinyjs::hide('age')
      shinyjs::hide('gender')
      shinyjs::hide('code')
      shinyjs::hide('insertData')
    }
  })

  # ...setting data as reactive -----------------------------------
  user_data <- reactiveValues()
  user_data$df <- cellBank
  
  # ...observeEvent for insertData "Add Data button" -----------------------------------
  observeEvent(input$insertData, {
    
    newRow <- data.frame('Name'=input$name,
                          'Age'=input$age,
                          'Gender'=input$gender,
                          'code'=input$code)
    colnames(newRow)<-colnames(cellBank)
    user_data$df <- rbind(cellBank,newRow)
    #print(user_data$df)
    
  })
  
  # ...observe event for Edit button (show/hide) -------------------
  observeEvent(input$EditButton, {
    
    shinyjs::show('newEntry')
    shinyjs::show('editEntry')
    
  })
  
  # ...observe event to show fields for adding new data (show/hide) -------------------
  observeEvent(input$newEntry, {
    
    shinyjs::show('newEntry')
    shinyjs::show('editEntry')
    # new entry components
    shinyjs::show('name')
    shinyjs::show('age')
    shinyjs::show('gender')
    shinyjs::show('code')
    shinyjs::show('insertData')
    
  })
  
  
  
  output$welcome <- renderText({
    req(credentials()$user_auth)
    
    glue("Welcome {user_info()$name}")
    
  })
  
  
  # ...data table output -----------------------------------
  output$testUI <- renderUI({
    req(credentials()$user_auth)
    
    fluidRow(
      column(
        width = 12,
        tags$h2(glue("Your permission level is: {user_info()$permissions}. 
                     Your data is: {ifelse(user_info()$permissions == 'admin', 'Starwars', 'Storms')}.")),
        box(width = NULL, status = "primary",
            title = ifelse(user_info()$permissions == 'admin', "Starwars Data", "Storms Data"),
            DT::renderDT(user_data$df, options = list(scrollX = TRUE))
        ) # box ends
        )
    )
  }) # end of renderUI
  
} # server ends here

shiny::shinyApp(ui, server)
