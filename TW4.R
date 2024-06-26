#install.packages("ggplot2")
install.packages("caret")
install.packages("tidyr")

library(caret)
library(ggplot2)
library(ggthemes)

data(iris)
help(iris)
iris_dataset<-iris
View(iris_dataset)

head(iris_dataset,7)

colnames(iris_dataset)<-c("Sepal.Length","Sepal.Width","Petal.Length","Petal.Width","Species")
head(iris_dataset,5)

index <- createDataPartition(iris_dataset$Species, p=0.80, list=FALSE)
testset <- iris_dataset[-index,]
trainset <- iris_dataset[index,]

dim(trainset)
str(trainset)
summary(trainset)

levels(trainset$Species)

hist(trainset$Sepal.Width)

par(mfrow=c(1,4))
for(i in 1:4) {
    boxplot(trainset[,i], main=names(trainset)[i])
}

g <- ggplot(data=trainset, aes(x = Petal.Length, y = Petal.Width))
print(g)

g <-g + 
    geom_point(aes(color=Species, shape=Species)) +
    xlab("Petal Length") +
    ylab("Petal Width") +
    ggtitle("Petal Length-Width")+
    geom_smooth(method="lm")
print(g)

box <- ggplot(data=trainset, aes(x=Species, y=Sepal.Length)) +
    geom_boxplot(aes(fill=Species)) + 
    ylab("Sepal Length") +
    ggtitle("Iris Boxplot") +
    stat_summary(fun.y=mean, geom="point", shape=5, size=4) 
print(box)

histogram <- ggplot(data=iris, aes(x=Sepal.Width)) +
    geom_histogram(binwidth=0.2, color="black", aes(fill=Species)) + 
    xlab("Sepal Width") +  
    ylab("Frequency") + 
    ggtitle("Histogram of Sepal Width")+
    theme_economist()
print(histogram)

facet <- ggplot(data=trainset, aes(Sepal.Length, y=Sepal.Width, color=Species))+
    geom_point(aes(shape=Species), size=1.5) + 
    geom_smooth(method="lm") +
    xlab("Sepal Length") +
    ylab("Sepal Width") +
    ggtitle("Faceting") +
    theme_fivethirtyeight() +
    facet_grid(. ~ Species) # Along rows
print(facet)