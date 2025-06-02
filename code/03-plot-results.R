# note: attempting to fill in curves results in weird effects

# packages
pacman::p_load(tidyverse, #general data handling
               ggplot2, #plotting
               ggpubr, #ggarange
               grid)

here::i_am("code/03-plot-results.R")

# function to calculate standard deviation from CI limits
calculate_sd <- function(lower, upper) {
  z <- 1.96
  (upper - lower) / (2 * z)
}

# policymaker A prior, policy increases prenatal care (protective)

# define parameters for multiple distributions
params <- data.frame(
  mean_rd = c(-5, 5, 0),    # means of the risk difference
  lower_ci = c(-7, 3, -1.414214),  # lower CI limits
  upper_ci = c(-3, 7, 1.414214)   # upper CI limits
)

# generate data for each parameter set
data_a <- do.call(rbind, lapply(1:nrow(params), function(i) {
  mean_rd <- params$mean_rd[i]
  sd_rd <- calculate_sd(params$lower_ci[i], params$upper_ci[i])
  
  x_values <- seq(-20, 10, length.out = 100)
  y_values <- dnorm(x_values, mean = mean_rd, sd = sd_rd)
  
  data.frame(risk_difference = x_values, density = y_values, curve_id = paste("Curve", i))
}))

# policymaker B prior, policy decreases prenatal care (harmful)

# define parameters for multiple distributions
params <- data.frame(
  mean_rd = c(-5, -6.2, -5.749707),    # means of the risk difference
  lower_ci = c(-7, -7.75, -6.97485),   # lower CI limits
  upper_ci = c(-3, -4.65, -4.524564)   # upper CI limits
)

# generate data for each parameter set
data_b <- do.call(rbind, lapply(1:nrow(params), function(i) {
  mean_rd <- params$mean_rd[i]
  sd_rd <- calculate_sd(params$lower_ci[i], params$upper_ci[i])
  x_values <- seq(-20, 10, length.out = 100)
  y_values <- dnorm(x_values, mean = mean_rd, sd = sd_rd)
  
  data.frame(risk_difference = x_values, density = y_values, curve_id = paste("Curve", i))
}))


# policymaker C prior, policy has no effect (null)

params <- data.frame(
  mean_rd = c(-5, 0, -1),    # means of the risk difference (study, prior, posterior)
  lower_ci = c(-7, -1, -1.894427),  # lower CI limits
  upper_ci = c(-3, 1, -0.1055728)   # upper CI limits
)

# generate data for each parameter set
data_c <- do.call(rbind, lapply(1:nrow(params), function(i) {
  mean_rd <- params$mean_rd[i]
  sd_rd <- calculate_sd(params$lower_ci[i], params$upper_ci[i])
  
  x_values <- seq(-20, 10, length.out = 100)
  y_values <- dnorm(x_values, mean = mean_rd, sd = sd_rd)
  
  data.frame(risk_difference = x_values, density = y_values, curve_id = paste("Curve", i))
}))

# policymaker D prior, policy could have a large chilling effect (harmful, large variance)

# define parameters for multiple distributions
params <- data.frame(
  mean_rd = c(-5, -11.5, -5.340984),    # means of the risk difference
  lower_ci = c(-7, -20, -7.287818),  # lower CI limits
  upper_ci = c(-3, -3, -3.394149)   # upper CI limits
)

# generate data for each parameter set
data_d<- do.call(rbind, lapply(1:nrow(params), function(i) {
  mean_rd <- params$mean_rd[i]
  sd_rd <- calculate_sd(params$lower_ci[i], params$upper_ci[i])
  
  x_values <- seq(-20, 10, length.out = 100)
  y_values <- dnorm(x_values, mean = mean_rd, sd = sd_rd)
  
  data.frame(risk_difference = x_values, density = y_values, curve_id = paste("Curve", i))
}))

#policymaker A plot 

curve_colors <- c("#969696",
                  "#d94801",
                  "#fdae6b")

curve_labels <- c("Study data",
                  "Policymaker prior",
                  "Posterior")

curve_linetypes <- c("solid",
                     "solid",
                     "solid")

plot_a <- ggplot(data_a, aes(x = risk_difference, y = density, color = curve_id, linetype = curve_id)) +
  geom_line(linewidth = 1) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "black", linewidth = 0.6) +
  labs(x = "Prior: policy is protective",
       y = "Density") +
  theme_classic() +
  scale_color_manual(values = curve_colors, labels = curve_labels) + 
  scale_y_continuous(limits = c(0, 0.9)) +
  scale_linetype_manual(values = curve_linetypes, labels = curve_labels) + 
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 12),
        axis.text.y = element_blank(),
        axis.text.x = element_text(size = 10),
        axis.ticks.y = element_blank(), 
        axis.title = element_text(size = 12),
        axis.title.y = element_blank(),
        axis.title.x = element_text(hjust = 0.5, size = 12))

