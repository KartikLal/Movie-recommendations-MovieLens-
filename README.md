# Movie Recommendation System

Dataset: MovieLens (https://grouplens.org/datasets/movielens/)

The objective is to recommend movies to users at two levels: 
	- First, based on their past rating history (user based collaborative filtering)
	- Second, based on impromptu genre-movie selections (Item based collaborative filtering)
The first prediction model would take into consideration the rating history of all customers, 
and having understood the watching patterns of similar users, recommend the user a movie 
he/she may be interested in. 
The second model would take genre as input and 3 movies he/she likes in that genre, thereafter 
recommend movies like the movies in the selected genre.

### Prerequisites

The project code was written in R, built in R Studio. It requires the following softwares and R packages:
1. ggplot2
2. tidyverse
3. dplyr
4. splitstackshape
5. dummies
6. tidytext
7. stringr
8. shiny
9. shinydashboard
10. DT
11. shinyWidgets
12. shinythemes


### Methodology

#### Item based collaborative filtering

Item-based collaborative filtering is a model-based collaborative filtering algorithm for producing predictions for users. It looks for items that are like the articles that the user has already rated and recommend most similar articles. 
In this case, IBCF looks at correlation between various movies in terms of user ratings, which decides the similarity between them. For example, if 2 movies are rated similarly by users, they can be classified as similar
The detailed algorithm is mentioned in the report (Report- Movie Recommendation System.docx).


#### User based collaborative filtering

User-based collaborative filtering is a memory-based collaborative filtering algorithm that looks at the entire dataset to find similar entities or users and recommends articles or movies liked by similar users. 
In this case, UBCF looks at correlation between users. For example, if 2 users have rated the movies in a similar way, we can say that the users are similar. 
The detailed algorithm is mentioned in the report.


This is followed by the #####R Shiny Dashboard

