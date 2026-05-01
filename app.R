#load library 
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

# =====================================================
# DATA LOADING & CLEANING
# =====================================================
# Read the dataset and replace erroneous 0s with NAs for biological variables
# Convert Outcome into a Factor (0 = Negative, 1 = Positive)
pima_data <- read.csv("data/Pima Indians diabetes dataset (PIDD).csv", check.names=FALSE) %>%
  mutate(
    Glucose = na_if(Glucose, 0),
    `Body mass index` = na_if(`Body mass index`, 0),
    Insulin = na_if(Insulin, 0),
    Outcome = factor(Outcome, levels = c(0, 1), labels = c("Negative", "Positive"))
  )

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
      title = "Graph 1: General Overview of the Dataset",  # Change this title( if necessary )
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
      h3("Glucose Distribution by Diagnosis"),
      p("This interactive violin and jitter plot provides a high-level overview of Glucose, the most predictive variable in the dataset. Hover over the points to see individual patient data, including the 'gray area' overlap between positive and negative diagnoses."),
      
      # Output display for the interactive plot
      plotlyOutput("glucosePlot", height = "500px")
      
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
  # SERVER LOGIC FOR TAB 1 (INDEX 1)
  # =====================================================
  # Add reactive expressions, outputs for Tab 1 here
  
  # =====================================================
  # SERVER LOGIC FOR TAB 2 (INDEX 2)
  # =====================================================
  # Render the interactive Plotly graph for Glucose vs Outcome
  output$glucosePlot <- renderPlotly({
    
    # Create the ggplot with Violin + Jitter overlay
    # Pre-calculate means for labeling (or let ggplot do it)
    # round to the nearest whole number for a cleaner visual
    p <- ggplot(pima_data, aes(x = Outcome, y = Glucose, fill = Outcome)) +
      
      # Shaded "Gray Area" rectangle
      annotate("rect", xmin = -Inf, xmax = Inf, ymin = 100, ymax = 140, 
               alpha = 0.1, fill = "grey50") +
      
      # Main visual layers: Violin + Jitter
      geom_violin(alpha = 0.6, trim = FALSE, color = "black") +
      geom_jitter(aes(color = Outcome), width = 0.15, alpha = 0.4, size = 1.2) +
      
      # ADDING THE MEANS: Large white diamonds to represent the average
      stat_summary(fun = mean, geom = "point", shape = 18, size = 4, color = "white", stroke = 1) +
      
      # Labels for the means
      annotate("text", x = 1, y = 111, label = "Mean: 111", vjust = -1.5, fontface = "bold") +
      annotate("text", x = 2, y = 142, label = "Mean: 142", vjust = -1.5, fontface = "bold") +
      
      # Formatting
      geom_hline(yintercept = c(100, 140), linetype = "dashed", color = "grey40", alpha = 0.5) +
      labs(
        x = "Diabetes Outcome",
        y = "Plasma Glucose Concentration",
        title = "Glucose Distribution with Group Means"
      ) +
      theme_minimal() +
      theme(legend.position = "none") +
      scale_fill_manual(values = c("Negative" = "#2c7bb6", "Positive" = "#d7191c")) +
      scale_color_manual(values = c("Negative" = "#2c7bb6", "Positive" = "#d7191c"))
    
    ggplotly(p)
  })
  
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