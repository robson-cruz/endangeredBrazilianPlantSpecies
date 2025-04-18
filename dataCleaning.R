# Load libraries
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
library(magrittr)


# Read the list of status source
listStatus <- read.delim('./data/listStatus.txt', sep = '\t', encoding = 'UTF-8')

# Read REFLORA data
reflora <-
    read.csv2("./data/reflora_v393_409.csv", fileEncoding = "UTF-8") |>
    select(-scientificName) |>
    rename(scientificName = specie)

# Read the list of endangered species from the Brazilian Ministry of Environment
fauna <- read.csv2(
    './data/MMA_lista-de-especies-ameacas-2020.csv',
    encoding = 'UTF-8',
    header = TRUE,
    sep = ';'
) |>
    filter(Lista == 'Fauna') |>
    select(Especie.Simplificado) |>
    rename(scientificName = Especie.Simplificado) |>
    arrange(scientificName)

# Read the endangered species of the state of Minas Gerais 
MG <- read.delim('./data/MG_Delib_COPAM_367-2008.txt',
                 sep = '\t',
                 fileEncoding = 'latin1') |>
    mutate(scientificName = if_else(
        scientificName == "",
        stringr::word(Supplied.Name, 1, 2),
        scientificName
    )) |>
    mutate(statusSource = recode(statusSource,
                                 'Regionalmente Extinto' = 'Regionalmente Extinta')) |>
    mutate(source = 'MG') |>
    mutate(list = 'Lista Flora Ameaçada Minas Gerais') |>
    mutate(
        scientificName = recode(
            scientificName,
            '& Brederoo' = 'Micranthocereus auriazureus',
            '(Herreriaceae) Herreria' = 'Herreria interrupta'
        )
    ) |>
    mutate(statusSource = recode(statusSource, 'EX' = 'Extinta')) |>
    mutate(dispLegal = 'Deliberação COPAM 367/2008') |>
    select(family,
           scientificName,
           statusSource,
           status,
           source,
           list,
           dispLegal)


# Read the endangered species of the state of Rio Grande do Sul
RS <- read.delim('./data/RS_endangerdSpecies_Dec_51.109-2014.txt',
                 sep = '\t') |>
    rename(family = Familia,
           scientificName = nomeCientifico,
           status = Categoria) |>
    left_join(listStatus, by = 'status') |>
    distinct(scientificName, .keep_all = TRUE) |>
    mutate(source = 'RS') |>
    mutate(list = 'Lista Flora Ameaçada Rio Grande do Sul') |>
    mutate(dispLegal = 'Decreto Estadual 51/2014') |>
    select(family,
           scientificName,
           statusSource,
           status,
           source,
           list,
           dispLegal)


# Read the endangered species of the state of Para
PA <- read.delim(
    './data/PA_Res_endangeredSpecies_Res_COEMA_54-2007.txt',
    sep = '\t',
    encoding = 'UTF-8'
) |>
    rename(family = Familia, scientificName = NomeCientífico) |>
    mutate(
        statusSource = recode(
            statusSource,
            'Em perigo' = 'Em Perigo',
            'Criticamente em perigo' = 'Criticamente em Perigo'
        )
    ) |>
    left_join(listStatus, by = 'statusSource') |>
    mutate(source = 'PA') |>
    mutate(list = 'Lista Flora Ameaçada Pará') |>
    mutate(dispLegal = 'Resolução COEMA 54/2007') |>
    # current scientific name
    add_row(
        family = 'Bignoniaceae',
        scientificName = 'Handroanthus impetiginosus',
        statusSource = 'Vulnerável',
        status = 'VU',
        source = 'PA',
        list = 'Lista Flora Ameaçada Pará',
        dispLegal = 'Resolução COEMA 54/2007'
    ) |>
    # current scientific name
    add_row(
        family = 'Sapotaceae',
        scientificName = 'Manilkara elata',
        statusSource = 'Vulnerável',
        status = 'VU',
        source = 'PA',
        list = 'Lista Flora Ameaçada Pará',
        dispLegal = 'Resolução COEMA 54/2007'
    ) |>
    select(family,
           scientificName,
           statusSource,
           status,
           source,
           list,
           dispLegal)
        

