library(ggplot2)
library(quantreg)
library(MASS)
library(ggcorrplot)

# Importing the dataset
soccer<- read.csv("C:/Users/kiera/OneDrive/Documents/NTU/Y2S2/MH3511 Data Analysis with Computer/Project/final_data.csv",sep = ",",header=TRUE)
soccer

# Section 2: Data Preparation and Cleaning
# Removes any rows w null values
soccerclean<- soccer[rowSums(is.na(soccer))==0,]

# Removes any rows that has current_value = 0
soccerclean <- soccerclean[soccerclean$current_value != 0, ]

# Removes any rows that has minutes.played = 0
soccerclean <- soccerclean[soccerclean$minutes.played != 0, ]
str(soccerclean)

# Removing non-attackers 
soccerclean<-soccerclean[soccerclean$position%in%c("Attack Centre-Forward","Attack-LeftWinger","Attack-RightWinger","Attack-SecondStriker"),]

# Renaming the data
soccerclean$position <- ifelse(soccerclean$position == "Attack Centre-Forward", "Centre Forward",
                               ifelse(soccerclean$position == "Attack-LeftWinger", "Left Winger",
                                      ifelse(soccerclean$position == "Attack-RightWinger", "Right Winger",
                                             ifelse(soccerclean$position == "Attack-SecondStriker", "Second Striker",
                                                    soccerclean$position))))

# Keeping relevant columns                                                  
colstokeep <- c("team", "name", "position", "height", "age", "goals", "assists", "minutes.played", "award","days_injured", "current_value", "winger")
soccerclean <- soccerclean[, colstokeep]

# Calculation of Total Goals and Total Assists
soccerclean$totalgoals <- soccerclean$goals * (soccerclean$minutes.played/90)
soccerclean$totalassists <- soccerclean$assists * (soccerclean$minutes.played/90)

# Section 3: Description of dataset
# 3.1 Summary Statistic for main variable of interest, current_value
# Plotting of histogram and log transformation due to skewness
par(mfrow=c(1,2))
hist(soccerclean$current_value, main = "Histogram of Current Value", xlab = "Current Value")
hist(log(soccerclean$current_value), main = "Histogram of log(Current Value)", xlab = "log(Current Value)")

# Plotting a barplot and log transformation
par(mfrow=c(1,2))
boxplot(soccerclean$current_value, main = "Boxplot of Current Value", ylab = "Current Value")
boxplot(log(soccerclean$current_value), main = "Boxplot of log(Current Value)", ylab = "log(Current Value)")

# New column created for logged current value 
soccerclean$log_cv<-log(soccerclean$current_value)

# Replotting the diagrams

hist(soccerclean$log_cv)
boxplot(soccerclean$log_cv)

# Removing outliers
original_count <- nrow(soccerclean)
cat("Number of players before removal:", original_count, "\n")

Q1 <- quantile(soccerclean$log_cv, 0.25, na.rm = TRUE)
Q3 <- quantile(soccerclean$log_cv, 0.75, na.rm = TRUE)
IQR <- Q3 - Q1

lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR

cat("Lower Bound:", lower_bound, "\n")
cat("Upper Bound:", upper_bound, "\n")

inliers <- soccerclean$log_cv >= lower_bound & soccerclean$log_cv <= upper_bound

num_outliers <- sum(!inliers)
cat("Number of outliers removed:", num_outliers, "\n")

soccerclean <- soccerclean[inliers, ]

# 3.2 Summary Statistic for other variables
# 3.2.1 Position
sort(table(soccerclean$position), decreasing = TRUE)

barplot(sort(table(soccerclean$position), decreasing = TRUE),
        col = "darkorange",
        main = "Distribution of Player Positions",
        ylab = "Number of Players",
        ) 
# 3.2.2 Winger

# Frequency table of winger status
table(soccerclean$winger)

# As percentages
round(prop.table(table(soccerclean$winger)) * 100, 1)

# 3.2.3 Height

hist(soccerclean$height,
     main = "Distribution of Player Heights",
     xlab = "Height (cm)",
     col = "lightblue",
     breaks = 20)

boxplot(soccerclean$height,
        main = "Boxplot of Player Height",
        ylab = "Height (cm)",
        col = "lightgreen")


original_n <- nrow(soccerclean)
cat("Players before removing height outliers:", original_n, "\n")

Q1 <- quantile(soccerclean$height, 0.25, na.rm = TRUE)
Q3 <- quantile(soccerclean$height, 0.75, na.rm = TRUE)
IQR <- Q3 - Q1

lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR

cat("Lower height bound:", lower_bound, "\n")
cat("Upper height bound:", upper_bound, "\n")

inliers <- soccerclean$height >= lower_bound & soccerclean$height <= upper_bound

cat("Height outliers removed:", sum(!inliers), "\n")

soccerclean <- soccerclean[inliers, ]

boxplot(soccerclean$height,
        main = "Boxplot of Player Height",
        ylab = "Height (cm)",
        col = "lightgreen")

# Analysing based on exact position
boxplot(height ~ position, data = soccerclean,
        main = "Player Height by Position Group",
        ylab = "Height (cm)",
        col = "skyblue",
        las = 1)

# 3.2.4 Age

hist(soccerclean$age,
     main = "Distribution of Player Age (as of 2023)",
     xlab = "Age",
     col = "lightblue",
     breaks = 15)

soccerclean$log_age<-log(soccerclean$age)
hist(soccerclean$log_age)

# Boxplot of age
boxplot(soccerclean$log_age,
        main = "Boxplot of lg(Player Age)",
        ylab = "Age",
        col = "lightgreen")

# Removing outliers
original_n <- nrow(soccerclean)
cat("Players before removing log_age outliers:", original_n, "\n")

Q1 <- quantile(soccerclean$log_age, 0.25, na.rm = TRUE)
Q3 <- quantile(soccerclean$log_age, 0.75, na.rm = TRUE)
IQR <- Q3 - Q1

lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR

cat("Lower height bound:", lower_bound, "\n")
cat("Upper height bound:", upper_bound, "\n")

inliers <- soccerclean$log_age >= lower_bound & soccerclean$log_age <= upper_bound

cat("log_age outliers removed:", sum(!inliers), "\n")

soccerclean <- soccerclean[inliers, ]

# 3.2.5 Days Injured

# Categorising
soccerclean$injury<-cut(soccerclean$days_injured,
                        breaks = c(-Inf,0,30,60,180,360,Inf),
                        labels = c("No injury","< 1M","1M - 2M","2M - 6M","6M - 1Y","> 1Y"))
barplot(table(soccerclean$injury),
        names.arg = c("No injury","< 1M","1M - 2M","2M - 6M","6M - 1Y","> 1Y"),
        col = c("lightgrey", "steelblue","green","yellow","brown","purple"),
        main = "Distribution of Injuries in Dataset",
        ylab = "Number of Players")

hist(log(soccerclean[soccerclean$days_injured > 0, "days_injured"]))
boxplot(log(soccerclean[soccerclean$days_injured > 0, "days_injured"]))

# 3.2.6 Total Goals

hist(soccerclean$totalgoals)
boxplot(soccerclean$totalgoals)

quantile(soccerclean$totalgoals, probs = seq(0, 1, 0.2), na.rm = TRUE)
breaks <- c(0, 1, 3, 8, 15, 83)
soccerclean$goal_category <- cut(soccerclean$totalgoals,
                                 breaks = breaks,
                                 include.lowest = TRUE,
                                 labels = c("Very Low", "Low", "Moderate", "High", "Very High"))
barplot(table(soccerclean$goal_category),
        col = "skyblue",
        main = "Number of Players by Goal Category",
        xlab = "Goal Category",
        ylab = "Number of Players")

# 3.2.7 Total Assists

hist(soccerclean$totalassists)
quantile(soccerclean$totalassists, probs = seq(0, 1, 0.25), na.rm = TRUE)
breaks <- c(0, 1, 3, 7, max(soccerclean$totalassists, na.rm = TRUE))
soccerclean$assists_category <- cut(soccerclean$totalassists,
                                    breaks = breaks,
                                    include.lowest = TRUE,
                                    labels = c("None", "Low", "Moderate", "High"))
barplot(table(soccerclean$assists_category),
        col = "violet",
        main = "Number of Players by Assists Category",
        xlab = "Assists Category",
        ylab = "Number of Players")

table(soccerclean$assists_category)

# 3.2.8 Minutes Played

hist(soccerclean$minutes.played)
hist(sqrt(soccerclean$minutes.played))
hist(log10(soccerclean$minutes.played))
hist(log(soccerclean$minutes.played))

soccerclean$minutes_category <- cut(soccerclean$minutes.played,
                                    breaks = c(-Inf, 500, 1500, 2700, 4000, Inf),
                                    labels = c("Very Low", "Low", "Moderate", "High", "Very High"),
                                    include.lowest = TRUE)
