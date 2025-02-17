# Install and load required packages
if (!require("ARTool")) install.packages("ARTool")
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("emmeans")) install.packages("emmeans")
if (!require("readxl")) install.packages("readxl")

library(ARTool)
library(tidyverse)
library(emmeans)
library(readxl)

# Read the data
# You can use either read.csv or read_excel depending on your file format
data <- read.csv("D:\주성\documents\2025\Mg comma\data2.csv")  # If CSV file
# data <- read_excel("power_data.xlsx")  # If Excel file

# Check data structure
str(data)
head(data)

# Reshape data to long format
long_data <- data %>%
  pivot_longer(
    cols = c(pre_infusion, mean_post_infusion),
    names_to = "time",
    values_to = "power"
  ) %>%
  mutate(
    time = factor(time, 
                 levels = c("pre_infusion", "mean_post_infusion"),
                 labels = c("Pre", "Post")),
    band = factor(band),
    name = factor(name)
  )

# Perform ART ANOVA
m <- art(
  power ~ time * band + (1|name),
  data = long_data
)

# Print ANOVA results
cat("\nART ANOVA Results:\n")
anova_results <- anova(m)
print(anova_results)

# Perform aligned ranks post-hoc tests
cat("\nPost-hoc analysis for time effect:\n")
time_posthoc <- art.con(m, "time", adjust = "bonferroni")
print(time_posthoc)

cat("\nPost-hoc analysis for band effect:\n")
band_posthoc <- art.con(m, "band", adjust = "bonferroni")
print(band_posthoc)

cat("\nPost-hoc analysis for interaction:\n")
interaction_posthoc <- art.con(m, "time:band", adjust = "bonferroni")
print(interaction_posthoc)

# Calculate descriptive statistics
desc_stats <- long_data %>%
  group_by(time, band) %>%
  summarise(
    n = n(),
    mean = mean(power),
    sd = sd(power),
    median = median(power),
    q25 = quantile(power, 0.25),
    q75 = quantile(power, 0.75),
    .groups = "drop"
  )

cat("\nDescriptive Statistics:\n")
print(desc_stats)

# Create visualization
p <- ggplot(long_data, aes(x = band, y = power, fill = time)) +
  geom_boxplot() +
  theme_minimal() +
  labs(
    title = "Power distribution by Frequency Band and Time",
    x = "Frequency Band",
    y = "Power",
    fill = "Time Point"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(hjust = 0.5)
  )

# Save plot
ggsave("power_distribution.png", p, width = 10, height = 6, dpi = 300)

# Save results to a text file
sink("art_anova_results.txt")
cat("ART ANOVA Results\n\n")
print(anova_results)
cat("\nPost-hoc Tests\n")
cat("\nTime Effect:\n")
print(time_posthoc)
cat("\nBand Effect:\n")
print(band_posthoc)
cat("\nInteraction Effect:\n")
print(interaction_posthoc)
cat("\nDescriptive Statistics:\n")
print(desc_stats)
sink()