library(lme4)
library(ggplot2)
library(lattice)
require(GGally)
require(reshape2)
library(gridExtra)

#https://stats.idre.ucla.edu/r/dae/mixed-effects-logistic-regression/
#https://bookdown.org/roback/bookdown-bysh/ch-multilevelintro.html
#https://www.barelysignificant.com/post/icc/

setwd("/Users/awinecoff/Desktop/mlm")
decisionData <- read.csv("data_for_R_glm.csv", header =TRUE)
decisionDataWomen<-droplevels.data.frame(decisionData)#drop any ghost levels
decisionDataWomen <-na.omit(decisionData)
#setwd("/Users/amywinecoff/Documents/sport_body_project/sport_body_project/analysis")

decisionDataWomen <-subset(decisionData, gender=="Female")
decisionDataMen<-subset(decisionData, gender == "Male")

#decisionDataWomen<-droplevels.data.frame(decisionDataWomen)#drop any ghost levels
#decisionDataWomen <-na.omit(decisionDataWomen)

#num_vars <- names(select_if(decisionDataWomen, is.numeric))
#visualize correlations between non-experimental numeric variables
#ggpairs(decisionDataWomen[, c("education", "age", "BMI")])

#tmp <- melt(decisionDataWomen[, c("chose_test", "education", "age", "BMI")],
#            id.vars="chose_test")
#ggplot(tmp, aes(factor(chose_test), y = value, fill=factor(chose_test))) +
#  geom_boxplot() +
#  facet_wrap(~variable, scales="free_y")


#unconditional_model <-glmer(chose_test ~ 1 + (1 | subj), data=decisionDataWomen, family = binomial, control = glmerControl(optimizer = "bobyqa"))

#ICC <-
wm <- glmer(chose_test ~ sport + emaciation + detail + size + sport:emaciation + sport:detail + sport:size +
             (1 | subj), data = decisionDataWomen, family = binomial, control = glmerControl(optimizer = "bobyqa"),
           nAGQ = 10)

mm <- glmer(chose_test ~ sport + emaciation + detail + size + sport:emaciation + sport:detail + sport:size +
              (1 | subj), data = decisionDataMen, family = binomial, control = glmerControl(optimizer = "bobyqa"),
            nAGQ = 10)


plotFeaturePredictions <- function(data, sport, feature, model){
  
  jvalues<-c(0.00, 0.25, 0.50, 0.75)
  
  
  pp <- lapply(jvalues, function(j) {
    data[[feature]] <- j
    predict(model, newdata = data, type = "response")
  })
  
  
  plotdat <- t(sapply(pp, function(x) {
    c(M = mean(x, na.rm=TRUE), c(0.25, 0.75))
  }))
  
  plotdat <- as.data.frame(cbind(plotdat, jvalues))
  plotdat["Sport"]<-sport
  colnames(plotdat) <- c("PredictedProbability", "Lower", "Upper", feature, "Sport")

  return(plotdat)
}

generatePlots <- function(data, feature, model){
  cf <-subset(data, sport=="CrossFit")
  rc <-subset(data, sport=="Rock climbing")
  r<-subset(data, sport=="Running")

  #Generate predictions across the body dimension values for each sport separately
  r_pd <-plotFeaturePredictions(data=r, sport="Running",feature=feature, model=model)
  rc_pd <-plotFeaturePredictions(data=rc, sport="Rock climbing",feature=feature, model=model)
  cf_pd <-plotFeaturePredictions(data=cf, sport="CrossFit",feature=feature, model=model)
  allsport_pd<-rbind(r_pd, rc_pd, cf_pd)

  p<-ggplot(allsport_pd, aes_string(x = feature, y = "PredictedProbability", group="Sport", colour="Sport")) + geom_line() +
    ylim(c(0, 1)) + scale_x_continuous(name = feature, breaks = seq(0.0, 0.75, by = 0.25)) + ylab("predicted probability") +
    scale_color_manual(values=c('#A0AF84', '#634563', '#FC7358'))
  
  return(p)
}

p_we <-generatePlots(decisionDataWomen, "emaciation", wm)
p_wd <-generatePlots(decisionDataWomen, "detail", wm)
p_ws <-generatePlots(decisionDataWomen, "size", wm)
#https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html
grid.arrange(p_we, p_wd, p_ws, nrow = 1, top="Effect of Body Dimension on Choice (Women)")

p_me <-generatePlots(decisionDataMen, "emaciation", mm)
p_md <-generatePlots(decisionDataMen, "detail", mm)
p_ms <-generatePlots(decisionDataMen, "size", mm)
#https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html
grid.arrange(p_me, p_md, p_ms, nrow = 1, top="Effect of Body Dimension on Choice (Men)")