barplot(table(soccerclean$minutes_category),
        col = "skyblue",
        main = "Number of Players by Minutes Category",
        ylab = "Number of Players",
        xlab = "Minutes Categories")

# Section 4: Statistical Analysis
# 4.1.1 log_cv and height

# Scatter Plot
plot(soccerclean$height, soccerclean$log_cv,
     main = "Height vs log(Current Value)",
     xlab = "Height (cm)", ylab = "log(Current Value)",
     pch = 16, col = "blue")
abline(lm(log_cv ~ height, data = soccerclean), col = "red", lwd = 2)

# Pearson's correlation
cor.test(soccerclean$height, soccerclean$log_cv, method = "pearson")

# 4.1.2 log_cv and log_age

# Scatter Plot
plot(soccerclean$log_age, soccerclean$log_cv,
     main = "log(Age) vs log(Current Value)",
     xlab = "log(Age)", ylab = "log(Current Value)",
     pch = 16, col = "darkgreen")
abline(lm(log_cv ~ log_age, data = soccerclean), col = "red", lwd = 2)

# Pearson's correlation
cor.test(soccerclean$log_age, soccerclean$log_cv, method = "pearson")

# 4.2.1 log_cv and position

boxplot(log_cv ~ position, data = soccerclean,
        main = "log(Current Value) by Position",
        col = "lightblue",
        ylab = "log(Current Value)")