# Read the endangered species of the state of Parana
PR <- read.delim(
    './data/PR_endangerdSpecies_Dec_PR_01-2010.txt',
    sep = '\t',
    fileEncoding = 'latin1'
) |>
    mutate(status = recode(status, 'V' = 'VU')) |>
    filter(sourceStatus != 'Dados Insuficientes') |>
    filter(sourceStatus != 'Não Avaliado') |>
    rename(statusSource = sourceStatus) |>
    mutate(statusSource = recode(statusSource,
                                 'Regionalmente Extinto' = 'Regionalmente Extinta')) |>
    mutate(source = 'PR') |>
    mutate(list = 'Lista Flora Ameaçada Paraná') |>
    mutate(dispLegal = 'Decreto Estadual 7264/2010') |>
    select(family,
           scientificName,
           statusSource,
           status,
           source,
           list,
           dispLegal)


# Read the endangered species of the state of Sao Paulo
SP <- read.csv(
    'data/SP_endangerdSpecies_Res_SMA_057-2016.csv',
    sep = ',',
    encoding = 'UTF-8'
) |>
    filter(statusSource != 'Dados Insuficientes', kingdom != 'Animalia') |>
    mutate(
        statusSource = recode(
            statusSource,
            'VU EX' = 'Vulnerável / Presumivelmente Extinta',
            'EW' = 'Extinta na Natureza',
            'Em perigo' = 'Em Perigo'
        )
    ) |>
    mutate(statusSource = recode(statusSource, 'EW' = 'Extinta na Natureza')) |>
    mutate(statusSource = recode(statusSource,
                                 'Quase Ameaçada' = 'Em Perigo')) |>
    mutate(status = recode(status, 'NT' = 'EN')) |>
    mutate(scientificName = if_else(
        scientificName == "",
        stringr::word(Supplied.Name, 1, 2),
        scientificName
    )) |>
    mutate(source = 'SP') |>
    mutate(list = 'Lista Flora Ameaçada São Paulo') |>
    mutate(dispLegal = 'Resolucao SMA 57/2016') |>
    select(family,
           scientificName,
           statusSource,
           status,
           source,
           list,
           dispLegal)


# Read the endangered species of the state of Espirito Santo
ES <- read.csv('data/ES_endangeredSpecies_Dec_1.499-R.csv',
               sep = ',',
               encoding = 'UTF-8') |>
    mutate(
        statusSource = recode(statusSource,
                              'CriticamEm Perigote em Perigo' =
                                  'Criticamente em Perigo')
    ) |>
    filter(status != 'DD') |>
    filter(kingdom == "") |>
    mutate(scientificName = if_else(
        scientificName == "",
        stringr::word(Supplied.Name, 1, 2),
        scientificName
    )) |>
    mutate(source = 'ES') |>
    mutate(list = 'Lista Flora Ameaçada Espirito Santo') |>
    mutate(dispLegal = 'Decreto Estadual 1499-R') |>
    select(family, scientificName, statusSource, list, source, dispLegal) |>
    left_join(listStatus, by = 'statusSource')

# Read the endangered species of the state of Bahia
BA <- read.csv(
    './data/BA_fauna_flora._Avaliacao_de_2017.csv',
    sep = ',',
    encoding = 'UTF-8'
) |>
    mutate(statusSource = recode(statusSource, 'En' = 'Em Perigo')) |>
    mutate(scientificName = if_else(
        scientificName == "",
        stringr::word(Supplied.Name, 1, 2),
        scientificName
    )) |>
    filter(kingdom != 'Animalia') |>
    mutate(source = 'BA') |>
    mutate(list = 'Lista Flora Ameaçada Bahia') |>
    mutate(dispLegal = 'Portaria SEMA-BA 40/2017') |>
    mutate(status = toupper(status)) |>
    select(family,
           scientificName,
           statusSource,
           status,
           source,
           list,
           dispLegal)

