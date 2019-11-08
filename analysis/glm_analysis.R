library(lme4)
library(ggplot2)
library(lattice)
require(GGally)
require(reshape2)

#https://stats.idre.ucla.edu/r/dae/mixed-effects-logistic-regression/
#https://bookdown.org/roback/bookdown-bysh/ch-multilevelintro.html
#https://www.barelysignificant.com/post/icc/

setwd("/Users/amywinecoff/Documents/sport_body_project/sport_body_project/data")
decisionData <- read.csv("data_for_R_glm.csv", header =TRUE)
setwd("/Users/amywinecoff/Documents/sport_body_project/sport_body_project/analysis")

decisionDataWomen <-subset(decisionData, gender=="Female")
decisiondDataMen<-subset(decisionData, gender == "Male")

decisionDataWomen<-droplevels.data.frame(decisionDataWomen)#drop any ghost levels

#num_vars <- names(select_if(decisionDataWomen, is.numeric))
#visualize correlations between non-experimental numeric variables
ggpairs(decisionDataWomen[, c("education", "age", "BMI")])

tmp <- melt(decisionDataWomen[, c("chose_test", "education", "age", "BMI")],
            id.vars="chose_test")
ggplot(tmp, aes(factor(chose_test), y = value, fill=factor(chose_test))) +
  geom_boxplot() +
  facet_wrap(~variable, scales="free_y")

inte
unconditional_model <-glmer(chose_test ~ 1 + (1 | subj), data=decisionDataWomen, family = binomial, control = glmerControl(optimizer = "bobyqa"),
                            nAGQ = 10)

ICC <-
m <- glmer(chose_test ~ sport + emaciation + detail + size + sport:emaciation + sport:detail + sport:size +
             (1 | subj), data = decisionDataWomen, family = binomial, control = glmerControl(optimizer = "bobyqa"),
           nAGQ = 10)


