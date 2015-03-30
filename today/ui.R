
library (ggvis)
library (dplyr)



shinyUI(bootstrapPage(
    uiOutput("ggvis_ui"),
    ggvisOutput("ggvis")
  )
)
