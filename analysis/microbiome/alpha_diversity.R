# =============================================================================
# alpha_diversity.R
# Gastric microbiome sub-analysis — Shannon alpha diversity by group
# Author: K. Dauyey  (QIIME 2 steps: A. collaborator)
# Standalone; run from the repository root.
#
# INPUT : data/raw/alpha-diversity.tsv       (QIIME 2 export, see below)
#         data/raw/microbiome_metadata.tsv   (SampleID + Grp)
# OUTPUT: results/figures/Fig_AlphaDiversity_Shannon.tiff
#
# ---------------------------------------------------------------------------
# Upstream QIIME 2 (run separately; feature table not tracked here):
#
#   qiime diversity alpha \
#     --i-table feature-table.qza \
#     --p-metric shannon \
#     --o-alpha-diversity shannon.qza
#
#   qiime tools export \
#     --input-path shannon.qza \
#     --output-path exported-shannon
#   # -> exported-shannon/alpha-diversity.tsv
# ---------------------------------------------------------------------------
# =============================================================================

rm(list = ls())

library(here)
library(readr)
library(dplyr)
library(ggplot2)

alpha_path <- here("data", "raw", "alpha-diversity.tsv")
meta_path  <- here("data", "raw", "microbiome_metadata.tsv")
for (p in c(alpha_path, meta_path)) {
  if (!file.exists(p)) stop("Missing input: ", p, "\nSee data/README.md.")
}

alpha_div <- read_tsv(alpha_path, show_col_types = FALSE)
colnames(alpha_div)[1] <- "SampleID"

metadata <- read_tsv(meta_path, show_col_types = FALSE)

alpha_meta <- alpha_div %>%
  left_join(metadata, by = "SampleID") %>%
  mutate(Group = factor(Grp))

# --- Non-parametric group comparison --------------------------------------
if (nlevels(alpha_meta$Group) == 2) {
  print(wilcox.test(shannon_entropy ~ Group, data = alpha_meta))
} else {
  print(kruskal.test(shannon_entropy ~ Group, data = alpha_meta))
}

# --- Figure ---------------------------------------------------------------
p <- ggplot(alpha_meta, aes(x = Group, y = shannon_entropy, fill = Group)) +
  geom_boxplot(outlier.shape = NA, linewidth = 0.8) +
  geom_jitter(width = 0.2, size = 2, alpha = 0.6) +
  labs(title = "Shannon diversity index", x = "Group", y = "Shannon index") +
  theme_classic(base_size = 14) +
  theme(
    axis.line  = element_line(linewidth = 0.8),
    axis.ticks = element_line(linewidth = 0.8),
    axis.ticks.length = unit(2, "mm"),
    axis.text  = element_text(size = 14, colour = "black"),
    axis.title = element_text(size = 16, face = "bold"),
    legend.position = "none"
  )

out_fig <- here("results", "figures")
dir.create(out_fig, recursive = TRUE, showWarnings = FALSE)
ggsave(file.path(out_fig, "Fig_AlphaDiversity_Shannon.tiff"),
       p, dpi = 300, width = 7, height = 5, units = "in")
message("Wrote ", file.path(out_fig, "Fig_AlphaDiversity_Shannon.tiff"))
