# Load libraries
library(finch)
library(dplyr)
library(stringr)


# setting the httr package's config option to use the openssl SSL library
httr::set_config(httr::config(ssl_verifypeer = 0L, ssl_lib = "openssl"))

# Set the website of REFLORA data base
url <- "https://ipt.jbrj.gov.br/jbrj/archive.do?r=lista_especies_flora_brasil&v=393.400"

# Convert the URL to a location object
as.location(url)

# Get the numbers and name of data sets      
out <- dwca_read(url)

# Show file data sets
dw_cache <- dwca_cache$list()

# Read the "taxon" data set
taxon <- read.delim2(paste0(dw_cache[8]), sep = "\t", encoding = "UTF-8") %>%
    filter(kingdom == "Plantae") %>%
    filter(taxonRank == "ESPECIE") %>%
    # create a new column called "specie" by combining the "genus" and
    # "specificEpithet" columns with a space separator.
    mutate(specie = paste(genus, specificEpithet, sep = " ")) %>%
    select(c(1, 27, 6, 7, 16:19, 22, 23)) %>%
    mutate(
        # Use regular expression to extract only genus and specific
        # epithet and subspecies from acceptedNameUsage column
        acceptedNameUsage = str_extract(
            acceptedNameUsage,
            "(\\w+\\s\\w+)(-\\w+)?(\\s\\w+\\ssubsp.\\s\\w+)?(\\ssubsp.\\s\\w+)?(\\svar.\\s\\w+)?(\\.\\s\\w+)?"
        )
    )

# Read "distribution" data set (geographic distribution) 
dist <- read.delim(
    paste0(dw_cache[2]),
    header = TRUE,
    encoding = "UTF-8",
    sep = "\t"
) %>%
    # Extracts the last two letters from location code
    mutate(locationID = substring(locationID , 4))

# Merge data sets based on the "id" column
# reflora <- taxon %>%
#     left_join(dist, by = "id")

# Save merged data sets as a CSV file
write.csv2(
    taxon,
    paste0("data/reflora_v", sub("\\.", "_", sub("[^0-9]+", "\\1", url)), ".csv"),
    row.names = FALSE,
    fileEncoding = "UTF-8"
)

write.csv2(
    dist,
    paste0("data/reflora_distribuicao_v", sub("\\.", "_", sub("[^0-9]+", "\\1", url)), ".csv"),
    row.names = FALSE,
    fileEncoding = "latin1"
)

# Delete the database files from local disk
dwca_cache$delete_all()

# Remove the "dw_cache" object from the environment
rm(dw_cache)
