library(dplyr)
library(tidyr)
library(tibble)

trembl_res <- read.table('./gene_annotations/trembl.res.m8', sep = '\t')
tembl_final_res <- trembl_res %>%
    group_by(V1) %>%
    slice_min(V11) %>%
    ungroup() %>%
    distinct(V1, .keep_all = T) %>%
    select(V1, V2, V11) %>%
    rename(query = V1,
           target = V2,
           e_value = V11)

write.table(
    x = tembl_final_res, 
    file = './gene_annotations/tremble.m8.final.txt', 
    quote = F, 
    sep = '\t', 
    row.names = F
    )