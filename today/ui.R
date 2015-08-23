library (ggvis)
library (DT)
#library (dplyr)


#shinyUI(pageWithSidebar(
shinyUI(fluidPage(
  headerPanel ("current output"),
  fluidRow (
        column (width = 5, ggvisOutput("cumsum")), column (width = 4, ggvisOutput("powervis"))
    ),
  DT::dataTableOutput ("theWords")
))
