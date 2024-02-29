library(shiny)

source('./scriptApp.R')


shinyServer(function(input, output, session) {
        # Data frame
        output$tbl <- DT::renderDataTable({
                DT::datatable(
                    endangered_BRA, 
                        options = list(
                                pageLength = 6, 
                                rownames = FALSE,
                                language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese.json')
                                ),
                    callback = DT::JS(
                            "table.rows().every(function() {",
                            "  $(this.node()).css('height', '6px');",
                            "});"
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
                        paste('speciesProtegidas', Sys.Date(), '.csv', sep = '')
                },
                content = function(file) {
                        write.csv2(endangered_BRA, file, row.names = FALSE, fileEncoding = 'latin1')
                }
        )
        
        session$onSessionEnded(function() {
                stopApp(returnValue = )
        })
})
