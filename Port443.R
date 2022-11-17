## Load libraries
library(finch)
library(dplyr)

## Set the website of the Brazilian endangered species list
url <- 'http://ipt.jbrj.gov.br/jbrj/archive.do?r=lista_oficial_ameacadas_portaria_443&v=2.12'

## Convert the URL to a location object
as.location(url)

## Show the numbers and name of datasets        
out <- dwca_read(url)

## Show files datasets
dwca_cache$list()

## Read a specif dataset
port443 <- read.delim2(
        'C:\\Users\\671470~1\\AppData\\Local/Cache/R/finch/f16a8c36d81df24225745220dcdc604156ac0ac6/taxon.txt',
        header = TRUE, encoding = 'UTF-8', sep = '\t'
)
head(port443)

## get status code
code <- read.delim2(
        'C:\\Users\\671470~1\\AppData\\Local/Cache/R/finch/f16a8c36d81df24225745220dcdc604156ac0ac6/distribution.txt',
        header = TRUE, encoding = 'UTF-8', sep = '\t'
)
head(code)

## join tables
port443 <- port443 %>%
        left_join(code, by = 'id')

head(port443)

## Save the list of endangered species
write.csv2(
        port443,
        './data/port443.csv', 
        row.names = FALSE
)

## Delete the database files from local disk
dwca_cache$delete_all()
