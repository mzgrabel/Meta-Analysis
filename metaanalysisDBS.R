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

# Mixed Effects Model no Covariates 
m <- lme(improvement ~ 1, data = data, random = ~ 1 | Study)
summary(m)

# Remove Chang et al and Shaikh et al for missing data
sdata <- data[-c(33:37, 122:129),] 
dim(sdata)
colnames(sdata)[4] <- "month"
sdata[,4] <- as.numeric(sdata[,4]) # convert FU time in months to numeric
mm <- mean(sdata[,4]) # compute the mean of the FU time
my <- mean(sdata[,8]) # compute mean of the years
sdata$cyear <- sdata[,8] - my # subtract the mean from years
sdata$cmonth <- sdata[,4] - mm # subtract the mean from months FU time
sdata$baseline <- as.numeric(sdata$baseline) # make baseline score numeric

# Mixed Effects with Covariates
n = lme(improvement ~ baseline + cmonth + cyear, data = sdata, random = ~1 | Study)
summary(n)

# Fixed Effects
f = lm(improvement ~ 1, data = data)
summary(f)

# Study Data (Table 1)
data2 <- read_excel("C:/Users/mzgra/Documents/FS2021/Meta-Analysis/individualdata.xlsx", sheet="means")
dim(data2)
head(data2)
meandat <- as.data.frame(data2)
rownames(meandat) = meandat$Study

# Random Effects 
m2 <- rma(meandat$mean, meandat$sd, data = meandat,  knha = TRUE)
m2

# Forest Plot (Figure 3)
forest(m2, header = TRUE, slab = meandat$Study)

# Funnel Plot (Figure 2)
funnel(m2, legend = TRUE)
