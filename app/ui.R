library(shiny)


shinyUI(
        fluidPage(
                theme = shinythemes::shinytheme('flatly'),
                navbarPage(
                        tags$head(includeHTML('google-analytics.html')),
                        title = 'STATUS FLORA BRASIL v1.2.0',
                        lang = "pt-BR",
                        h3('FLORA BRASILEIRA AMEAÇADA DE EXTINÇÃO'),
                        tabPanel('Lista', DT::dataTableOutput('tbl')),
                        tabPanel('Lista Nacional', plotOutput('bra')),
                        tabPanel('Categorias', plotOutput('status')),
                        tabPanel('Familias', plotOutput('family')),
                        navbarMenu(
                                'Download',
                                tabPanel(
                                        downloadButton(
                                                outputId = 'DownloadData',
                                                label = 'Lista de Espécies Ameaçadas'
                                        )
                                )
                        ),
                        navbarMenu(
                                "Metodologia",
                                tabPanel(
                                        HTML("<a href = 'https://github.com/rcflorestal/endangeredBrazilianPlantSpecies/blob/main/README.md' target = '_blank'>Leia!</a>")
                                )
                        )
                        #h5('Santos, Robson Cruz. Espécies da Flora Brasileira Ameaçadas de Extinção. Disponível em: https://wcj7es-robson0cruz.shinyapps.io/specBra/ Acesso em: Jul 2021. DOI: https://zenodo.org/record/5083815')
                )
        )
)
