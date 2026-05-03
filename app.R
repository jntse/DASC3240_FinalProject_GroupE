#load library 
library(shiny)
library(readxl)
library(dplyr)
library(plotly)

# Define UI
ui <- fluidPage(
  
  # Application title (change tha app name when desired the dataset )
  titlePanel("Your Shiny Application"),
  
  # Tab layout
  tabsetPanel(
    
    # =====================================================
    # TAB 1: [TAB NAME] - POSITION INDEX 1
    # =====================================================
    tabPanel(
      title = "Tab 1: Data Overview",  # Change this title
      value = "tab1",
      
      # ==============================================
      # START OF CONTENT FOR TAB 1
      # ^^^^^^^^^^^^^^^^^^^^^^^^^^^
      # ADD YOUR CONTENT HERE:
      # - Input controls (sliders, dropdowns, etc.)
      # - Output displays (plots, tables, text)
      # - Layout elements (sidebar, columns, etc.)
      # ==============================================
      
      # Example placeholder content: <---this is shows to display the content of tab1 , please delete it when working 
      h3("Content for Tab 1"),
      p("Add your content here..."),
      
      # Remove the example above and paste your code here
      
      # ==============================================
      # END OF CONTENT FOR TAB 1
      # ==============================================
    ),
    
    # =====================================================
    # TAB 2: [TAB NAME] - POSITION INDEX 2
    # =====================================================
    tabPanel(
      title = "Tab 2: Data Visualization",  # Change this title( if necessary )
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
      title = "Tab 3: Visualization of age and glucose",  # Change this title
      value = "tab3",
      
      includeMarkdown("tab3_description.md"),
      
      
      mainPanel(
        
        tableOutput("feature_table"),
        hr(),
        
        h5('License:'),
        a("CC BY 4.0", href= "https://creativecommons.org/licenses/by/4.0/deed.en")
      ),
      
      selectizeInput(
        inputId = "outcome",
        label = "Select Diabetes Outcome",
        choices = c("All" = "All", "No Diabetes" = "0", "Diabetes" = "1"),
        selected = "All"
      ),
      
      sliderInput(
        inputId = "age_range",
        label = "Select Age Range",
        min = 20,
        max = 85,
        value = c(20, 85),
        step = 1
      ),
      
      plotlyOutput(outputId = "p")
    ),
    
    # ==============================================
    # END OF CONTENT FOR TAB 3
    # ==============================================
  
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
  # SERVER LOGIC FOR TAB 1 (INDEX 1)
  # =====================================================
  # Add reactive expressions, outputs for Tab 1 here
  
  # =====================================================
  # SERVER LOGIC FOR TAB 2 (INDEX 2)
  # =====================================================
  # Add reactive expressions, outputs for Tab 2 here
  
  # =====================================================
  # SERVER LOGIC FOR TAB 3 (INDEX 3)
  # Load and prepare data
  full_data <- reactive({
    df <- read.csv("data/Pima Indians diabetes dataset (PIDD).csv")
    
    # Standardize column names
    colnames(df) <- c("Pregnancies", "Glucose", "BloodPressure", "SkinThickness", 
                      "Insulin", "BMI", "DiabetesPedigreeFunction", "Age", "Outcome")
    
    df <- df %>%
      mutate(
        Glucose = as.numeric(Glucose),
        Age = as.numeric(Age),
        Outcome = factor(Outcome, levels = c(0, 1), labels = c("No Diabetes", "Diabetes"))
      ) %>%
      filter(Glucose > 0, Age > 0)  # Remove invalid zeros
    
    df
  })
  #filter data based on user input 
  filtered_data <- reactive({
    df <- full_data()
    
    # Filter by age range
    df <- df %>% filter(Age >= input$age_range[1] & Age <= input$age_range[2])
    
    # Filter by outcome
    if (input$outcome != "All") {
      outcome_label <- ifelse(input$outcome == "1", "Diabetes", "No Diabetes")
      df <- df %>% filter(Outcome == outcome_label)
    }
    
    df
  })
  # Create summary statistics by age group
  age_summary <- reactive({
    df <- filtered_data()
    
    df %>%
      mutate(AgeGroup = cut(Age, 
                            breaks = seq(20, 85, by = 5), 
                            labels = paste(seq(20, 80, by = 5), seq(24, 84, by = 5), sep = "-"),
                            include.lowest = TRUE)) %>%
      group_by(AgeGroup, Outcome) %>%
      summarise(
        Count = n(),
        .groups = 'drop'
      ) %>%
      tidyr::complete(AgeGroup, Outcome, fill = list(Count = 0))
  })
  output$p <- renderPlotly({
    df <- filtered_data()
    summary_df <- age_summary()
    
    # Create bar plot using plotly
    if (input$outcome == "All") {
      # Show both outcomes side by side
      p <- plot_ly(summary_df, 
                   x = ~AgeGroup, 
                   y = ~Count, 
                   color = ~Outcome,
                   type = "bar",
                   colors = c("No Diabetes" = "#1f77b4", "Diabetes" = "#ff7f0e"),
                   text = ~Count,
                   textposition = 'auto',
                   hovertemplate = paste(
                     "<b>Age Group: %{x}</b><br>",
                     "Outcome: %{data.name}<br>",
                     "Count: %{y}<br>",
                     "<extra></extra>"
                   )) %>%
        layout(
          title = list(
            text = paste("Diabetes Outcomes by Age Group<br>",
                         "<sup>Age Range:", input$age_range[1], "-", input$age_range[2], "years</sup>"),
            font = list(size = 14)
          ),
          xaxis = list(
            title = "Age Group (years)",
            tickangle = -45,
            tickfont = list(size = 10)
          ),
          yaxis = list(
            title = "Number of Individuals",
            gridcolor = '#e9e9e9',
            zerolinecolor = '#cccccc'
          ),
          barmode = 'group',
          legend = list(
            title = list(text = "Diabetes Status"),
            orientation = 'h',
            yanchor = 'bottom',
            y = 1.02,
            xanchor = 'right',
            x = 1
          ),
          plot_bgcolor = '#f8f9fa',
          paper_bgcolor = '#ffffff'
        )
    } else {
      # Show only selected outcome
      p <- plot_ly(summary_df, 
                   x = ~AgeGroup, 
                   y = ~Count, 
                   type = "bar",
                   marker = list(color = ifelse(unique(summary_df$Outcome) == "Diabetes", "#ff7f0e", "#1f77b4")),
                   text = ~Count,
                   textposition = 'auto',
                   hovertemplate = paste(
                     "<b>Age Group: %{x}</b><br>",
                     "Count: %{y}<br>",
                     "<extra></extra>"
                   )) %>%
        layout(
          title = list(
            text = paste(unique(summary_df$Outcome), "Outcomes by Age Group<br>",
                         "<sup>Age Range:", input$age_range[1], "-", input$age_range[2], "years</sup>"),
            font = list(size = 14)
          ),
          xaxis = list(
            title = "Age Group (years)",
            tickangle = -45,
            tickfont = list(size = 10)
          ),
          yaxis = list(
            title = "Number of Individuals",
            gridcolor = '#e9e9e9',
            zerolinecolor = '#cccccc'
          ),
          plot_bgcolor = '#f8f9fa',
          paper_bgcolor = '#ffffff'
        )
    }
    # Add total count annotation
    total_count <- nrow(df)
    p <- p %>% add_annotations(
      text = paste("Total Individuals in Range:", total_count),
      xref = "paper",
      yref = "paper",
      x = 0.02,
      y = 0.98,
      showarrow = FALSE,
      font = list(size = 11, color = "#666666"),
      bgcolor = "rgba(255, 255, 255, 0.8)"
    )
    
    p
  })
}
  # Add reactive expressions, outputs for Tab 3 here
  
  # =====================================================
  # SERVER LOGIC FOR TAB 4 (INDEX 4) - OPTIONAL

# Add reactive expressions, outputs for Tab 4 here

# Run the application
shinyApp(ui=ui, server=server )
