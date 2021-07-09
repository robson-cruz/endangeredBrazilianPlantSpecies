## Load libraries
library(finch)
library(dplyr)

## Set the website of REFLORA data base
url <- 'http://ipt.jbrj.gov.br/jbrj/archive.do?r=lista_especies_flora_brasil&v=393.291'

## Convert the URL to a location object
as.location(url)

## Show the numbers and name of datasets        
out <- dwca_read(url)

## Show files datasets
dwca_cache$list()

## Read a specif dataset
reflora <- read.delim2(
        'C:\\Users\\rcflo\\AppData\\Local/Cache/R/finch/0c08eda77c90f20e7c5012a45749bebd8b3de914/taxon.txt',
        header = TRUE, encoding = 'UTF-8', sep = '\t'
) %>%
filter(kingdom == 'Plantae') %>% 
        filter(taxonRank == 'ESPECIE') %>%
        mutate(specie = paste(genus, specificEpithet, sep = ' ')) %>%
        select(c(1, 27, 6, 7, 16:19, 22, 23)) %>%
        mutate(acceptedNameUsage = stringr::word(acceptedNameUsage, 1,2))

head(reflora)
tail(reflora)


dist <- read.delim(
        'C:\\Users\\rcflo\\AppData\\Local/Cache/R/finch/0c08eda77c90f20e7c5012a45749bebd8b3de914/distribution.txt',
        header = TRUE, encoding = 'UTF-8', sep = '\t'
) %>%
        select(id, locationID) %>%
        # Extracts the last two letters from location code
        mutate(locationID = substring(locationID , 4))

head(dist)

## Merge data sets
reflora <- reflora %>%
        left_join(dist, by = 'id')

## Save dataset in .csv file format
write.csv2(reflora, 'D:/Robson/data/jbrio/reflora20210706.csv', row.names = FALSE)

## Delete the database files from local disk
dwca_cache$delete_all()

