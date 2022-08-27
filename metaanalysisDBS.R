library(meta)
library(readxl)
library(metafor)
library(nlme)
library(lme4)

# Individual Data (Supplemental)
data <- read_excel("C:/Users/mzgra/Documents/FS2021/Meta-Analysis/individualdata.xlsx", sheet="Individual")
dim(data)
head(data)
data <- as.data.frame(data)

data[,2] <- as.numeric(data[,2]) # make the variables numeric
data[,3] <- as.numeric(data[,3])
data[,4] <- as.numeric(data[,4])
data[,5] <- as.numeric(data[,5])
data[,6] <- as.numeric(data[,6])
data[,7] <- as.numeric(data[,7])
data[,8] <- as.numeric(data[,8])

# Table 1

Capelle <- data[1:4,]
summary(Capelle)
sd(Capelle$improvement)

Chang <- data[5:9,]
summary(Chang)
sd(Chang$improvement)

Franzini <- data[10:11,]
summary(Franzini)
sd(Franzini$improvement)

Gruber <- data[12:20,]
summary(Gruber)
sd(Gruber$improvement)

Katsakiori <- data[21:28,]
summary(Katsakiori)
sd(Katsakiori$improvement)

Koyama <- data[29:40,]
summary(Koyama)
sd(Koyama$improvement)

Magarinos <- data[41:50,]
summary(Magarinos)
sd(Magarinos$improvement)

Sako <- data[51:56,]
summary(Sako)
sd(Sako$improvement)

Shaikh <- data[57:64,]
summary(Shaikh)
sd(Shaikh$improvement)

Sharma <- data[65:83,]
summary(Sharma)
sd(Sharma$improvement)

Sobstyl <- data[84:85,]
summary(Sobstyl)
sd(Sobstyl$improvement)

Starr <- data[86:107,]
summary(Starr)
sd(Starr$improvement)

Trottenberg <- data[108:112,]
summary(Trottenberg)
sd(Trottenberg$improvement)

Vidailhet <- data[113:134,]
summary(Vidailhet)
sd(Vidailhet$improvement)

# Mixed Effects Model no Covariates 
m <- lme(improvement ~ 1, data = data, random = ~ 1 | Study)
summary(m) # model
intervals(m) # CI

# Remove Chang et al and Shaikh et al for missing data
sdata <- data[-c(5:9, 57:64),] 
dim(sdata)
colnames(sdata)[4] <- "month"
# Center FU time and year values by their mean
mm <- mean(sdata[,4]) # compute the mean of the FU time
my <- mean(sdata[,8]) # compute mean of the years
sdata$cyear <- sdata[,8] - my # subtract the mean from years
sdata$cmonth <- sdata[,4] - mm # subtract the mean from months FU time

# Mixed Effects with Covariates
n = lme(improvement ~ baseline + cmonth + cyear, data = sdata, random = ~1 | Study)
summary(n) # model
intervals(n) # CI

# Fixed Effects
f = lm(improvement ~ 1, data = data)
summary(f) # model
confint(f) # CI

# Study Data (Table 1)
data2 <- read_excel("C:/Users/mzgra/Documents/FS2021/Meta-Analysis/individualdata.xlsx", sheet="means")
dim(data2)
head(data2)
meandat <- as.data.frame(data2)
rownames(meandat) = meandat$Study

# Random Effects 
m2 <- rma(meandat$mean, meandat$sd, data = meandat,  knha = TRUE)
m2
m2$ci.lb
m2$ci.ub
m2$pval

# Forest Plot (Figure 3)
forest(m2, header = TRUE, slab = meandat$Study, main = "Forest Plot")

# Funnel Plot (Figure 2)
funnel(m2, main = 'Funnel Plot')
text(m2$yi,sqrt(m2$vi)-.2, m2$slab, cex=.8)
