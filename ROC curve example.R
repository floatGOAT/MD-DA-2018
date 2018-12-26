install.packages("ggplot2")
install.packages("plotROC")
library(tidyverse)
library(ggplot2)
library(plotROC)

set.seed(2529)
D.ex <- rbinom(200, size = 1, prob = .5)
M1 <- rnorm(200, mean = D.ex, sd = .5)
M2 <- rnorm(200, mean = D.ex, sd = 1.5)
M3 <- rnorm(200, mean = D.ex, sd = 3.1)

df <- data.frame(D = D.ex,
D.str = c("Healthy", "Ill")[D.ex + 1],
           M1 = M1,
           M2 = M2,
           M3 = M3,
           stringsAsFactors = FALSE)

plot <- ggplot(
melt_roc(df, "D", c("M1", "M2", "M3")),
      aes(d = D, m = M, color = name)) + 
      geom_roc(n.cuts = 0)

calc_auc(plot)$AUC

plot + 
  annotate("text", x = .75, y = .25,
       label = paste("AUC1 =", aucs[1], "\nAUC2 =", aucs[2], "\nAUC3 =", aucs[3])) +
       style_roc()
