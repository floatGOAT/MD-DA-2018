# enable rmardown
library(rmarkdown)

# constants
lambda <- as.integer(5)
sampleLength <- as.integer(200)

# task 1
exp.1 <- rexp(sampleLength)
mean <- mean(exp.1)
standartDev <-  sd(exp.1)

# task 2
exp.0.1 <- rexp(sampleLength, rate = 0.1)
exp.0.5 <- rexp(sampleLength, rate = 0.5)
exp.5 <- rexp(sampleLength, rate = 5)
exp.10 <- rexp(sampleLength, rate = 10)

# task 3
samples <- list(exp.1, exp.0.1, exp.0.5, exp.5, exp.10, dim = 200)
sds <- vector(length = 5)
for (i in 1:5) {
  sds[i] <- mean(samples[[i]])
}
hist(sds)
