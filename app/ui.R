## specBra 1.0
library(shiny)

title = (div(tags$h4("FLORA BRASILEIRA AMEAÇADA DE EXTINÇÃO")))

shinyUI(navbarPage(
        titlePanel(title),
        tabPanel('Lista', DT::dataTableOutput('tbl')),
        tabPanel('Lista Nacional', plotOutput('bra')),
        tabPanel('Categorias', plotOutput('status')),
        tabPanel('Familias', plotOutput('family')),
        tabPanel('Download', downloadLink('DownloadData', 'Download'))
        )
        
)
