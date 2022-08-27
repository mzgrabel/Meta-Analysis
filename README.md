# Meta-Analysis
This provides the data and code for the paper: Pallidal Deep Brain Stimulation for Tardive Syndromes: A Meta Analysis of Clinical Outcomes

The first three word documents are the results of the pubmed literature searches denoted in the title and header including all the abstracts. Highlighted are the relevant papers found and used.

individualdata.xlsx is all the supplemental data used for running the models in the R code.

metanalysisDBS.R is the code used to analyze the data 

The code does the following:
- reads in the "individual" sheet data and converts it to numeric
- subsets the data into individual studies to get the mean min and max values for table 1 and the sd values for the random effects model
- runs a mixed effect model predicting for improvement with just an intercept for the fixed effects and having the random effects be by the study
- returns the summary output giving the estimates for the fixed and random effects coefficients and the resulting confidence intervals
- removes the entries with missing values for the covariates. This included all of the studies for Chang et al. for missing FU month values and Shaikh et al. for missing baseline and FU scores.
- resets the name or label of the FU month column to "month" for the purpose of writing the variable in the model
- computes the mean values of the months to FU and the years of the study to center these variables for a more interpretable result in the model
- runs a mixed effect model with the covariates of baseline, cmonth, and cyear, as the fixed effects where random effects are by the study.
- returns the summary output giving the estimates for the intercept and each of the covariates given that they are significant denoted by the p-value. Similarly returns the confidence interval. Note: all the covariates were not significant
- runs a simple fixed effect model predicting for improvement with only an intercept returning the estimate along with its significance and confidence interval
- reads in the "means" sheet from the individualdata.xlsx for the mean improvement and standard deviation needed for the random effects model.
- converts the data to a dataframe format and changes the row labels to be the study name for plotting
- runs a random effects model on this second dataset using the RMA function denoting a Robust Multi-array Average estimate of the means given.
- returns the estimate value confidence interval and pvalue for the model
- creates forest plot Figure 3 based on the output 
- creates funnel plot Figure 2 based on the output and labels the studies in the plot
