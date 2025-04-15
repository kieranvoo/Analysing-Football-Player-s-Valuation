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

As seen in the histogram of current_value, we observed that the variable exhibited significant right-skewness. To address this, we applied a natural log transformation to the variable.

![image](images/3.1%20Boxplot.png)

The log-transformed data appears to have some outlying values at the right tail. Therefore weplotted a boxplot of log(current_value) to investigate the outliers. As seen in the boxplotmentioned, there are some outliers on the right of the boxplot. 
As a result, we removed 8 observations with values of log(current_value) greater than 18.32185 or less than 9.645639, resulting in a reduction in the number of observations from 2794 to 2786.

## 3.2 Summary Statistics for other variables
### 3.2.1 Position of the player `position`
![image](images/3.2.1%20Position.png)
The bar chart displays the distribution of players across the four attacking positions: Centre Forward, Left Winger, Right Winger, Second Striker.
### 3.2.2 Whether he is a winger `winger`
![image](images/3.2.2%20Winger.png)
### 3.2.3 Height of the player `height`
![image](images/3.2.3%20Distribution%20of%20player's%20height.png)

Player height is relatively normally distributed among attackers in the sample, with most falling between 170 cm and 190 cm.

![image](images/3.2.3%20Boxplot%20of%player's%20height.png)

We removed 16 height outliers, resulting in the boxplot as shown.

![image](images/3.2.3%20Player%20Height%20by%20position.png)

Finally, we analysed the distribution based on each position group.
Height may play a more prominent role for Centre Forwards compared to other forward roles.

### 3.2.5 Age of the player `age`
![image](images/3.2.4%20Distribution%20of%20log_age.png)

![image](images/3.2.3%20Boxplot%20of%log_age.png)

### 3.2.5 Total number of days injured across the 2 seasons, `days_injured`
![image](images/3.2.5%20Distribution%20of%20Injuries%20in%the%20dataset.png)

![image](images/3.2.5%20Boxplot%20of%20log%20days%20injured.png)

### 3.2.6 Goals scored `totalgoals`
![image](images/3.2.6%20Histogram%20of%20totalgoals.png)

![image](images/3.2.6%20Boxplot%20of%20totalgoals.png)

![image](images/3.2.6%20Number%20of%20players%20by%20category.png)

### 3.2.7 Total Assists `totalassists`
![image](images/3.2.7%20Histogram%20of%20totalassists.png)

![image](images/3.2.7%20Number%20of%20players%20by%20category.png)
