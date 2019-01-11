#######################################################
#R workshop Day 1 morning session
#01/10/19
#######################################################

#setwd("~/MMac_R_projects/data_carpentry_2019_workshop")

#esc cancels incomplete commands

#storing vectors and using to perform operations
a<-1:5 #1 through 5, like in a data frame selecting c(1:5)
2^a

x<-1:4
y<-5:8
x+y

#for help do ?function or help(function), ??function searches R for help files
#vignette(package.name) gives you information on how to use this package in a pdf file

#other useful commands
ls() #lists all the objects in this session
rm("x") #removes only variable x
rm(list=ls()) #removes all objects

#installed.packages() #lists all your installed packages
#install.packages() #will install new packages (does not work if it need to be downloaded from Git like rstan)
#library(package) #load your package to use
#updata.packages(c()) #update all these packages


gapdata <- read.csv("~/MMac_R_projects/data_carpentry_2019_workshop/data/gapminder_data.csv")
gapwide <- read.csv("~/MMac_R_projects/data_carpentry_2019_workshop/data/gapminder_wide.csv")



# data structures_make a data frame with data about cats
{cats<-data.frame(coat=c("calico", "black", "tabby"), 
                 weight=c(2.1, 5.0, 3.2),
                 likes_string=c(1, 0, 1))}
#ways to look at data frame
cats
str(cats)
View(cats)
summary(cats)

#save data frame as csv file and read the csv
write.csv(cats, "data/feline_data.csv") #to put into the data folder in the working directory

cats<-read.csv("data/feline_data.csv")

weight<-cats$weight #view that column in the cats dataframe, and assign as an object
class(weight) #tells you what type of variable it is, this is numeric. can be factor or categorical

weight_in_lbs<-weight*2.2 #convert the weight to lbs
weight_in_lbs
cats$weight_in_lbs<-weight_in_lbs #put that new weight back into the cats data frame
View(cats) #check that it has now been added to cats dataframe

numeric_string<-as.numeric(cats$likes_string) #makes the data numeric (which it is not) just for sake of showing how
class(cats$likes_string)
as.factor(cats$likes_string) #makes it into factor variable (0 or 1), originally it was an integer

num_vector<-c(1, 3, 5)
character_vector<-c("a", "b", "c") #NOTE: you need quotation marks for this

character_vector_2<-c("d", "e", "f")

#combine character vector with 2
comb_vector<-c(character_vector, character_vector_2)
comb_vector

num_vector_2<-c(100, 10, 20)
num_vector + num_vector_2

#seq function gives sequence of integerd seq(10) is same as 1:10

seq(from=1, to=10, by=0.1)
my_example <- 5:8
names(my_example) <- c("a", "b", "c", "d")


v<-seq(1:26)
v*2
names(v)<-c(LETTERS) #names it a through z
v




###########################
#working with gap minder data file, already read in above
gapminder<-gapdata
library(gapminder)
View(gapminder)

str(gapminder)
nrow(gapminder) #number of rows
ncol(gapminder) #number of columns
dim(gapminder) # (number of rows and columns)

colnames(gapminder) #column names in the data frame



######## subsetting data (the old school way)
x<-c(5.4, 6.2, 7.1, 4.8, 7.5)
names(x)<-c("a", "b", "c","d", "e")
x[1] #tells you that the first element is a with value of 5.4
x[c(1, 3)] #returns the 1st and 3rd elements
x[-2] #removes the second element
x[-(2:4)] #removes elements 2 to 4


head(gapminder["pop"]) #looks only at the head of pop column in gapminder dataset
head(gapminder[,5]) #looks at the 5th column
gapminder[3,] #looks at the third row, all columns
gapminder[138,5] #5th column (life expectancy) on the 138th row
str(gapminder) #pop, life expectancy and gdp are the numeric variables
gapminder[1:6, c(3, 5, 6)] #take the first 6 rows of the columns that are numeric


df<-gapminder[1:12,]
df$gdp<-df$pop*df$gdpPercap
write.csv("data/results.csv")
df


##############################################################################################################

#DAY 2- Graphing in R, manipulating data

##############################################################################################################

#graphing in R

head(gapminder) #check that data is still loaded from yesterday
dim(gapminder) #all good

#load necessary packages
{library(ggplot2)
library(knitr)
library(dplyr)
library(tidyr)}


ggplot (data=gapminder, aes(x = gdpPercap, y=lifeExp, 
                            by = country)) + #aes for defining variables, can also split up by color here
  geom_line(aes (color = continent)) + #now only line is colored by continent not the point
  geom_point(aes (color= "blue")) 
  