ggplot(soccerclean, aes(x = position, y = log_cv)) +
  geom_boxplot(fill = "lightblue") +
  stat_summary(fun = mean, geom = "point", color = "red", size = 2) +
  labs(title = "log(Current Value) by Position",
       x = "Position", y = "log(Current Value)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

anova_position <- aov(log_cv ~ position, data = soccerclean)
summary(anova_position)

# 4.2.2 log_cv and winger

boxplot(log_cv ~ winger, data = soccerclean,
        names = c("Non-Winger", "Winger"),
        col = c("lightgray", "lightblue"),
        main = "log(Current Value) by Winger Status",
        ylab = "log(Current Value)")

ggplot(soccerclean, aes(x = factor(winger, labels = c("Non-Winger", "Winger")), y = log_cv)) +
  geom_boxplot(fill = "lightblue") +
  stat_summary(fun = mean, geom = "point", color = "red", size = 2) +
  labs(title = "log(Current Value) by Winger Status",
       x = "Winger Status", y = "log(Current Value)") +
  theme_minimal()

# F-test
var.test(log_cv ~ winger, data = soccerclean)

# 2-sample t test
t.test(log_cv ~ winger, data = soccerclean, var.equal = TRUE)

# 4.3.1 log_cv and goals

# Spearman correlation for totalgoals variable
cor.test(
  x    = soccerclean$totalgoals,
  y    = soccerclean$log_cv,
  method = "spearman",
  exact  = FALSE        # for large n
)

# Extra Quantile Regression not included in report for totalgoals with minutes.played
# median (50th percentile) regression
rq50 <- rq(
  log_cv ~ totalgoals + minutes.played,
  tau = 0.5,
  data = soccerclean)

rq_all <- rq(
  log_cv ~ totalgoals + minutes.played,
  tau = c(0.2, 0.4, 0.6, 0.8),
  data = soccerclean)

summary(rq50)
summary(rq_all)
plot(summary(rq_all), parm = "totalgoals")

# Look into goal_category
boxplot(log_cv ~ goal_category, data = soccerclean,
        col = "lightblue",
        main = "log(Current Value) by Goal Category",
        xlab = "Goal Category",
        ylab = "log(Current Value)")

ggplot(soccerclean, aes(x = goal_category, y = log_cv)) +
  stat_summary(fun = mean, geom = "point", size = 3, color = "red") +
  stat_summary(fun = mean, geom = "line", aes(group = 1), color = "red") +
  geom_jitter(alpha = 0.3, width = 0.2, color = "darkblue") +
  labs(title = "Mean log(Current Value) by Goal Category",
       x = "Goal Category", y = "log(Current Value)") +
  theme_minimal()

# One-way ANOVA
anova_model <- aov(log_cv ~ goal_category, data = soccerclean)
summary(anova_model)

# Post-hoc test
pairwise.t.test(soccerclean$log_cv, soccerclean$goal_category, p.adjust.method = "bonferroni")

# Kruskal-Wallis Test, to further confirm the ANOVA results
kruskal.test(log_cv ~ goal_category, data = soccerclean)

# Post-hoc test
pairwise.wilcox.test(
  x = soccerclean$log_cv,
  g = soccerclean$goal_category,
  p.adjust.method = "bonferroni"
)

# 4.3.2 log_cv and assists

# Spearman rank correlation
cor.test(
  x    = soccerclean$totalassists,
  y    = soccerclean$log_cv,
  method = "spearman",
  exact  = FALSE        # for large n
)

# Dive into assists category
boxplot(log_cv ~ assists_category, data = soccerclean,
        col = "lightgreen",
        main = "log(Current Value) by Assist Category",
        ylab = "log(Current Value)",
        xlab = "Assist Category",
        las = 2)
ggplot(soccerclean, aes(x = assists_category, y = log_cv)) +
  geom_boxplot(fill = "lightblue") +
  stat_summary(fun = mean, geom = "point", color = "red", size = 2) +
  labs(title = "log(Current Value) by Assist Category",
       x = "Assist Category", y = "log(Current Value)") +
  theme_minimal()

# One-way ANOVA
anova_assist <- aov(log_cv ~ assists_category, data = soccerclean)
summary(anova_assist)

# Post-hoc test
pairwise.t.test(soccerclean$log_cv, soccerclean$assists_category, p.adjust.method = "bonferroni")

# Kruskal-Wallies Test (like goal cateogry)
kruskal.test(log_cv ~ assists_category, data = soccerclean)

# Post-hoc test
pairwise.wilcox.test(x = soccerclean$log_cv, g = soccerclean$assists_category,p.adjust.method = "bonferroni")

# 4.3.3 log_cv and injury

boxplot(log_cv ~ injury, data = soccerclean,
        col = "violet",
        main = "log(Current Value) by Injury Category",
        ylab = "log(Current Value)",
        xlab = "Injury Category")

ggplot(soccerclean, aes(x = injury, y = log_cv)) +
  geom_boxplot(fill = "lightblue") +
  stat_summary(fun = mean, geom = "point", color = "red", size = 2) +
  labs(title = "log(Current Value) by Injury Category",
       x = "Injury Category", y = "log(Current Value)") +
  theme_minimal()

# One-way ANOVA
anova_injury <- aov(log_cv ~ injury, data = soccerclean)
summary(anova_injury)

# Post-hoc test
pairwise.t.test(soccerclean$log_cv, soccerclean$injury, p.adjust.method = "bonferroni")

# 4.3.4 log_cv and minutes played

boxplot(log_cv ~ minutes_category, data = soccerclean,
        col = "lightblue",
        main = "log(Current Value) by Experience Level",
        xlab = "Experience Level",
        ylab = "log(Current Value)")

# One-way ANOVA
anova_exp <- aov(log_cv ~ minutes_category, data = soccerclean)
summary(anova_exp)

# Post-hoc test
pairwise.t.test(soccerclean$log_cv, soccerclean$minutes_category, p.adjust.method = "bonferroni")

# Section 5: Regression
# Simple linear regression
# log_cv vs totalgoals
model1<-lm(log_cv ~ totalgoals, data = soccerclean)
summary(model1)
par(mfrow=c(1,2))
boxplot(model1$residuals)
qqnorm(model1$residuals)
qqline(model1$residuals)

# log_cv vs totalassists
model2 <- lm(log_cv ~ totalassists, data = soccerclean)
summary(model2)
par(mfrow=c(1,2))
boxplot(model2$residuals)
qqnorm(model2$residuals)
qqline(model2$residuals)

# log_cv vs minutes.played
model3 <- lm(log_cv ~ minutes.played, data = soccerclean)
summary(model3)
par(mfrow=c(1,2))
boxplot(model3$residuals)
qqnorm(model3$residuals)
qqline(model3$residuals)

# log_cv vs days_injured
model4 <- lm(log_cv ~ days_injured, data = soccerclean)
summary(model4)
par(mfrow=c(1,2))
boxplot(model4$residuals)
qqnorm(model4$residuals)
qqline(model4$residuals)

# Robust regression
# Correlation between totalgoals, totalassists, minutes.played, log_cv
cor_matrix<-(cor(soccerclean[,c("log_cv","totalgoals","totalassists", "minutes.played")]))
ggcorrplot(cor_matrix,lab=TRUE)

# Huber’s M-estimator
robust_mod <- rlm(
  log_cv ~ totalgoals + totalassists + minutes.played,
  data = soccerclean)

summary(robust_mod)



















































