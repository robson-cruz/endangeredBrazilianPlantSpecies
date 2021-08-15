## Load libraries
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
#library(plotly)

## Set work directory
setwd('D:/Robson/data/endangeredSpecies/endangeredBrazilianPlantSpecies/')

## Read the list of status source
listStatus <- read.delim('./data/listStatus.txt', sep = '\t', encoding = 'UTF-8')

## Read the endangered species of the state of Minas Gerais 
MG <- read.delim(
        './data/MG_Delib_COPAM_367-2008.txt',
        sep = '\t'
) %>%
        mutate(
                scientificName = if_else(scientificName == "", 
                                         stringr::word(Supplied.Name, 1, 2), 
                                         scientificName)
        ) %>%
        mutate(
                statusSource = recode(
                        statusSource, 
                        'Regionalmente Extinto' = 'Regionalmente Extinta'
                )
        ) %>%
        mutate(source = 'MG') %>%
        mutate(list = 'Lista Flora Ameaçada Minas Gerais') %>%
        mutate(
                scientificName = recode(
                        scientificName, 
                        '& Brederoo' = 'Micranthocereus auriazureus',
                        '(Herreriaceae) Herreria' = 'Herreria interrupta'
                )
        ) %>%
        mutate(statusSource = recode(statusSource, 'EX' = 'Extinta')) %>%
        mutate(dispLegal = 'Deliberação COPAM 367/2008') %>%
        select(family, scientificName, statusSource, status, source, list, dispLegal)

## Read the endangered species of the state of Rio Grande do Sul
RS <- read.delim(
        './data/RS_endangerdSpecies_Dec_51.109-2014.txt', 
        sep = '\t'
) %>%
        rename(family = Familia, scientificName = nomeCientifico, 
               status = Categoria) %>%
        left_join(listStatus, by = 'status') %>%
        mutate(source = 'RS') %>%
        mutate(list = 'Lista Flora Ameaçada Rio Grande do Sul') %>%
        mutate(dispLegal = 'Decreto Estadual 51/2014') %>%
        select(family, scientificName, statusSource, status, source, list, dispLegal)


## Read the endangered species of the state of Para
PA <- read.delim(
        './data/PA_Res_endangeredSpecies_Res_COEMA_54-2007.txt',
        sep = '\t', encoding = 'UTF-8'
) %>%
        rename(family = Familia, scientificName = NomeCientífico) %>%
        mutate(
                statusSource = recode(
                        statusSource, 
                        'Em perigo' = 'Em Perigo', 
                        'Criticamente em perigo' = 'Criticamente em Perigo'
                )
        ) %>%
        left_join(listStatus, by = 'statusSource') %>%
        mutate(source = 'PA') %>%
        mutate(list = 'Lista Flora Ameaçada Pará') %>%
        mutate(dispLegal = 'Resolução COEMA 54/2007') %>%
        ## current scientific name
        mutate(scientificName == 'Handroanthus impetiginosus') %>%
        ## SISTAXON scientific name
        mutate(scientificName == 'Handroanthus impetiginosum') %>%
        select(family, scientificName, statusSource, status, source, list, dispLegal)
        

## Read the endangered species of the state of Parana
PR <- read.delim(
        './data/PR_endangerdSpecies_Dec_PR_01-2010.txt',
        sep = '\t'
) %>%
        mutate(status = recode(status, 'V' = 'VU')) %>%
        filter(sourceStatus != 'Dados Insuficientes') %>%
        filter(sourceStatus != 'Não Avaliado') %>%
        rename(statusSource = sourceStatus) %>%
        mutate(
                statusSource = recode(
                        statusSource, 
                        'Regionalmente Extinto' = 'Regionalmente Extinta'
                )
        ) %>%
        mutate(source = 'PR') %>%
        mutate(list = 'Lista Flora Ameaçada Paraná') %>%
        mutate(dispLegal = 'Decreto Estadual 7264/2010') %>%
        select(family, scientificName, statusSource, status, source, list, dispLegal)


## Read the endangered species of the state of Sao Paulo
SP <- read.csv(
        'data/SP_endangerdSpecies_Res_SMA_057-2016.csv',
        sep = ',', encoding = 'UTF-8'
) %>%
        filter(statusSource != 'Dados Insuficientes', kingdom != 'Animalia') %>%
        mutate(
                statusSource = recode(
                        statusSource, 
                        'VU EX' = 'Vulnerável / Presumivelmente Extinta',
                        'EW' = 'Extinta na Natureza',
                        'Em perigo' = 'Em Perigo'
                )
        ) %>%
        mutate(statusSource = recode(statusSource, 'EW' = 'Extinta na Natureza')) %>%
        mutate(statusSource = recode(statusSource, 
                                     'Quase Ameaçada' = 'Em Perigo')) %>%
        mutate(status = recode(status, 'NT' = 'EN')) %>%
        mutate(
                scientificName = if_else(scientificName == "", 
                                         stringr::word(Supplied.Name, 1, 2),
                                         scientificName)
        ) %>%
        mutate(source = 'SP') %>%
        mutate(list = 'Lista Flora Ameaçada São Paulo') %>%
        mutate(dispLegal = 'Resolucao SMA 57/2016') %>%
        select(family, scientificName, statusSource, status, source, list, dispLegal)

        