ggplot (data=gapminder, aes(x = gdpPercap, y=lifeExp, 
                            color=continent)) + #aes for defining variables, can also split up by color here
  geom_point(alpha=0.5, size=1.75, aes(shape = continent), show.legend = FALSE) +  # alpha changes the transparency of the points, adjusts size of those points, makes different shape for each continent
  scale_x_log10() + #gives x axis a log scale
  geom_smooth(method = "lm", size = 1.5, show.legend = FALSE)  #adds regression line with linear model, adjust size of that line

#can add show.legend false to both line and the point to remove it completely



ggplot (data=gapminder, aes (x=year, y=lifeExp))+
  geom_point() +
  theme_bw() #eliminate the grey background


#cleaning up your plot
ggplot (data=gapminder, aes(x = gdpPercap, y=lifeExp, 
                            color=continent)) + #aes for defining variables, can also split up by color here
  geom_point(alpha=0.5, size=2, aes(shape = continent)) +  # alpha changes the transparency of the points, adjusts size of those points, makes different shape for each continent
  scale_x_log10() + #gives x axis a log scale
  geom_smooth(method = "lm") + #adds regression line with linear model, adjust size of that line
  scale_y_continuous(limits = c(0,100) , breaks=seq(0,100, by=10)) + #y axis is 0 to 100 and tic mark every 10 
  theme_bw() +
  ggtitle("Effects of per-capita GDP on Life Expectancy") + #never really use titles for pub but oh well
  labs(x="GDP per Capita ($)", y="Life Expectancy (years)")
#ggsave(file= "example_plot.png", dpi=300, width= 20, height=20, units="cm") or.pdf, will save to directory 


ggplot (data=gapminder, aes(x = continent, y=lifeExp) ) +
  geom_boxplot()+
  geom_jitter(alpha=0.5, color="tomato") +
  theme_bw() +
  labs(x="Continent", y="Life Expectancy")




####################################################################################################

#2nd section, day 2 morning, programming in R

####################################################################################################


#conditional statements

number<- 37
if (number>100) {
  print ("greater than 100")
} else {
  print ("less than or equal to 100")
}

#other operators, <, ==, != (not equal to)

number <- -3

if (number>0) {
  print (1)
} else if (number<0) {
  print (-1)
} else {
  print (0)
}

number<-46
if (number >= 45 & number <= 50) {
  print("Between 45 and 50")
} #returns when number is between 45 and 50


number1<--15
number2<-40

if (number1 >= 0 & number2 >= 0) {
  print ("both numbers are positive")
} else { 
  print ("at least one number was negative")
  }


#running loops

numbers <- 1:10
for (number in numbers) {
  print(number)
}

for (i in numbers) {
  print (i)
}

letter <- "z"
print(letter)

for (letter in c("a", "b", "c")){
  print(letter)
}

#to sum the numbers and to print at the end
numbers <- c(4, 8, 15, 16, 23, 42)
sum_num<-0

for (i in numbers){
  (sum_num<-sum_num + i) #need to overwrite the old sum_num each time or sum_num will just end up equalling whatever i is
}

print(sum_num)


sum(numbers) #108 is correct


##########################
#write a function
##########################

#write a function that coverts farenheit to kelvin
#we give function temp, we do some calculation and assign to kelvin, then return that kelvin
fahr_to_kelvin <- function(temp) {
  kelvin <- ((temp-32) * (5/9)) + 273.15
  return(kelvin)
}

freezing_point<-fahr_to_kelvin(32)

#function to convert to celsius
kelvin_to_celsius <- function(temp){
  celsius <-temp -273.15
  return(celsius)
}

abs_zero<-kelvin_to_celsius(0)
abs_zero


# Function to convert fahrenheit to kelvin
fahr_to_kelvin <- function(temp) {
  temp <- ((temp - 32) * (5 / 9)) + 273.15
  return(temp)
}

# Store the current temperature in F
temp <- 73

# Get the temperature in kelvin
kelvin_temp <- fahr_to_kelvin(temp)

# Print the temperature
print(kelvin_temp)

T_celsius <-0

#temperature in Celsius to Fahrenheit
C_to_F<-function(T_celsius) {
  T_Farenh <- ((T_celsius * (9/5)) + 32 )
  return(T_Farenh)
}

C_to_F(T_celsius)
#using the formula: F = C * 9 / 5 + 32



########################################################################################################

########   AFTERNOON DAY 2 SESSION  ########

########################################################################################################

{library(rmarkdown)
library(formatR)
library(tidyr)
library(dplyr)
library(knitr)}


# see the notebook R markdown where we did the work and took notes on dplyr and tidyr to rearrange and subset data
# "dplyr_tidyr_notebook"



















