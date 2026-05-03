# Load library 
library(shiny)
library(readxl)
library(dplyr)
library(plotly)
library(markdown)
library(tidyverse)
library(plotly)

# Load and clean data
pima_data <- read.csv("data/Pima Indians diabetes dataset (PIDD).csv", check.names = FALSE) %>%
  mutate(
    Glucose = na_if(Glucose, 0),
    `Body mass index` = na_if(`Body mass index`, 0),
    Insulin = na_if(Insulin, 0),
    Outcome = factor(Outcome, levels = c(0, 1), labels = c("Non-diabetic", "Diabetic"))
  )

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
      title = "Visualization of age and glucose",  # Change this title
      value = "tab3",
      
      # ==============================================
      # START OF CONTENT FOR TAB 3
      # ^^^^^^^^^^^^^^^^^^^^^^^^^^^
      # ADD YOUR ANALYSIS CODE HERE:
      # - Statistical summaries
      # - Data tables (DT, reactable)
      # - Analysis outputs
      # ==============================================
      
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
    
    # =====================================================
    # TAB 4: [TAB NAME] - POSITION INDEX 4
    # =====================================================
    
    tabPanel(
      title = "Tab 4: Metabolic Profiles", 
      value = "tab4",
      # Title of the plot
      h3("Metabolic profiles by Genetic Risk"),
      p("The purpose of this faceted bubble plot is to provide an understanding of how metabolic health determines the outcome of diabetes (whether you have it or not). Hover over the points to see individual data, and adjust the slider to see the range of outcomes."),
      
      # Set layout of plot for better spacing
      fluidRow(
        column(width = 12,
               plotlyOutput(outputId = "metabolic_plot", height = "500px")
        )
      ),
      
      br(), # <= empty line to seperate contents
      
      # Set layout of slider
      fluidRow(
        column(width = 8, offset = 1, # <= place slider to middle of graph
               wellPanel(
                 sliderInput(
                   inputId = "genetic_risk", 
                   label = "Genetic Risk Threshold (Diabetes Pedigree Function)", 
                   min = min(pima_data$`Diabetes pedigree function`), 
                   max = max(pima_data$`Diabetes pedigree function`), 
                   value = c(min(pima_data$`Diabetes pedigree function`), 
                             max(pima_data$`Diabetes pedigree function`)),
                   step = 0.05, # <= set to cover all data
                   width = "100%"
                 )
               )
        )
      ),
      
      # Set layout of markdown content
      fluidRow(
        column(width = 12, #offset = 2,
               includeMarkdown("tab4_description.md")
        )
      )
    )
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
  # SERVER LOGIC FOR TAB 4 (INDEX 4)
  # =====================================================
  
  # Let the data shown adjust accordingly to user input in slider
  filtered_data <- reactive({
    pima_data %>%
      filter(`Diabetes pedigree function` >= input$genetic_risk[1],
             `Diabetes pedigree function` <= input$genetic_risk[2])
  })
  # Allows the plot to auto-refresh 
  output$metabolic_plot <- renderPlotly({
    # Plotting graph
    p <- ggplot(filtered_data(), aes(x = Glucose, 
                                     y = Insulin, 
                                     color = Outcome, 
                                     size = `Diabetes pedigree function`,
                                     text = paste("Genetic Risk Index:", `Diabetes pedigree function`))) +
      geom_point(alpha = 0.6) +
      scale_size(range = c(1, 10)) +
      theme_minimal() +
      labs(x = "Glucose Concentration",
           y = "Serum Insulin (mu U/ml)",
           size = "Pedigree Function") +
      # Colour-blind friendly colours
      scale_color_manual(values = c("Non-diabetic" = "olivedrab4", "Diabetic" = "red3")) +
      facet_wrap(~ Outcome) # Splits the data into two facets to reduce overlapping
    
    ggplotly(p, tooltip = "text") %>%
      layout(margin = list(t = 50, b = 50)) # <= Prevent axis labels from being cut off due to render errors
  })
  
}

# Run the application
shinyApp(ui=ui, server=server )
