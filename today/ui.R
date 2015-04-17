library (ggvis)
library (dplyr)


shinyUI(pageWithSidebar(
  headerPanel ("Current output"),
  sidebarPanel(
    dataTableOutput ("theWords")
#    textOutput ("theWords")
  ),
  mainPanel(
    uiOutput("ggvis_ui"),
    ggvisOutput("ggvis")
  )
))