## Read the endangered species of the state of Espirito Santo
ES <- read.csv(
        'data/ES_endangeredSpecies_Dec_1.499-R.csv',
        sep = ',', encoding = 'UTF-8'
) %>%
        mutate(
                statusSource = recode(
                        statusSource, 
                        'CriticamEm Perigote em Perigo' = 
                        'Criticamente em Perigo'
                )
        ) %>%
        filter(status != 'DD') %>%
        mutate(
                scientificName = if_else(scientificName == "", 
                                         stringr::word(Supplied.Name, 1, 2), 
                                         scientificName)
        ) %>%
        mutate(source = 'ES') %>%
        mutate(list = 'Lista Flora Ameaçada Espirito Santo') %>%
        mutate(dispLegal = 'Decreto Estadual 1499-R') %>%
        select(family, scientificName, statusSource, list, source, dispLegal) %>%
        left_join(listStatus, by = 'statusSource')


## Read the endangered species of the state of Bahia
BA <- read.csv(
        './data/BA_fauna_flora._Avaliação_de_2017..csv', sep = ',', 
        encoding = 'UTF-8'
) %>%
        mutate(statusSource = recode(statusSource, 'En' = 'Em Perigo')) %>%
        mutate(
                scientificName = if_else(scientificName == "", 
                                         stringr::word(Supplied.Name, 1, 2), 
                                         scientificName)
        ) %>%
        filter(kingdom != 'Animalia') %>%
        mutate(source = 'BA') %>%
        mutate(list = 'Lista Flora Ameaçada Bahia') %>%
        mutate(dispLegal = 'Portaria SEMA-BA 40/2017') %>%
        mutate(status = toupper(status)) %>%
        select(family, scientificName, statusSource, status, source, list, dispLegal)

## Read the endangered species of the state of Santa Catarina
SC <- read.csv(
        './data/SC_Flora_(Avaliação_de_2014)_Fauna_(Avaliação_de_2011).csv',
        sep = ',', encoding = 'UTF-8'
) %>%
        mutate(
                scientificName = if_else(scientificName == "", 
                                         stringr::word(Supplied.Name, 1, 2),
                                         scientificName)
        ) %>%
        mutate(
                statusSource = recode(
                        statusSource, 
                        'Criticamente em perigo' = 'Criticamente em Perigo'
                )
        ) %>%
        mutate(statusSource = recode(statusSource, 'EW' = 'Extinta na Natureza')) %>%
        mutate(statusSource = recode(statusSource, 'Extinto' = 'Extinta')) %>%
        filter(kingdom != 'Animalia', statusSource != 'Dados Insuficientes') %>%
        mutate(source = 'SC') %>%
        mutate(list = 'Lista Flora Ameaçada Santa Catarina') %>%
        mutate(dispLegal = 'Resolução CONSAMA 51/2014') %>%
        select(family, scientificName, statusSource, status, source, list, dispLegal)

## Read the endangered species of the Portaria MMA 443/2014
port443 <- read.csv('./data/port443.csv', sep = ';') %>%
        rename(status = threatStatus) %>%
        left_join(listStatus, by = 'status') %>%
        filter(status != 'NE') %>%
        mutate(source = 'Portaria 443') %>%
        mutate(list = 'Lista Portaria 443') %>%
        mutate(dispLegal = 'Portaria MMA 443/2014') %>%
        select(family, scientificName, statusSource, status, source, list, dispLegal)

## Read the list of endangered species from the Brazilian Ministry of Environment ##
flora_fauna <- read.csv2(
        'D:/Robson/data/endangeredSpecies/endangeredBrazilianPlantSpecies/data/MMA_lista-de-especies-ameacas-2020.csv',
        encoding = 'UTF-8', header = TRUE, sep = ';'
) %>%
        filter(X.U.FEFF.Lista == 'Fauna') %>%
        select(Especie.Simplificado) %>%
        rename(scientificName = Especie.Simplificado)

## CITES
cites <- read.csv('D:/Robson/data/cites/cites_listings_2021-08-13 07_10.csv') %>%
        filter(Kingdom == 'Plantae') %>%
        rename(scientificName = Scientific.Name) %>%
        rename(family = Family) %>%
        # mutate(statusSource = '') %>%
        # mutate(status = '') %>%
        # mutate(source = '') %>%
        # mutate(list = '') %>%
        mutate(CITES = paste0('Anexo ', Listing, ' CITES')) %>%
        select(scientificName, CITES)

## Merge the data sets ##
endangered_list <- rbind(BA, ES, MG, PA, PR, RS, SC, SP, port443) %>%
        #Remove species of fauna
        anti_join(flora_fauna, by = 'scientificName') %>%
        left_join(cites, by = 'scientificName') %>%
        filter(!is.na(scientificName)) %>%
        mutate(CITES = ifelse(is.na(CITES), 'Não', CITES))
        

# endangered_by_state <- rbind(BA, ES, MG, PA, PR, RS, SC, SP) %>%
#         anti_join(flora_fauna, by = 'scientificName')

## Remove duplicated species between the Portaria MMA 443 and the state lists ##
# auxList <- endangered_by_state %>% select(scientificName)

# port443_cleaned <- port443 %>%
#         anti_join(auxList, by = 'scientificName')

## Final data set
# endangered_BRA <- rbind(port443_cleaned, endangered_by_state)
        

## Save the data set ##
write.csv2(endangered_list, './output/endangered_BRA.csv', row.names = FALSE)

## List Chart ##
species_source <- endangered_list %>%
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
species_status <- endangered_list %>%
        group_by(status) %>%
        count(status, sort = T)

## Reorder the data set by number of status 
species_status$status <- with(species_status, reorder(status, desc(n)))

## Set status code table 
statusCodeTable <- endangered_list %>%
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



#ggplotly(sp_status)

## Family Chart ##
statusFamily <- endangered_list %>%
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


## Species Table ##
sp <- endangered_list %>%
        rename(
                Familia = family, Nome_Cientifico = scientificName,
                Categoria = statusSource, Cod. = status,
                Fonte = source, Lista = list, Dispositivo_Legal = dispLegal
        )
        
DT::datatable(sp)
