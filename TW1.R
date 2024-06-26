install.packages("mlbench")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("reshape2")
install.packages("caret")

library(mlbench)
library(dplyr)
library(ggplot2)
library(reshape2)
library("caret")

data("BostonHousing")
housing <- BostonHousing
View(housing)
str(housing)

housing %>%
    ggplot(aes(x = medv)) +
    stat_density() +
    labs(x = "Median Value ($1000s)", y = "Density", title = "Density Plot of Median Value House Price in Boston") +
    theme_minimal()

summary(housing$medv)

housing %>%
    select(c(crim, rm, age, rad, tax, lstat, medv)) %>%
    melt( id.vars = "medv") %>%
    ggplot(aes(x = value, y = medv, colour = variable)) +
    geom_point(alpha = 0.7) +
    stat_smooth(aes(colour = "black")) +
    facet_wrap(~variable, scales = "free", ncol = 2) +
    labs(x = "Variable Value", y = "Median House Price ($1000s)") +
    theme_minimal()
set.seed(123)
to_train <- createDataPartition(y = housing$medv, p = 0.75, list = FALSE)
to_test<-createDataPartition(y=housing$medv, p=0.25,list=FALSE)
train <- housing[to_train, ]
test <- housing[to_test, ]

first_lm <- lm( medv ~ crim +rm +tax +lstat, data = train)
lm1_rsqu <- summary(first_lm)$r.squared
print(paste("First linear model has an r-squared value of ", round(lm1_rsqu, 3), sep = ""))

second_lm <- lm(log(medv) ~ crim +rm + tax +lstat, data = train)
lm2_rsqu <- summary(second_lm)$r.squared
print(paste("Our second linear model has an r-squared value of ", round(lm2_rsqu, 3), sep = ""))

abs(mean(second_lm$residuals))

predicted <- predict(second_lm, newdata = test)
results <- data.frame(predicted = exp(predicted), original = test$medv)

results %>%
    ggplot(aes(x = predicted, y = original)) +
    geom_point() +
    stat_smooth() +
    labs(x = "Predicted Values", y = "Original Values", title = "Predicted vs. Original Values") +
    theme_minimal()