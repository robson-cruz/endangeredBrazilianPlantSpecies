library(dplyr)


data <- read.delim("./Portaria_MMA_148-2022_altera_443-2014.txt", header = FALSE)
names(data) <- "nm"

df <- data |>
    filter(grepl("[^0-9]", nm)) |>
    tibble::rowid_to_column() |>
    mutate(flag = ifelse(grepl("\\*", nm), nm, NA)) |>
    mutate(nome_cientifico = ifelse(grepl("[^0-9]", nm) & !grepl("[A-Z]{2}", nm) & nm != "*" & !grepl("aceae$", nm), nm, NA)) |>
    mutate(familia = ifelse(grepl("aceae$", nm), nm, NA)) |>
    mutate(status = ifelse(grepl("[A-Z]{2}", nm), nm, NA))


port148 <- data.frame(
    nome_cientifico = df[!is.na(df$nome_cientifico), 4],
    familia = df[!is.na(df$familia), 5],
    status = df[!is.na(df$status), 6]
)

write.csv2(port148, "./port148.csv", row.names = FALSE, fileEncoding = "latin1")
