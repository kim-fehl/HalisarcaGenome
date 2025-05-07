library(tidyverse)

parse_line <- function(line_content) {
  if (!str_detect(line_content, "\\d+\\.\\d+ %$")) return(NULL)
  
  tokens <- str_split(line_content, "\\s+")[[1]]
  if (length(tokens) < 5) return(NULL)
  
  count_index <- which(str_detect(tokens, "^\\d+$"))[1]
  if (is.na(count_index)) return(NULL)
  
  name <- paste(tokens[1:(count_index - 1)], collapse = " ")
  name <- str_replace(name, ":$", "")
  count <- as.integer(tokens[count_index])
  bp <- as.integer(tokens[count_index + 1])
  percentage <- as.numeric(sub("%", "", tokens[count_index + 3]))
  
  list(name = name, count = count, bp = bp, percentage = percentage)
}

lines <- readLines("./SKOL_Hduj_refined_tbl_file.txt", n = 39)

entries <- list()
current_entry <- NULL
stack <- list(list(indent = -1, path = character(0)))

for (line in lines) {
  if (str_trim(line) == "") next
  
  leading_spaces <- str_count(line, "^ *")
  line_content <- str_trim(line)
  
  parsed <- parse_line(line_content)
  
  if (!is.null(parsed)) {
    if (!is.null(current_entry)) {
      entries <- c(entries, list(current_entry))
    }
    
    current_indent <- leading_spaces
    
    while (length(stack) > 0 && stack[[length(stack)]]$indent >= current_indent) {
      stack <- stack[-length(stack)]
    }
    
    parent_path <- if (length(stack) > 0) stack[[length(stack)]]$path else character(0)
    new_path <- c(parent_path, parsed$name)
    
    current_entry <- list(
      path = new_path,
      count = parsed$count,
      bp = parsed$bp,
      percentage = parsed$percentage
    )
    
    stack <- c(stack, list(list(indent = current_indent, path = new_path)))
    
  } else {
    if (!is.null(current_entry)) {
      new_name <- paste(current_entry$path[length(current_entry$path)], line_content)
      current_entry$path[length(current_entry$path)] <- new_name
      stack[[length(stack)]]$path[length(stack[[length(stack)]]$path)] <- new_name
    }
  }
}

if (!is.null(current_entry)) {
  entries <- c(entries, list(current_entry))
}

max_depth <- max(sapply(entries, function(e) length(e$path)))
df_list <- lapply(entries, function(e) {
  path <- e$path
  padded_path <- c(path, rep(NA, max_depth - length(path)))
  names(padded_path) <- paste0("Level", seq_len(max_depth))
  data.frame(
    as.list(padded_path),
    Count = e$count,
    BP = e$bp,
    Percentage = e$percentage,
    stringsAsFactors = FALSE
  )
})

df <- do.call(rbind, df_list)

print(df, row.names = FALSE)

repeat_family <- c(
  "SINEs",
  rep("LINEs", 5),
  rep("LTRs", 4),
  rep("DNA transposons", 7),
  "Rolling-circles",
  "Unclassified",
  "Small RNA",
  rep("Non-Redundant", 3)
)

df <- df[-c(1, 3, 4, 5, 11, 16, 26),]
df$Repeat_family <- repeat_family
df <- df %>% 
  relocate(Repeat_family, .before = 1) %>% 
  mutate(
    Repeat_family = fct_reorder(factor(Repeat_family), BP),
    Level1 = factor(Level1)
  )

library(paletteer)

df[,-2] %>%
  group_by(Repeat_family) %>%
  summarise(BP_sum = sum(BP)) %>%
  ungroup() -> df_2

ggplot(
  df_2, 
  aes(
    x = fct_relevel(Repeat_family, c("SINEs", 
                                     "LINEs", 
                                     "LTRs", 
                                     "DNA transposons", 
                                     "Rolling-circles", 
                                     "Small RNA", 
                                     "Non-Redundant", "Unclassified")),
    y = BP_sum / 222720433 * 100, fill =  Repeat_family
  )
) + 
  geom_bar(position="stack", stat="identity", width = 0.7, 
           linewidth = 0.85, 
           color = 'black') + 
  scale_fill_paletteer_d("PrettyCols::Autumn") +
  theme_bw() + 
  theme(
    panel.grid.minor = element_blank(),
    legend.position = "none",
    # panel.grid = element_blank(),
    axis.text.x = element_text(angle = 50, vjust = 1, hjust = 1, size = 14),
    axis.title.y  = element_text(size = 16),
    axis.text.y = element_text(size = 16)
  ) + xlab("") + ylab("Proportion from a genome (%)") + 
  coord_fixed(ratio = 1/2.25)

# ggsave(
#   file = './repeat_composition_in_the_genome.png',
#   device = 'png',
#   dpi = 300,
#   width = 7,
#   height= 7
# )

