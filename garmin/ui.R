library (ggvis)
library (DT)
#library (dplyr)


#shinyUI(pageWithSidebar(
shinyUI(fluidPage(
  headerPanel ("Alan's heart rate today"),
  fluidRow (
        column (width = 5, ggvisOutput("cumsum"))
    )
))
