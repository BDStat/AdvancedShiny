library(shiny)
library(ggplot2)
library(ggmap)

function(input, output, session) {
  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    cleantable[, c(input$name, input$rating, input$city)]
  })
  
  output$map <- renderPlot({
    # par(mar = c(5.1, 4.1, 0, 1))
    
    # get a Google map
    map <- get_map(
      location = 'new york',
      zoom = 11,
      maptype = "terrain",
      source = 'google',
      color = 'color'
    )
    objMap <- ggmap(map) + geom_point(
      aes(
        x = longitude,
        y = latitude,
        size = rating,
        show_guide = TRUE,
        colour = rating
      ),
      data = selectedData(),
      alpha = .8,
      na.rm = T
    )
    
    # call the objMap object to see the plot
    objMap
  })
  
}


