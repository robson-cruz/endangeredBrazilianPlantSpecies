library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
library(glue)
library(magrittr)


# Read and join data sets
endangered_BRA <- read.csv2('Especies_Ameacadas_BRA.csv', fileEncoding = "latin1")

# List Chart ##
species_source <- endangered_BRA %>%
        group_by(fonte) %>%
        count(fonte, sort = TRUE)

species_source$fonte <- with(species_source, reorder(fonte, n))

bra <- ggplot(species_source, aes(x = fonte, y = n, fill = n)) +
        geom_col() +
        coord_flip() +
        theme(plot.title = element_text(hjust = 0.5, size = 14),
              legend.position = c(0.9, 0.5)) +
        labs(
                title = 'Espécies Ameaçadas de Extinção no Brasil',
                x = 'Fonte',
                y = 'Nº de espécies',
                fill = ''
        )

# Species Chart by status ##
species_status <- endangered_BRA %>%
        group_by(codStatus) %>%
        count(codStatus, sort = T)

# Reorder the data set by number of status 
species_status$codStatus <- with(species_status, reorder(codStatus, desc(n)))

# Set status code table 
statusCodeTable <- endangered_BRA %>%
        group_by(status_conservacao, codStatus) %>%
        summarise()

# Set chart
sp_status <- ggplot(species_status, aes(x = codStatus, y = n)) +
        geom_col(fill = 'steelblue') +
        scale_fill_manual(name = 'Status',
                          values = c('EN = Em Perigo')) +
        theme(plot.title = element_text(hjust = 0.5, size = 14)) +
        annotation_custom(
                gridExtra::tableGrob(statusCodeTable),
                xmin = 'NT', xmax = 'VU EX', ymin = 800, ymax = 2400
        ) +
        geom_text(aes(label = n, vjust = -1), color = 'red') +
        labs(
                title = 'Categorias de Espécies Ameaçadas de Extinção no Brasil',
                x = 'Status',
                y = 'Nº de espécies'
        )

# Family Chart ##
statusFamily <- endangered_BRA %>%
        filter(familia != "") %>%
        mutate(familia = stringr::str_to_title(familia)) %>%
        group_by(familia) %>%
        summarise(n = n()) %>%
        arrange(desc(n)) %>%
        slice_head(n = 10)


        
statusFamily$familia <- with(statusFamily, reorder(familia, n))

f <- ggplot(statusFamily, aes(familia, n)) +
        geom_col(fill = 'steelblue') + coord_flip() +
        geom_text(aes(label = n, hjust = 2), color = 'white') +
        theme(plot.title = element_text(hjust = 0.5, size = 14)) +
        labs(
                title = '10 Famílias com Maior Número de Espécies Ameaçadas de Extinção no Brasil',
                x = 'Família',
                y = 'Nº de espécies'
        )
