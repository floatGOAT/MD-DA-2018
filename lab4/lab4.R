#Пользуясь примером из лекции файл (5.0.R) проанализируйте данные
#о возрасте и физ. характеристиках молюсков
#https://archive.ics.uci.edu/ml/datasets/abalone
data <- read.csv("https://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data", header=TRUE, sep=",")
summary(data)
colnames(data)
colnames(data) <- c("sex", "length", "diameter", "height", 
                "whole_weight", "shucked_weight",
                "viscera_weight", "shell_weight", "rings")

colnames(data)
data$sex <- factor(c("Female", "Infant", "Male")[data$sex])
par(mfrow=c(1,3)) 
hist(data$diameter, main = "Диаметр, мм")
hist(data$height, main = "Высота, мм")
hist(data$whole_weight, main = "Полный вес, гр")
#Видим ассиметрию https://en.wikipedia.org/wiki/Skewness
#и выбросы (от них нужно избавиться)

#Ещё раз посмотрим на выбросы
boxplot(data$diameter, main = "Диаметр, мм")
boxplot(data$height, main = "Высота, мм")
boxplot(data$whole_weight, main = "Полный вес, гр")

#"Почистим" данные
data.norm <- data %>%
  filter(diameter > 0.1, height < 0.3, height > 0.02, whole_weight < 2.5)

#Так-то лучше
boxplot(data.norm$diameter, main = "Диаметр, мм")
boxplot(data.norm$height, main = "Высота, мм")
boxplot(data.norm$whole_weight, main = "Полный вес, гр")

#Визулизируем возможные зависимости
par(mfrow=c(1,2)) 
plot(data.norm$diameter, data.norm$whole_weight,'p',main = "Зависимость веса от диаметра")
plot(data.norm$height, data.norm$whole_weight,'p',main = "Зависимость веса от высоты")

#Хорошо видна зависимость, нужно её исследовать
#построить линейные модели при помощи функции lm, посмотреть их характеристики
par(mfrow=c(1,1))

lm.diam.ww <- data.norm %>% 
  lm(whole_weight ~ diameter, data = .)
plot(lm.diam.ww)
summary(lm.diam.ww)

lm.height.ww <- data.norm %>% 
  lm(whole_weight ~ height, data = .)
plot(lm.height.ww)
summary(lm.height.ww)

#избавиться от выборосов, построить ещё модели и проверить их
lm.sex.diam <- data.norm %>% 
  lm(diameter ~ sex, data = .)
plot(lm.sex.diam)
summary(lm.sex.diam)

lm.sex.len <- data.norm %>% 
  lm(length ~ sex, data = .)
plot(lm.sex.len)
summary(lm.sex.len)

#разделить массив данных на 2 случайные части
odd.rows <- slice(data, seq(1, nrow(data.norm), by = 2))
even.rows <-  slice(data, seq(2, nrow(data.norm), by = 2))

#подогнать модель по первой части
odd.lm.diam.ww <- odd.rows %>% 
  lm(whole_weight ~ diameter, data = .)

odd.lm.height.ww <- odd.rows %>% 
  lm(whole_weight ~ height, data = .)

odd.lm.sex.diam <- odd.rows %>% 
  lm(diameter ~ sex, data = .)

odd.lm.sex.len <- odd.rows %>% 
  lm(length ~ sex, data = .)

#спрогнозировать (функция predict) значения во второй части
predicted.ww.d <- predict(odd.lm.diam.ww, even.rows)
cor(predicted.ww.d, even.rows$whole_weight)
plot(predicted.ww.d, even.rows$whole_weight)

predicted.ww.h <- predict(odd.lm.height.ww, even.rows)
cor(predicted.ww.h, even.rows$whole_weight)
plot(predicted.ww.h, even.rows$whole_weight)

predicted.sex.d <- predict(odd.lm.sex.diam, even.rows)
cor(predicted.sex.d, even.rows$diam)
plot(predicted.sex.d, even.rows$diam)

predicted.sex.l <- predict(odd.lm.sex.len, even.rows)
plot(predicted.sex.l, even.rows$length)

#проверить качесвто прогноза


remove_outliers <- function(x, na.rm = TRUE, ...) {
  qnt <- quantile(x, probs=c(.25, .75), na.rm = na.rm, ...)
  H <- 1.5 * IQR(x, na.rm = na.rm)
  y <- x
  y[x < (qnt[1] - H)] <- NA
  y[x > (qnt[2] + H)] <- NA
  y
}
