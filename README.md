# Abstract:
Football is one of the most globally followed sports, with millions of people watching weekly matches. Fans of the sport closely watch their favourite player’s performance and their player’s market valuation especially closer to the transfer periods. A player’s market value often reflects their current and potential contribution during each game. This project aims to analyse a dataset comprising the player's current valuations and other variables in order to identify any potential correlations between them.

# 1.  Introduction
In 2023 alone, global football transfer spending reached a record-breaking $9.63 billion, reflecting the growing financial stakes and strategic importance of player transfers in the modern game. Notable transfers like Neymar’s €222 million move to Paris Saint-Germain, Kylian Mbappé’s €180 million transfer, and João Félix’s €126 million deal exemplify how player valuations have escalated dramatically in recent years.
These staggering figures highlight how crucial it has become to understand the factors that drive a player’s market value. We used a dataset containing transfer prices across 2 seasons, 2021-2022 and 2022-2023, and investigated the variables influencing football players’ transfer prices. This project aims to uncover patterns and insights that can inform better decision-making within the football transfer market. We hope to answer these questions through our analysis:
Questions: 
* Can the trading value of a player be predicted using a player's height, and age? 
* To what extent do injuries result in a difference in a player's trading value?
* Does the number of assists or goals affect a player's trading value more? 
* Does a player's position affect their trading value? 
* Which team has the most number of players with the highest trading value / which teams players have the highest average trading value? 
* Is it guaranteed that players with more experience will be traded at higher trading values?

# 2. Data Preparation and Cleaning

The “Football Player Transfer Values” dataset was obtained from Kaggle, constructed to estimate football players' transfer fees. It consists of 1 CSV file, titled “FootballTransferValues”, with over 22 attributes per player, providing a comprehensive overview of factors that may influence a player's transfer value. These attributes include basic demographic information such as age, height, and playing position, as well as professional statistics including goals scored, assists, injury history, and total individual and team awards accumulated over a player's career. All data was recorded across the 2021 - 2022 and 2022 - 2023 seasons and is a curated collection of real-world football data. 

Before proceeding to data analysis, we first performed a preliminary data cleaning to ensure that: 
1. Rows with missing values or zero market value (current_value) were cleared. 
2. Players with zero minutes played (minutes.played = 0) across the two seasons were excluded, ensuring that the analysis was only focused on active players with actual playing time.
3. We narrowed the analysis to focus on players in attacking positions, as fields such as ‘goals’ and ‘assists’ would not be applicable for players in defending positions. As such, we filtered the dataset to include only those in forward positions: Centre Forward, Left Winger, Right Winger and Second Striker.
4. To streamline the analysis, only relevant variables were retained. These included player demographics, performance metrics, injury history, and market value indicators. The refined dataset focused on attributes most pertinent to evaluating player value and performance.
5. To estimate each player's overall contribution, total goals and total assists were calculated by scaling their per-90-minute averages according to total minutes played. This provided a more accurate measure of offensive output across the two seasons.

After all the preparation and cleaning,  2794 observations (players) with 14 variables are retained for analysis.
* Name: Player Name (Cristiano Ronaldo, Neymar, …)
* Position: Position played by the player the most (Left Winger, Right Winger, Second Striker, Centre Forward)
* Height: Height of the player in cm
* Age: Age of player as of 2023
* Minutes.played: Total minutes played across the 2 seasons
* Days_injured: Total number of days injured across the 2 seasons
* Current_value: Current trading value of the player - as of 2023 (EUR)
* Winger: A binary variable where 1: winger, 0: not a winger
* Totalgoals: Total number of goals scored across the 2 seasons
* Totalassists: Total number of assists made across the 2 seasons
* Goals_category: Categorised the variable totalgoals
* Assists_category: Categorised the variable totalassists
* Injury: Categorised the variable days_injured
* Minutes_category: Categorised the variable minutes.played

# 3. Description and Cleaning of Dataset

## 3.1 Summary statistics for the main variable of interest, current_value

![image](images/3.1%20Histogram.png)

* As seen in the histogram of current_value, we observed that the variable exhibited significant right-skewness. To address this, we applied a natural log transformation to the variable.

![image](images/3.1%20Boxplot.png)

* The log-transformed data appears to have some outlying values at the right tail. Therefore we plotted a boxplot of log(current_value) to investigate the outliers. As seen in the boxplot mentioned, there are some outliers on the right of the boxplot. 
* As a result, we removed 8 observations with values of log(current_value) greater than 18.32185 or less than 9.645639, resulting in a reduction in the number of observations from 2794 to 2786.

