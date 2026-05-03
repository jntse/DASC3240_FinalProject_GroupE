#load library 
library(shiny)
library(markdown)


# Define UI
ui <- fluidPage(
  
  # Application title 
  titlePanel("Visualization of diabetes "),
  
  # Tab layout
  tabsetPanel(
    
    
    # TAB 1
    tabPanel(
      title = "Tab 1: Dataset Overview",  
      value = "tab1",
      
 
      includeMarkdown("tab1_description.md"),
      
      
      mainPanel(
       
        tableOutput("feature_table"),
        hr(),
        
        h5('License:'),
        a("CC BY 4.0", href= "https://creativecommons.org/licenses/by/4.0/deed.en")
      )
      
 
    ),
    
    # =====================================================
    # TAB 2: [TAB NAME] - POSITION INDEX 2
    # =====================================================
    tabPanel(
      title = "Tab 2: Data Visualization",  
      value = "tab2",
      
      # ==============================================
      # START OF CONTENT FOR TAB 2
      # ^^^^^^^^^^^^^^^^^^^^^^^^^^^
      # ADD YOUR VISUALIZATION CODE HERE:
      # - Plot outputs (ggplotly, plotly, ggplot2)
      # - Interactive charts
      # - Visualization controls
      # ==============================================
      
      # Example placeholder content: 
      h3("Content for Tab 2"),
      p("Add your visualizations here..."),
      
      # Remove the example above and paste your code here
      
      # ==============================================
      # END OF CONTENT FOR TAB 2
      # ==============================================
    ),
    
    # =====================================================
    # TAB 3: [TAB NAME] - POSITION INDEX 3
    # =====================================================
    tabPanel(
      title = "Tab 3: Data Analysis",  # Change this title
      value = "tab3",
      
      # ==============================================
      # START OF CONTENT FOR TAB 3
      # ^^^^^^^^^^^^^^^^^^^^^^^^^^^
      # ADD YOUR ANALYSIS CODE HERE:
      # - Statistical summaries
      # - Data tables (DT, reactable)
      # - Analysis outputs
      # ==============================================
      
      # Example placeholder content:
      h3("Content for Tab 3"),
      p("Add your analysis outputs here..."),
      
      # Remove the example above and paste your code here
      
      # ==============================================
      # END OF CONTENT FOR TAB 3
      # ==============================================
    ),
    
    # =====================================================
    # TAB 4: [TAB NAME] - POSITION INDEX 4 (OPTIONAL)
    # =====================================================
    # Uncomment the code below to add a 4th tab
    
     tabPanel(
       title = "Tab 4: Reports/Export",  # Change this title
      value = "tab4",
    #   
    #   # ==============================================
    #   # START OF CONTENT FOR TAB 4
    #   # ^^^^^^^^^^^^^^^^^^^^^^^^^^^
    #   # ADD YOUR REPORT/EXPORT CODE HERE:
    #   # - Download buttons
    #   # - Report generation
    #   # - Export functionality
    #   # ==============================================
    #   
    #   h3("Content for Tab 4"),
    #   p("Add your export/report code here..."),
    #   
    #   # ==============================================
    #   # END OF CONTENT FOR TAB 4
    #   # ==============================================
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # =====================================================
  # SERVER LOGIC FOR TAB 1
  # =====================================================
  
  #create the features data frame 
  feature_df <- data.frame(
    Feature = c("Pregnancies", "Glucose", "Blood Pressure", "Skin Thickness", 
                "Insulin", "BMI", "Diabetes Pedigree function", "Age", "Outcome"),
    Description = c("Number of pregnancies", "Plasma glucose from glucose test (mg/dL)", "Blood pressure (mm Hg)",
                    "Skin thickness(mm)", "Insulin level", "Body mass index(weight/height)",
                    "likelihood of diabetes based on family history index  , from(0-2.5)", "Age in years", "Diabetes (1=Yes, 0=No)"))
  
  # use table to visualise the features explanation
  output$feature_table <- renderTable({
    feature_df  
  }, striped = TRUE, hover = TRUE, bordered = TRUE)
  
  
  # =====================================================
  # SERVER LOGIC FOR TAB 2 (INDEX 2)
  # =====================================================
  # Add reactive expressions, outputs for Tab 2 here
  
  # =====================================================
  # SERVER LOGIC FOR TAB 3 (INDEX 3)
  # =====================================================
  # Add reactive expressions, outputs for Tab 3 here
  

  
  
  
  # =====================================================
  # SERVER LOGIC FOR TAB 4 (INDEX 4) - OPTIONAL
  # =====================================================
  # Add reactive expressions, outputs for Tab 4 here
  
}

# Run the application
shinyApp(ui=ui, server=server )