---
output:
  pdf_document: default
  html_document: default
---
# Wrangle

## Import -> Tidy -> transform

Use unix tools to create data

- Pipe in unix means output of command on left is the input to command on right
- tsv better than csv since the data itself may contain commas.

```zsh
uniq -c
sort -nr
```

### Converting csv to tsv

```zsh
grep "ctrl-v<tab>" data.csv
perl -pe 's/,/ctrl-v<tab>/g' < data.csv > data.tsv
```

$$\vec a$$

- < - input
- > - output

- -p print every line
- -e the next command is a perl program

CSV Kit - to handle common irregularities.

csv is not a good format but used most frequently and hence a common problem in
data science.

## readr functions (parsers)

## write

- write_csv()
- write_tsv()

But the encoding information is lost, so use
library(feather) to save intermediate R data which can then be used across
different programming languages.

- write_feather()
- read_feather()

## For Other data types

- heaven - SPSS, Stata, SAS
- readxl - Excel
- DBI
- jsonlite for JSON
- xml2 for XML
- R data import / export manual
- leeper/rio


