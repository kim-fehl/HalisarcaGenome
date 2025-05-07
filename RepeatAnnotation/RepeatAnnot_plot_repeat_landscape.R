pacman::p_load(
    dplyr, ggplot2, tibble, tidyr, readr
)

table_for_repeat_landscape <- read_table("SKOL_HDuj_2_larger3k.only_lower_numbers.divsum") %>%
    select(!all_of(c('X52', 'Simple_repeat')))

matrix_with_coverage <- table_for_repeat_landscape %>%
    column_to_rownames("Div") %>%
    as.matrix()

class(matrix_with_coverage) <- "numeric"

matrix_with_coverage_proportion <- matrix_with_coverage / 222720433

library("RColorBrewer")
colourCount = 49
ref <- colorRampPalette(brewer.pal(12, "Paired"))(colourCount)
palette1 <- rev(ref)

repeat_landscape_plot <- reshape2::melt(matrix_with_coverage_proportion) %>%
    filter(Var2 != 'rRNA',
          Var2 != 'Satellite') %>%
    ggplot(aes(x = Var1, y = value * 100, fill = Var2)) +
        geom_bar(stat="identity", position = position_stack(reverse = TRUE)) +
        ylab("Proportion of genome (%)") + xlab("Kimura substitution level") + theme_bw() +
        scale_fill_manual(name="Repeat Families", values = palette1) + xlim(0, 50) + ylim(0, 5)

#ggsave(
#    plot = repeat_landscape_plot,
#    filename = './SKOL_HDuj_2_larger3k.repeat_landscape_plot.png',
#    device = 'png', dpi = 300, width = 15, height = 5
#)