## 3.2 Summary Statistics for other variables
### 3.2.1 Position of the player `position`
![image](images/3.2.1%20Position.png)

* The bar chart displays the distribution of players across the four attacking positions: Centre Forward, Left Winger, Right Winger, Second Striker.

### 3.2.2 Whether he is a winger `winger`
![image](images/3.2.2%20Winger.png)

* Winger is encoded as a binary variable, hence we used a 2-sample t-test to examine the distribution.
* Since there is a nearly equal distribution between wingers and non-wingers in the dataset, it supports fair comparisons in subsequent analyses involving the winger variable, such as examining its relationship with market value.
  
### 3.2.3 Height of the player `height`
![image](images/3.2.3%20Distribution%20of%20player's%20height.png)

* Player height is relatively normally distributed among attackers in the sample, with most falling between 170 cm and 190 cm.

![image](images/3.2.3%20Boxplot%20of%20player%27s%20height.png)

* We removed 16 height outliers, resulting in the boxplot as shown.

![image](images/3.2.3%20Player%20Height%20by%20position.png)

* Finally, we analysed the distribution based on each position group.
* Height may play a more prominent role for Centre Forwards compared to other forward roles.

### 3.2.5 Age of the player `age`
![image](images/3.2.4%20Distribution%20of%20log_age.png)
![image](images/3.2.4%20Boxplot%20of%20log_age.png)

* The log-transformation(base e) is applied.
* No outliers are removed for the boxplot.

### 3.2.5 Total number of days injured across the 2 seasons, `days_injured`
![image](images/3.2.5%20Distribution%20of%20Injuries%20in%20the%20dataset.png)

* To analyse how injury history relates to player value and performance, we created a new categorical variable injury based on total days injured over two seasons.
* The variable segments players into six bands reflecting the severity and typical recovery duration of injuries.
  
![image](images/3.2.5%20Boxplot%20of%20log%20days%20injured.png)

* The log-transformation(base e) is applied.
* No outliers are removed for the boxplot.
  
### 3.2.6 Goals scored `totalgoals`
![image](images/3.2.6%20Histogram%20of%20totalgoals.png)
![image](images/3.2.6%20Boxplot%20of%20totalgoals.png)

* Data is highly skewed and contains a high number of outliers. However, these values were not removed, as they represent genuine, high-performing players within the dataset.
* As such, it is expected that a small number of attackers contribute disproportionately to goals scored, hence these outliers are not anomalies but true reflections of performance.
  
![image](images/3.2.6%20Number%20of%20players%20by%20category.png)

* To enable comparison across different levels of scoring performance, we used quantiles at 20% intervals.
* Resulting in five categories:
1. Very Low (0–1),
2. Low (2–3),
3. Moderate (4–8),
4. High (9–15), and
5. Very High (16–83)
   
### 3.2.7 Total Assists `totalassists`
![image](images/3.2.7%20Histogram%20of%20totalassists.png)

* Again, data is highly skewed and contains many outliers.
* Similar to totalgoals, no outliers were removed.

![image](images/3.2.7%20Number%20of%20players%20by%20category.png)

* As with goal-scoring, quantiles were computed for total assists to guide the creation of assist performance categories.
* Resulting in four categories:
1. None (0-1),
2. Low (1-3),
3. Moderate (3-7),
4. High (7-43)
   
### 3.2.8 Total number of minutes played across the 2 seasons, `minutes.played`

![image](images/3.2.8%20Histogram%20of%20minutes%20played.png)
![image](images/3.2.8%20Histogram%20of%20log%20minutes%20played.png)

* Original data is highly skewed to the right.
* Similar to total assists and total goals, no outliers were removed as they are true reflections of performance.

![image](images/3.2.8%20Number%20of%20players%20by%20category.png)

* Rather than using quantiles, which split the data into equal-sized groups without contextual meaning, we defined cutoffs that reflect real-world playing time thresholds in football.
* An entire season typically consists of around 2700 minutes. Hence, players were grouped into five experience levels:
1. Very Low (<500 minutes),
2. Low (500–1500)
3. Moderate (1500–2700)
4. High (2700–4000)
5. Very High (>4000).

# 4. Statistical Analysis
## 4.1 Correlation between log_cv and numerical variables in the raw data
### 4.1.1 Relation between log_cv and height
![Scatter Plot: log_cv vs Height](images/4.1.1%20Scatter%20Plot%20between%20log_cv%20and%20height.png)

* The scatterplot shows a very weak positive trend between height and log-transformed market value (log_cv).
![Pearson Correlation](images/4.1.1%20Pearson%20Correlation.png)  
* We performed a Pearson test which revealed a statistically significant but very weak positive correlation between the two variables, r = 0.077, p < 0.001. This indicates that taller players tend to have slightly higher market values, but the strength of this relationship is minimal and likely not practically meaningful.

##### Conclusion
* Although the correlation is statistically significant, the large spread of points around the trend line indicates that height plays a negligible role in determining a player's market value.
  
### 4.1.2 Relation between log_cv and log_age
![Scatter Plot: log_cv vs log_age](images/4.1.2%201.png)

* As shown in the scatterplot, although there is a slight upward trend in the regression line, the positive association between log_age and log_cv is weak.
* The wide spread of data points around the regression line suggests that log-transformed age does not strongly predict a player’s market value.
* While older players may have slightly higher values on average, this effect is minimal and likely influenced by other variables such as performance or position.

![Pearson Correlation](images/4.1.2%202.png) 

* The result showed a statistically significant but very weak positive correlation, r = 0.054, p = 0.004.
* This indicates that older players tend to have slightly higher market values, but the strength of this relationship is minimal and likely not practically meaningful.

##### Conclusion
* Although the correlation is statistically significant, the large spread of points around the trend line indicates that log_age plays a negligible role in determining a player's market value.

## 4.2 Correlations between log_cv and categorical variables in raw data
### 4.2.1 Relation between log_cv and position
![Boxplot](images/4.2.1%20Boxplot.png)  

* The box plot illustrates the distribution of log-transformed player market value (log_cv) across four attacking positions: Centre Forward, Left Winger, Right Winger, and Second Striker.
##### Observations:
* The distributions appear fairly similar, with no striking differences in median or mean
values across groups. This suggests that among attackers, the specific position alone
does not substantially differentiate market value.
* While Centre Forwards and Wingers show slightly higher mean values, the overlapping
interquartile ranges imply that value is more likely influenced by individual performance
metrics (e.g., goals, assists) rather than position alone.

![One Way ANOVA](images/4.2.1%20One%20Way%20ANOVA.png)

* A one-way ANOVA was conducted to examine whether market value (log_cv) differed significantly across attacker positions (Centre Forward, Left Winger, Right Winger, Second Striker).
* The results indicated that position was not a statistically significant predictor of market value (F(3, 2766) = 1.22, p = 0.301).

##### Conclusion
* This suggests that among attackers, market value does not significantly differ by positional role.

### 4.2.2  Relation between log_cv and winger
![Boxplot](images/4.2.2%20Boxplot.png)  

* This boxplot compares log-transformed market value (log_cv) between Wingers and Non-Wingers.
##### Observations:
* Both groups exhibit nearly identical distributions, with overlapping interquartile ranges, similar medians, and means. This suggests that being a winger does not significantly influence a player’s market value on its own.
* Instead, valuation is likely driven more by individual performance metrics such as goals and assists, rather than a binary positional classification.

![F-test](images/4.2.2%20F-test.png)

* The F-test returned a p-value of 0.5122 > 0.05, hence we do not reject the null hypothesis that the true ratio of variances is equal to 1. Equal variances were assumed for the two-sample t-test.

![Two Sample Test](images/4.2.2%202%20sample%20test.png)  

* We then performed a two-sample t-test to determine whether there is any true difference in means with the following hypotheses:
𝐻0: Mean log_cv is equal between wingers and non-wingers
𝐻1: Mean log_cv is different between the two groups
* The p-value (0.3454) is much greater than 0.05, so we do not reject the null hypothesis, drawing the conclusion that mean log_cv is equal.

##### Conclusion
* There is no statistically significant difference in log_cv between wingers and non-wingers.

## 4.3. Correlations between log_cv and variables that we changed
### 4.3.1 Relation between log_cv and goals
![Scatterplot](images/4.3.1%20Scatterplot.png)  

* The regression line shows positive correlation between totalgoals and log_cv - however, the relationship looks mostly non-linear.
* To confirm this association, we conduct a hypothesis test with the following hypotheses:
𝐻0: p=0 (there is no monotonic association)
𝐻1: p≠0 (there is a monotonic association)

![Spearman Correlation](images/4.3.1%20Spearman.png)

* The Spearman's rank correlation coefficient (rho) of 0.516794 indicates a moderate positive correlation between totalgoals and log_cv.
* The significantly low p-value also indicates that the correlation is statistically significant.
  
![Boxplot](images/4.3.1%20Boxplot.png)

* The bar chart displays the distribution of players across the five goal-scoring categories.
* While all categories are relatively well-represented, there are a few observations:
1. Moderate group contains the largest number of players, suggesting that most attackers score between 4 to 8 goals over two seasons.
2. Both the Very Low and Very High categories are also substantial, reflecting the expected variation in forward performance.
* The balanced spread across categories supports robust comparative analysis.

![One Way ANOVA](images/4.3.1%20One%20Way%20ANOVA.png)  

* The large F-statistic indicates substantial between-group variation relative to within-group variation, suggesting that goal-scoring categories strongly predict market value differences.
* Also, the very small p-value shows that this relationship between goal-scoring categories and market value is significant.

![Post Hoc](images/4.3.1%20Post%20Hoc.png)  

* The Bonferroni-adjusted pairwise t-tests show that log_cv differs significantly across nearly all goal-scoring categories.
1. Every comparison involving the Very High and High scoring groups shows extremely small p-values (all < 2e-16), indicating strong evidence of value differences.
2. Even lower-tier comparisons, such as between Low and Very Low, are statistically significant.
* This reinforces the ANOVA findings, confirming that goal-scoring performance has a clear and measurable impact on player market value.

### 4.3.2 Relation between log_cv and assists
![Scatterplot](images/4.3.2%20Scatterplot.png) 

* There is a slight positive relationship between totalassists and log_cv.
* This trend suggests that the current value of a player increases as the totalassists increases.
* However, the relationship looks mostly non-linear.
* Thus, to confirm the presence of this association, we conduct a hypothesis test with the following hypotheses:
𝐻0: p=0 (there is no monotonic association)
𝐻1: p≠ 0 (there is a monotonic association)

![Spearman Correlation](images/4.3.2%20Spearman.png)

* Based on the results from the Spearman’s rank correlation test, we get a rho value of 0.5331, which indicates a moderate positive monotonic relationship between totalassists and log_cv.
* This supports the analysis from the scatter plot, as there is a positive relationship, but it is not necessarily linear.
* The test also yields a p-value < 2.2e^-16, which is significantly smaller than the significance level set at 0.05.
* Thus, we reject the null hypothesis and conclude that there is strong evidence of a significant monotonic relationship between totalassists and log_cv.

![Boxplot](images/4.3.2%20Boxplot.png)  

* Now we examine the distribution of log_cv across the 4 categories for assists.
* From the boxplot, we can see that in general, players in the higher assist categories have a higher log_cv value, showing a positive relationship between log_cv and the Assist Category.

![One Way ANOVA](images/4.3.2%20One%20Way%20ANOVA.png) 

* To statistically test the observations from the boxplot, we perform an ANOVA test with the following hypothesis:
𝐻0: All group means of log_cv are equal
𝐻1: At least one group mean is different
* From the results generated, our F-statistic is extremely high, at 349.5, and our p-value < 2e^-16, which is lower than the significance value of 0.05.
* Thus, we reject the null hypothesis and conclude that there are significant differences in the group means across the categories.

![Post Hoc](images/4.3.2%20Post%20Hoc.png)  

* We then go one step further to investigate which specific groups differ by conducting pairwise t-tests with Bonferroni adjustment to control for
multiple comparisons.
* From the results, all the p-values < 2e^-16, which tells us that all comparisons between the categories are statistically significant for significance levels of 0.05.
* This means that each assist category has a significantly different mean from the other categories.

![Spearman Correlation](images/4.3.2%20Spearman.png)

### 4.3.3 Relation between log_cv and days injured

![Boxplot](images/4.3.3%20Boxplot.png)  

* The boxplot visualises the relationship between injury categories and log_cv.
* Interestingly, players with no injury history tend to have lower median and mean market values than those who experienced injuries, even in longer-duration categories.
* This suggests that higher-valued players may be more involved in gameplay, increasing their risk of injury, or that market value is resilient to moderate injury setbacks, especially for established or high-performing players.

![One Way ANOVA](images/4.3.3%20One%20Way%20ANOVA.png) 

* To statistically test the observations from the boxplot, we performed an ANOVA test with the following hypothesis:
𝐻0: log_cv does not differ significantly across levels of injury duration.
𝐻1: log_cv differs significantly across levels of injury duration
* From the results generated, F-value is high at 92.72, and p-value is < 2e^-16, lower than the significance level of 0.05.
* Hence, we reject the null hypothesis and conclude that there is a statistically significant difference in market value among players based on their injury history.

![Post Hoc](images/4.3.3%20Post%20Hoc.png)

* Again, we go one step further and perform pairwise t-tests with Bonferroni adjustment. The results were aligned with what was observed from the boxplot.
* Since all p-values < 2e^-16, it revealed that players with no injury history have significantly lower mean current value compared to all injury categories.
* As for players with injury history, all p-values were above 0.05, showing no significant differences between the various injury durations.

### 4.3.4 Relation between log_cv and minutes.played

![Boxplot](images/4.3.4%201.png)  

* The boxplot visualises the relationship between experience level categories and log_cv.
* The general trend is as expected, where an increase in experience level led to an increase in log_cv.

![One Way ANOVA](images/4.3.4%202.png) 

* To statistically test the observations from the boxplot, we perform an ANOVA test with the following hypothesis:
𝐻0: log_cv does not differ significantly across experience levels.
𝐻1: log_cv differs significantly across experience levels.
* From the results generated, F-value is significantly high at 289.8, and p-value is < 2e^-16, lower than the significance level of 0.05.
* Hence, we reject the null hypothesis and conclude that there is a statistically significant difference in market value among players based on their experience levels.

## 4.4 What is the most important variable to predict log_cv?
We will now perform a simple linear regression analysis to determine which of the 4 performance measures could be used to model log_cv through a simple regression analysis:

![Equation](images/4.4%201%20Equation.png)  

$ \log\_cv = \beta_0 + \beta_1 X + \varepsilon $

where 𝑋 could be one of totalgoals, totalassists, minutes.played, or days_injured. 

The table below shows the summary of the analysis.

By comparing the R-squared and the residual plot, minutes.played is determined to be the most important measure to model log(cv), closely followed by totalassists, then totalgoals using a
simple linear model.

##### Total Goals (X):
Fitted Model with Y being log_cv: $Y = 13.2280 + 0.0853X$
p-value: <2.2e^{-16}
R-squared: 0.2546
Boxplot and qq-plot of residuals:
![Total Goals](images/4.4%202%20totalgoals.png)  

##### Total Assistss (X):
Fitted Model with Y being log_cv: $Y = 13.2151 + 0.1724X$
p-value: <2.2e^{-16}
R-squared: 0.2807
Boxplot and qq-plot of residuals:
![Total Assists](images/4.4%203%20totalassists.png)  

##### Minutes.played (X):
Fitted Model with Y being log_cv: $Y = 1.279e^1 + (5.038e^{-4})X$
p-value: <2.2e^{-16}
R-squared: 0.3125
Boxplot and qq-plot of residuals:
![Minutes Played](images/4.4%204%20minutes.played.png) 

##### Total Assists (X):
Fitted Model with Y being log_cv: $Y = 13.7219 + 0.0019X$
p-value: <2.2e^{-16}
R-squared: 0.0442
Boxplot and qq-plot of residuals:
![Days Injured](images/4.4%205%20days_injured.png)

### 4.5 Multi Linear Regression (Robust Regression)
In this section, we attempt to build a multiple linear model for ‘log_cv’ based on the 4 statistically significant numerical measures from our analysis, namely ‘totalgoals’ and ‘totalassists’, ‘minutes.played’, and ‘days_injured’. 

We used a robust regression model instead of a standard OLS model, due to our key predictors (totalgoals and totalassists) being highly right-skewed and non-normalized. In a standard OLS fit, those extreme X-values become high-leverage points that can disproportionately pull the slope estimates. 

By using Huber’s M-estimator rlm(), we down-weight observations with unusually large residuals or leverage, producing coefficient estimates that better reflect the typical relationship across the full sample of attackers. The resulting robust slopes are slightly more conservative than OLS but confirm the same substantive story—goals and assists each carry a strong, positive premium in market value—while guarding against undue influence from a few outliers.

![Multiple Regression](images/4.5%20Multi%20Regression.png)

The results and analysis of the new fitted model as shown below:
log_cv = 12.7089 + 0.0266 * totalgoals + 0.0714 * totalassists + 0.0002 * minutes.played + 0.0014 * days_injured
