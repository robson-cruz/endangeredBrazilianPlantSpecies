## specBra 1.2.0
library(shiny)

Sys.setlocale(category = 'LC_ALL', locale = 'Portuguese')

shinyUI(navbarPage(
        title = 'STATUS FLORA BRASIL v1.2.0',
        h3('FLORA BRASILEIRA AMEAÇADA DE EXTINÇÃO'),
        br(),
        tabPanel('Lista', DT::dataTableOutput('tbl')),
        tabPanel('Lista Nacional', plotOutput('bra')),
        tabPanel('Categorias', plotOutput('status')),
        tabPanel('Familias', plotOutput('family')),
        tabPanel('Download', downloadLink('DownloadData', 'Download')),
        br(),
        br()
        #h5('Santos, Robson Cruz. Espécies da Flora Brasileira Ameaçadas de Extinção. Disponível em: https://wcj7es-robson0cruz.shinyapps.io/specBra/ Acesso em: Jul 2021. DOI: https://zenodo.org/record/5083815')
        )
        
)
