library(dplyr)
library(ggplot2)

Sys.setlocale(category = 'LC_ALL', locale = 'Portuguese')

## Read the data sets
endangered_BRA <- read.csv('./endangered_BRA.csv', sep = ';',encoding = 'latin1')

## List Chart ##
species_source <- endangered_BRA %>%
        group_by(source) %>%
        count(source, sort = TRUE)
species_source$source <- with(species_source, reorder(source, n))

bra <- ggplot(species_source, aes(x = source, y = n, fill = n)) +
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

## Species Chart by status ##
species_status <- endangered_BRA %>%
        group_by(status) %>%
        count(status, sort = T)

## Reorder the data set by number of status 
species_status$status <- with(species_status, reorder(status, desc(n)))

## Set status code table 
statusCodeTable <- endangered_BRA %>%
        group_by(status, statusSource) %>%
        summarise()

## Set chart
sp_status <- ggplot(species_status, aes(x = status, y = n)) +
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

## Family Chart ##
statusFamily <- endangered_BRA %>%
        filter(family != "") %>%
        mutate(family = stringr::str_to_title(family)) %>%
        count(family, sort = TRUE) %>%
        slice_max(n, n=10)

statusFamily$family <- with(statusFamily, reorder(family, n))

f <- ggplot(statusFamily, aes(family, n)) +
        geom_col(fill = 'steelblue') + coord_flip() +
        geom_text(aes(label = n, hjust = 2), color = 'white') +
        theme(plot.title = element_text(hjust = 0.5, size = 14)) +
        labs(
                title = '10 Famílias com Maior Número de Espécies Ameaçadas de Extinção no Brasil',
                x = 'Família',
                y = 'Nº de espécies'
        )