# Read the endangered species of the state of Santa Catarina
SC <- read.csv(
    './data/SC_Flora_Avaliacao_2014_Fauna_avaliacao_2011.csv',
    sep = ',',
    encoding = 'UTF-8'
) |>
    mutate(scientificName = if_else(
        scientificName == "",
        stringr::word(Supplied.Name, 1, 2),
        scientificName
    )) |>
    mutate(statusSource = recode(statusSource,
                                 'Criticamente em perigo' = 'Criticamente em Perigo')) |>
    mutate(statusSource = recode(statusSource, 'EW' = 'Extinta na Natureza')) |>
    mutate(statusSource = recode(statusSource, 'Extinto' = 'Extinta')) |>
    filter(kingdom != 'Animalia', statusSource != 'Dados Insuficientes') |>
    mutate(source = 'SC') |>
    mutate(list = 'Lista Flora Ameaçada Santa Catarina') |>
    mutate(dispLegal = 'Resolução CONSAMA 51/2014') |>
    select(family,
           scientificName,
           statusSource,
           status,
           source,
           list,
           dispLegal)


# Read the endangered species of the Portaria MMA 443/2014
# port443 <- read.csv('./data/port443.csv', sep = ';') |>
#     rename(status = threatStatus) |>
#     left_join(listStatus, by = 'status') |>
#     filter(status != 'NE') |>
#     mutate(source = 'Portaria 443') |>
#     mutate(list = 'Lista Portaria 443') |>
#     mutate(dispLegal = 'Portaria MMA 443/2014') |>
#     select(family, scientificName, statusSource, status, source, list, dispLegal) |>
#     mutate(family = R.utils::capitalize(tolower(family)))

# Portaria 148/2022 updated the Portaria MMA 443/2014
port148 <- read.csv2("./data/port148-2022.csv", fileEncoding = "latin1") |>
    rename(family = familia, scientificName = nome_cientifico) |>
    mutate(source = "Portaria 443",
           list = "Lista Portaria 443",
           dispLegal = "Portaria MMA 443/2014") |>
    left_join(listStatus, by = "status") |>
    select(family, scientificName, statusSource, status, source, list, dispLegal)


# CITES
cites <- read.csv('./data/cites_listings_2025-02-11-1929_semicolon_separated.csv') |>
    filter(Kingdom == "Plantae") |>
    rename(scientificName = FullName) |>
    rename(family = Family) |>
    mutate(CITES = paste0('Anexo ', CurrentListing)) |>
    select(scientificName, CITES)

#---> Merge the data sets
endangered_list <- rbind(PA, BA, ES, MG, PR, RS, SC, SP, port148) |>
    right_join(
        reflora[, c(2, 8, 9, 3)],
        by = 'scientificName',
        , multiple = "all"
    ) |>
    filter(!(scientificName %in% fauna$scientificName)) |> #Remove species of fauna
    tibble::rowid_to_column() |>
    left_join(cites, by = c('scientificName'), multiple = "all") |>
    filter(!is.na(scientificName)) |>
    left_join(
        cites, by = c('acceptedNameUsage' = 'scientificName'),
        multiple = "all",
        suffix = c('_acceptedName', '_synonymous')
    ) |>
    distinct(rowid, .keep_all = TRUE) |>
    mutate(CITES = ifelse(!is.na(CITES_acceptedName), CITES_acceptedName, NA)) |>
    mutate(CITES = ifelse(!is.na(CITES_synonymous), CITES_synonymous, CITES)) |>
    mutate(CITES = ifelse(is.na(CITES), 'Não', CITES)) |>
    # SISTAXON scientific name version
    add_row(
        family = 'Bignoniaceae',
        scientificName = 'Handroanthus impetiginosum',
        statusSource = 'Vulnerável',
        status = 'VU',
        source = 'PA',
        list = 'Lista Flora Ameaçada Pará',
        dispLegal = 'Resolução COEMA 54/2007',
        taxonomicStatus = NA,
        nomenclaturalStatus = NA,
        acceptedNameUsage = NA,
        CITES = 'Anexo II'
    ) |>
    rename(
        familia = family,
        nome_cientifico = scientificName,
        status_conservacao = statusSource,
        codStatus = status,
        fonte = source,
        lista = list,
        dispositivo_legal = dispLegal
    ) |>
    select(-c(rowid, CITES_acceptedName, CITES_synonymous))


