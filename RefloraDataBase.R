## Load libraries
library(finch)
library(dplyr)
library(stringr)


## Set the website of REFLORA data base
url <- 'https://ipt.jbrj.gov.br/jbrj/archive.do?r=lista_especies_flora_brasil&v=393.368'

## Convert the URL to a location object
as.location(url)

## Show the numbers and name of datasets        
out <- dwca_read(url)

## Show file data sets
dw_cache <- dwca_cache$list()

## Read a specif data set
reflora <- read.delim2(
        paste0(dw_cache[8]),
        sep = '\t',
        encoding = 'UTF-8'
) %>%
filter(kingdom == 'Plantae') %>% 
        filter(taxonRank == 'ESPECIE') %>%
        mutate(specie = paste(genus, specificEpithet, sep = ' ')) %>%
        select(c(1, 27, 6, 7, 16:19, 22, 23)) %>%
        mutate(
                acceptedNameUsage = str_extract(
                        acceptedNameUsage, 
                        '(\\w+\\s\\w+)(-\\w+)?(\\s\\w+\\ssubsp.\\s\\w+)?(\\ssubsp.\\s\\w+)?(\\svar.\\s\\w+)?(\\.\\s\\w+)?'
                )
        )


dist <- read.delim(
        paste0(dw_cache[2]),
        header = TRUE, encoding = 'UTF-8', sep = '\t'
) %>%
        select(id, locationID) %>%
        # Extracts the last two letters from location code
        mutate(locationID = substring(locationID , 4))

## Merge data sets
reflora <- reflora %>%
        left_join(dist, by = 'id')

## Save data set in .csv file format
write.csv2(reflora, './data/reflora20230324.csv', row.names = FALSE)

## Delete the database files from local disk
dwca_cache$delete_all()
rm(dw_cache)
