library(ggvis)

# For dropdown menu
actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

fluidPage(
  titlePanel("Yelp Doctor Review Sentiment Analysis"),
  fluidRow(
    column(3,
           wellPanel(
             h4("Filter"),
             sliderInput("review", "Minimum number of reviews on Yelp",
                         1, 220, 10, step = 10),
             sliderInput("rating", "Rating", 1, 5, value = c(1, 5)),
             sliderInput("score", "Minimum number of sentiment scores)",
                         -72, 220, 100, step = 10)
           ),
           wellPanel(
             selectInput("xvar", "X-axis variable", axis_vars, selected = "rating"),
             selectInput("yvar", "Y-axis variable", axis_vars, selected = "score")
           )
    ),
    column(9,
           wellPanel(
             span("Yelp Doctor Review Sentiment Analysis:",
                  textOutput("n_reviews")
             )
           ),
           ggvisOutput("plot1")

    )
  )
)