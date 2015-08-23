library (ggvis)
library (DT)
#library (dplyr)


#shinyUI(pageWithSidebar(
shinyUI(fluidPage(
  headerPanel ("Alan's heart rate today"),
  fluidRow (
        column (width = 12, ggvisOutput("cumsum")), column (3, checkboxGroupInput("checkGroup", 
        label = h3("Pick Plots"), 
        choices = list("Heart rate" = 1, 
           "Acceleration" = 2, "Speed" = 3),
        selected = 1))
    )
))
