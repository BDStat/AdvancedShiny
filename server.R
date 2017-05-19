
# select specified columns
all_reviews <- df %>%
  # filter(Reviews >= 10) %>%
  select(id, name, city, state, rating, zip_code, review_count, phone, score,
         latitude, longitude)

function(input, output, session) {
  
  # Filter the reviews, returning a data frame
  reviews <- reactive({
    # Due to dplyr issue #318, we need temp variables for input values
    # browser()
    review.i <- input$review
    score.i <- input$score
    minrating.i <- input$rating[1]
    maxrating.i <- input$rating[2]
    # city.i <- input$city
    
    # Apply filters
    m <- all_reviews %>%
      filter(
        review_count >= review.i,
        score >= score.i,
        rating >= minrating.i,
        rating <= maxrating.i
      ) %>%
      arrange(rating)

    m <- as.data.frame(m)
    
    # Add column which says whether the doctor has 0 score
    # Be a little careful in case we have a zero-row data frame
    m$has_score <- character(nrow(m))
    m$has_score[m$score < 0] <- "<= 0"
    m$has_score[m$score > 1] <- "> 0"
    m
  })
  
  # Function for generating tooltip text
  review_tooltip <- function(x) {
    if (is.null(x)) return(NULL)
    if (is.null(x$id)) return(NULL)

    # Pick out the review with this id
    all_reviews <- isolate(reviews())
    review <- all_reviews[all_reviews$id == x$id, ]

    paste0("<b>", "Name: ", review$name, "</b><br>",
           "Phone Number: ", review$phone, "<br>",
           "City: ", review$city, "<br>",
           "Score: ", review$score, "<br>",
           "Rating: ", review$rating, "<br>",
           "Review Count: ", review$review_count
           
    )
  }

  # A reactive expression with the ggvis plot
  # output$plot1 <-renderPlot({
  vis <- reactive({
    # Lables for axes
    xvar_name <- names(axis_vars)[axis_vars == input$xvar]
    yvar_name <- names(axis_vars)[axis_vars == input$yvar]
    
    # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
    # but since the inputs are strings, we need to do a little more work.
    xvar <- prop("x", as.symbol(input$xvar))
    yvar <- prop("y", as.symbol(input$yvar))

    reviews %>%
      ggvis(x = xvar, y = yvar) %>%
      layer_points(size := 50, size.hover := 200,
                   fillOpacity := 0.2, fillOpacity.hover := 0.5,
                   stroke = ~has_score, key := ~id) %>%
      add_tooltip(review_tooltip, "hover") %>%
      add_axis("x", title = xvar_name) %>%
      add_axis("y", title = yvar_name) %>%
      add_legend("stroke", title = "Score", values = c("> 0", "<= 0")) %>%
      scale_nominal("stroke", domain = c("> 0", "<= 0"),
                    range = c("orange", "#aaa")) %>%
      set_options(width = 800, height = 300)
  })
  
  vis %>% bind_shiny("plot1")
  
  output$n_reviews <- renderText({ paste0("The sentiment analysis is based on 969 online reviews",
               " (as judged by the Yelp customers), and the rating is",
                                         " a normalized 1-5 score of those reviews which have star ratings",
                                         " (for example, 3 out of 4 stars).)") 
               })
}