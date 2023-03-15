library(shiny)

Sys.setlocale(category = 'LC_ALL', locale = 'Portuguese')

source('./scriptApp.R')

# list to download and table
listBRA <- read.csv2('./endangered_BRA_list.csv', sep = ';', encoding = 'latin1')

# list to plots

shinyServer(function(input, output, session) {
        # Data frame
        output$tbl <- DT::renderDataTable({
                DT::datatable(
                        listBRA, 
                        options = list(
                                pageLength = 6, 
                                rownames = FALSE,
                                language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese.json')
                                )
                        )
        })
        # Charts
        output$bra <- renderPlot(bra, width = 800, height = 450)
        output$status <- renderPlot(sp_status, width = 800, height = 450)
        output$family <- renderPlot(f, width = 800, height = 450)
        
        #Download
        output$DownloadData <- downloadHandler(
                filename = function() {
                        paste('speciesProtegidas', Sys.Date(), '.csv', sep = '_')
                },
                content = function(file) {
                        write.csv2(listBRA, file, row.names = FALSE)
                }
        )
        
        session$onSessionEnded(function() {
                stopApp(returnValue = )
        })
})

