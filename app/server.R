library(shiny)

Sys.setlocale(category = 'LC_ALL', locale = 'Portuguese')

source('./scriptApp.R')

sp <- read.csv('./endangered_BRA.csv', sep = ';', encoding = 'latin1')

shinyServer(function(input, output, session) {
        # Data frame
        output$tbl <- DT::renderDataTable({
                DT::datatable(sp, 
                              options = list(pageLength = 6, rownames = FALSE))
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
                        write.csv2(sp, file, row.names = FALSE)
                }
        )
        
        session$onSessionEnded(function() {
                stopApp()
        })
})

