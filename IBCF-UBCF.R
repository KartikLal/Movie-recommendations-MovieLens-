########################################### IBCF #############################################

genre_list <- movies %>% 
  cSplit('genres', '|', 'long') %>% 
  select(genres) %>% 
  distinct(genres)

movies_new <- movies[!duplicated(movies$title),]
userList <- ratings %>% select(userId) %>%  
  unique() %>% head(10000)

movies_split <- movies_new %>% 
  cSplit('genres', '|', 'long') 

ratingsMovies <- 
  userList %>% inner_join(ratings) %>%
  left_join(movies_split) 

cf_matrix<- ratingsMovies %>%   
  #filter(genres == "Thriller") %>% 
  select('userId','title','rating') %>% 
  cast_dtm(userId,title,rating)


ibcf_matrix <- cf_matrix %>% 
  as.matrix() %>% 
  as.data.frame()

cor_values<-ibcf_matrix%>% 
  cor(ibcf_matrix[,c('Sudden Death (1995)','Young Guns (1988)','Inside (1996)')],use="pairwise.complete.obs") 
print(typeof(cor_values))
typeof(final_matrix)
final_matrix <-tibble(a=colnames(ibcf_matrix), b=cor_values)
typeof(result)
result<-final_matrix %>% 
  filter(!(a %in% c('Sudden Death (1995)','Young Guns (1988)','Inside (1996)'))) 
typeof(ibcf_output)
ibcf_output<-tibble(title = result$a,sum = result$b %>% as.data.frame() %>% 
                      mutate(sum = V1+V2+V3) %>% 
                      select(sum) %>% 
                      arrange(desc(sum))) %>% 
  select(title) %>% 
  rename(Movie = title) %>% 
  head(10)

########################################### UBCF #############################################

ubcfMatrix <- t(ibcf_matrix)

cor_values_ubcf<-ubcfMatrix %>% 
  cor(ubcfMatrix[,1],use="pairwise.complete.obs") 

final_matrixUBCF <-tibble(colnames(ubcfMatrix),cor_values) %>% 
  rename("userId"=`colnames(ubcfMatrix)`)

### Select the 4 most similar users
ubcfSelectUsers <- 
  final_matrixUBCF[order(-cor_values),] %>% head(4)

### Add userId as a column
tempUsers <- cbind(userId= rownames(ibcf_matrix),ibcf_matrix)

### Random Error- May fail later
tempUsers <- tempUsers[,-c(2886)]

### Join with IBCF
tempUserSelectIbcf <- tempUsers %>%
  filter(userId %in% ubcfSelectUsers$userId)

### Add userId as the rownames
rownames(tempUserSelectIbcf) <- tempUserSelectIbcf$userId 

### Transpose and add movies as a column
tempTransposeUserIbcf <- tempUserSelectIbcf %>% select(-c(userId)) %>% t()

MoviesSimilarUsers <- cbind(title= rownames(tempTransposeUserIbcf),tempTransposeUserIbcf)

MoviesSimilarUsers <- MoviesSimilarUsers %>% as.data.frame()

### Select those movies which have not been seen by the selected user and 
### seen by atleast one of the similar users

MoviesRecommendUbcf <- MoviesSimilarUsers %>% 
  filter(`1` == 0, MoviesSimilarUsers[,3]!=0 | MoviesSimilarUsers[,4]!=0 |
           MoviesSimilarUsers[,5]!=0)

### Add their ratings, and take the top 10 movies as per the ratings' sum

MoviesRecommend <- MoviesRecommendUbcf %>% 
  mutate(movieScore = as.numeric(levels(MoviesRecommendUbcf[,3])[MoviesRecommendUbcf[,3]]) +
           as.numeric(levels(MoviesRecommendUbcf[,4])[MoviesRecommendUbcf[,4]])+
           as.numeric(levels(MoviesRecommendUbcf[,5])[MoviesRecommendUbcf[,5]])) %>%
  arrange(desc(movieScore)) %>% head(10) %>% rename(`Movie`= title) %>%
  select(`Movie`)

################################### Evaluate Metrics ##############################