#url <- 'http://www.ibama.gov.br/phocadownload/sinaflor/2022/2022-07-22_Lista_especies_DOF.csv'
#con <- read.csv(url, fileEncoding = 'latin1')
#sistaxon <- con
#rm(con)

# join_df <- endangered_list |>
#     inner_join(sistaxon[, c(2,4)] , by = c('nome_cientifico' = 'Nome.cientifico'), relationship = "many-to-many") |>
#     tidyr::replace_na(list(Nome.popular = "*")) |>
#     group_by(nome_cientifico) |>
#     summarize(Nome.popular = paste(unique(Nome.popular), collapse = ", "))

# endangered_list %<>%
#     left_join(join_df, by = "nome_cientifico") |>
#     group_by(nome_cientifico) |>
#     distinct(fonte, .keep_all = TRUE)

#---> Save the data set
write.csv2(
    endangered_list,
    './output/Especies_Ameacadas_BRA.csv',
    row.names = FALSE,
    fileEncoding = 'latin1'
)

#---> List Chart
species_source <- endangered_list |>
    group_by(fonte) |>
    filter(!is.na(fonte)) |>
    count(fonte, sort = TRUE)

species_source$fonte <- with(species_source, reorder(fonte, n))
        
bra <- ggplot(species_source, aes(x = fonte, y = n, fill = n)) +
    geom_col() +
    coord_flip() +
    theme(plot.title = element_text(hjust = 0.5, size = 14),
          legend.position = c(0.9, 0.5)) +
    labs(title = 'Espécies Ameaçadas de Extinção no Brasil',
         x = 'Fonte',
         y = 'Nº de espécies',
         fill = '')


#---> Species Chart by status
species_status <- endangered_list |>
    group_by(codStatus, status_conservacao) |>
    filter(!is.na(codStatus)) |>
    count(codStatus, sort = T)

# Reorder the data set by number of status 
species_status$codStatus <- with(species_status, reorder(codStatus, desc(n)))

# Set status code table 
statusCodeTable <- endangered_list |>
    group_by(codStatus, status_conservacao) |>
    filter(!is.na(codStatus)) |>
    summarise() |>
    rename(Status = codStatus, Descrição = status_conservacao)

# Theme to the table plot
table_theme <- gridExtra::ttheme_default(
    base_size = 10,
    base_colour = "black",
    base_family = "serif",
    parse = TRUE
)

# Ungroup the tibble before passing to tableGrob
statusCodeTable <- statusCodeTable %>% ungroup()

# Create table grob
table_grob <- gridExtra::tableGrob(statusCodeTable, theme = table_theme, rows = NULL)

#---> Set chart
sp_status <- ggplot(species_status, aes(x = codStatus, y = n)) +
    geom_col(fill = 'steelblue') +
    scale_fill_manual(name = 'Status',
                      values = c('EN = Em Perigo')) +
    theme(plot.title = element_text(hjust = 0.5, size = 14)) +
    annotation_custom(
        table_grob,
        xmin = 'RE',
        xmax = 'VU EX',
        ymin = 800,
        ymax = 2200
    ) +
    geom_text(aes(label = n, vjust = -0.8), color = 'red') +
    labs(title = 'Categorias de Espécies Ameaçadas de Extinção no Brasil',
         x = 'Status',
         y = 'Nº de espécies')



#ggplotly(sp_status)

#---> Family Chart
statusFamily <- endangered_list |>
    filter(familia != "") |>
    mutate(familia = stringr::str_to_title(familia)) |>
    count(familia, sort = TRUE) |>
    slice_max(n, n = 10)

statusFamily$familia <- with(statusFamily, reorder(familia, n))

f <- ggplot(statusFamily, aes(familia, n)) +
    geom_col(fill = 'steelblue') + coord_flip() +
    geom_text(aes(label = n, hjust = 2), color = 'white') +
    theme(plot.title = element_text(hjust = 0.5, size = 14)) +
    labs(title = '10 Famílias com Maior Número de Espécies Ameaçadas de Extinção no Brasil',
         x = 'Família',
         y = 'Nº de espécies')


#---> Species Table
DT::datatable(endangered_list)