#policymaker B plot

curve_colors <- c("#969696",
                  "#d94801",
                  "#fdae6b")

curve_labels <- c("Study data",
                  "Policymaker B prior",
                  "Posterior")

curve_linetypes <- c("solid",
                     "solid",
                     "solid")

plot_b <- ggplot(data_b, aes(x = risk_difference, y = density, color = curve_id, linetype = curve_id)) +
  geom_line(linewidth = 1) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "black", linewidth = 0.6) +
  labs(x = "Prior: policy is harmful") +
  theme_classic() +
  scale_color_manual(values = curve_colors, labels = curve_labels) + 
  scale_y_continuous(limits = c(0, 0.9)) +
  scale_linetype_manual(values = curve_linetypes, labels = curve_labels) + 
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 12),
        axis.text.y = element_blank(),
        axis.text.x = element_text(size = 10),
        axis.ticks.y = element_blank(), 
        axis.title = element_text(size = 12),
        axis.title.y = element_blank(),
        axis.title.x = element_text(hjust = 0.5, size = 12))

#policymaker C plot

curve_colors <- c("#969696",
                  "#d94801",
                  "#fdae6b")

curve_labels <- c("Study data, identical in all scenarios",
                  "Policymaker C prior",
                  "Posterior")

curve_linetypes <- c("solid",
                     "solid",
                     "solid")

plot_c <- ggplot(data_c, aes(x = risk_difference, y = density, color = curve_id, linetype = curve_id)) +
  geom_line(linewidth = 1) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "black", linewidth = 0.6) +
  labs(x = "Prior: policy has no effect",
       y = "Density") +
  
  theme_classic() +
  scale_color_manual(values = curve_colors, labels = curve_labels) + 
  scale_linetype_manual(values = curve_linetypes, labels = curve_labels) + 
  scale_y_continuous(limits = c(0, 0.9)) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 12),
        axis.text.y = element_blank(),
        axis.text.x = element_text(size = 10),
        axis.ticks.y = element_blank(), 
        axis.title = element_text(size = 12),
        axis.title.y = element_blank(),
        axis.title.x = element_text(hjust = 0.5, size = 12))

#policymaker D plot 

curve_colors <- c("#969696",
                  "#d94801",
                  "#fdae6b")

curve_labels <- c("Study data",
                  "Policymaker D prior",
                  "Posterior")

curve_linetypes <- c("solid",
                     "solid",
                     "solid")

plot_d <- ggplot(data_d, aes(x = risk_difference, y = density, color = curve_id, linetype = curve_id)) +
  geom_line(linewidth = 1) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "black", linewidth = 0.6) +
  labs(x = "Prior: policy is harmful, unsure of magnitude",
       y = "Density") +
  theme_classic() +
  scale_color_manual(values = curve_colors, labels = curve_labels) + 
  scale_y_continuous(limits = c(0, 0.9)) +
  scale_linetype_manual(values = curve_linetypes, labels = curve_labels) + 
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 12),
        axis.text.y = element_blank(),
        axis.text.x = element_text(size = 10),
        axis.ticks.y = element_blank(), 
        axis.title = element_text(size = 12),
        axis.title.y = element_blank(),
        axis.title.x = element_text(hjust = 0.5, size = 12))

#arrange ggplot

# add titles to each individual plot (A, B, C, D)
plot_a <- plot_a + ggtitle("Policymaker A")
plot_b <- plot_b + ggtitle("Policymaker B")
plot_c <- plot_c + ggtitle("Policymaker C")
plot_d <- plot_d + ggtitle("Policymaker D")

# Arrange the plots in a grid with 2 columns and 2 rows
plot_list <- list(plot_a, plot_b, plot_c, plot_d)

plot <- ggarrange(
  plotlist = plot_list,
  ncol = 2,
  nrow = 2,
  labels = NULL, # Remove the default label for each plot
  hjust = -0.5,
  vjust = 1.5,
  font.label = list(size = 13, color = "black", face = "bold"),
  widths = 1,
  heights = 1,
  legend = NULL,
  common.legend = TRUE,
  legend.grob = NULL
)

# Optionally add a figure title
final_plot <- annotate_figure(
  plot,
  top = text_grob("Policymaker posterior distributions, effect of policy on any prenatal care",
                  color = "black", size = 13)
)

final_plot

# save plots

ggsave("figures/final_plot.png",
       plot = final_plot,
       device = "png",
       scale = 1,
       width = 8,
       height = 6
)
