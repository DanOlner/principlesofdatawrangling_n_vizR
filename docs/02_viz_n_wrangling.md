



# DATA WRANGLING & VISUALISATION

## The first principle of data visualisation...

The first principle of data visualisation is: **shaping the data is an essential part of building visualisations**. It's not just an annoyance: your visualisation goals will dictate the kind of shape the data needs to be made into.

We'll use libraries from the **tidyverse** to do this. As [Hadley Wickham says](https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html), 'by constraining your options, it simplifies how you can think about common data manipulation tasks'.

We'll be looking at **two cheatsheets** as guides to the two main libraries we will use: **ggplot** and **dplyr**. These two are the [yin and yang](https://en.wikipedia.org/wiki/Yin_and_yang) of data visualisation in R. With **dplyr**, we'll shape and squeeze our data into the right form to visualise what we want in **ggplot**.

We're obviously not going to try and look at everything on these sheets. We'll pick out a small number of examples to illustrate the underlying principles, with the hope that **by the end of the course, you should have enough of an understanding of them to carry on your learning from them.**

You've got copies of each of the cheat sheets. If you need them in future, they're both available via **RStudio's help menu** (or search for them online).


*****

This part of the course is split roughly into two:

1. **We'll learn some of the essential concepts of data wrangling in preparation for visualising** by **walking through a few typical script creation scenarios**: getting our data, processing it, deciding what we want to do with it to prepare for visualising.

> **For this part of the course, I'll be working through the material with you step by step, carrying out exactly the same tasks.** Things will doubtless go wrong, often just misplaced brackets and the like - **please ask if you're stuck.** 

2. The **second part** will be more free-form. There are **a range of choices** for you to play with. You'll get to work through whichever you like, with help on hand (and you'll get a break from me talking the whole time.) **If there's anything else you want to have a go at, let me know and I'll try to help.**

*****

**We're going to try and fit a lot into one course: don't worry too much if not all of it makes sense** as long as the overall picture you get *does* make sense. I'll try and make sure that everyone knows which bits they *really* need to have taken in.

**We'll only scratch the surface of what R and the tidyverse can do.** But it should be a solid foundation for further exploration.

**We'll check in after every chunk of work** to make sure everyone's OK with where we've got to. Each part of the course builds on the other - it's important that you feel like it's making enough sense that you don't get lost as we move on. **Please do ask if anything is confusing. Any new programming concepts, even for experienced programmers is always confusing.** I learned Java before R: that didn't stop R being baffling for a long while.

*****

> **Our data for the course: *Land registry data on house prices in England*. (We'll also look at some other data and link it.)**

> **All of the data for the workshop is open access**: you can download it yourself for free. I've provided links and notes at the end of this document for that.

> **Our guiding question for digging into the data will be simple: can we see what impact the 2007/8 financial crash had on the English housing market?** We won't be using any sophisticated methods - the plan is just to see what visualising the data might show us.

*****

Some random tips before we get started properly:

* I'd recommend typing out as many of the R commands we'll be working with where you can in the first part of the course - **it's by far the best way to learn and understand the code**. But if you get bored of that, or for some of the larger chunks of code later, feel free to use any of the code sources I've supplied. **The digital PDF and webpage also have links** to the topics we're covering, if you want to look at any of those during the course.

* **Learning some keyboard shortcuts helps massively**. You don't have to use them but, once learned, they're hugely useful in R-Studio. I'll explain them as we go along. I've also included a **keyboard shortcut sheet** for the ones you might want to use.

* Oh and... **what's data wrangling?** I [refer you to Wikipedia](https://en.wikipedia.org/wiki/Data_wrangling). Really, it just means re-arranging data until it's the shape we need. It has its own word now because **we spend far more time doing this re-arranging than actual analysis.**

Right! --->

******

## Getting started

OK, let's start by **sorting out our project folder** so we can access the data we're all going to be working from. We'll first need to **copy the data folder to our own machines**. Once you've done that, I'd recommend **making it a new RStudio project** via the top right button:

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-2-1.png" width="768" />

Navigate to your copied files and make a new project there. **We can now access all the files and save our R script and visualisations here**. Once you're done, you can copy all this over to your USB stick or keep on your own drive.

So now: **create a new R script for your programming and we can begin.** Either use the menu (**file/new**) or the shortcut **CTRL+SHIFT+N**.

*****

## Loading the libraries

Many of the most important **tidyverse** libraries are packaged into one - including **ggplot** and **dplyr**, the two we'll be using most heavily. We'll start our script by loading this library. **Stick this, and any later library loads, right at the top of your script:**


```r
library(tidyverse)
```

When it loads, you'll see the many different libraries that come in the tidyverse displayed in the console.

If the library isn't yet installed, you'll get an error. You'll need to install it first. Because this only needs doing once, it's best to do it in the console. If you discover any other libraries we use in the course are not yet installed, it's same procedure. 

> Note: **when installing, the library name needs to be in quote marks**. But it's **not in quote marks when we actually load the library.**


```r
install.packages('tidyverse')
```


## Loading the house price data

**OK, let's get stuck in to the data we're going to use.** You can use the **file** pane, bottom-right, to have a look at the files. **Click on the 'data' folder**: as well as the little example dataframe we just looked at, this folder contains the following file:

* **landRegistryPricePaidTopTTWAs.rds**: a selection of England's ten largest cities (by count of sales).
    
**It is in RDS format**: these are compressed R objects - they're much smaller files than CSVs would be.

> Let's load the data. Try a hugely useful autocomplete feature: when typing the file name, get 'data/land' typed and then **press CTRL + SPACE**: this should list file names in the data directory. We're after this one:


```r
sales <- readRDS('data/landRegistryPricePaidTopTTWAs.rds')
```

The **head** function will show the top few rows ...


```r
head(sales)
```

... and will look something like this:

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-7-1.png" width="768" />

Each row is a **single property sale**. As you can see, the data has **eleven columns** with the following variables:

* **price**: the final sale value of the property
* **date**: when it was sold, to the day. This field is in a format that R knows is a date.
* **postcode**: the location of the property being sold
* **type**: whether the property is a **detached house (D)**, a **semi-detached house (S)**, a **terraced house (T)** or a **flat (F)**.

Those four are all from the Land Registry data. Then we also have some extra **location information**:

* **Eastings and Northings**: these two columns give the exact geographical location for the postcode. (Its centroid.)
* **wardcode**: these are codes for the **English ward** the sale is in. There are many of these for each city and town.
* **ttwa** and **ttwa_code**: these are the **travel to work area** the sale is in. TTWAs are designed to capture each commuting area, so cities and towns will usually be at the centre of them.
* **localauthority** and **localauthoritycode**: we'll use this later to match to wage data and work out a consistent house price metric.

Checking what time period the data covers with the **range function**, we can see we've got house sales from 1995 up until mid-June this year (2017) - we've got a bit more than two decades worth:


```r
range(sales$date)
```

```
## [1] "1995-01-01 UTC" "2018-12-23 UTC"
```

> TIP! If you need to read data in from a flat file like a comma-separated variable file, use the **readr** package from the tidyverse. **We'll be using this later.** Base R reads csvs in with **read.csv()**. readr uses **read_csv** - using an underscore not a dot. Why use **readr?** It takes care of several otherwise annoying data format issues - most usefully for us, if you have dates in there, it makes them ready to be used straight away.

We'll get to know the geographies better as we visualise them. But first...

*****

## Let's jump right into ggplot 

We can start making some **ggplots** immediately: **these won't be pretty, but we can use them to illustrate the basics of how *ggplot* works, step by step.**

You should have **ggplot already loaded** as part of the tidyverse.

> All we'll do to start with: **plot the locations of some of the sales, so we can see what the overall geographical reach of the data is.**

As you can see from the environment pane, there are **several million sales** in the data (one sale per row). That would take a long time to plot, so we're just going to **take a smaller sample using dplyr's sample_n function**. This takes a random sample of rows from the dataframe. We'll store the sample in a new variable. Here, we're just getting ten thousand rows / sales.


```r
saleSample <- sample_n(sales,10000)
```

> Let's plot our sample of sales using ggplot. **Get this coded first, then we'll talk through what we just did.**

> Another new thing to note here: the second line follows a plus at the end of the first. **If you type the plus then press enter, RStudio will automatically indent the next line for you**. ggplot is fussy about this plus - it needs to be **at the end of the line**, it can't be at the beginning of the next one:


```r
ggplot(saleSample, aes(x = Eastings, y = Northings)) +
  geom_point()
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-10-1.png" width="595.2" />

So we can see house sales in different locations across England. But how did that work? Take a look at the cheatsheet: **basics** on page one has a little template explaining what ggplot **requires** to plot. It needs just the **three things we supplied**:

* **The data.** In this case, saleSample. That goes first.
* **The mapping.** This is done in the **aesthetic function**. (That's what **aes** is short for.) In **aes**, we **map** our variables to the graphics' aesthetics.
  + **The important principle here: *each mapping requires a single column of data.* This one requirement dictates how we must shape our data for ggplot.** This is so important we'll go over it again in a moment!
  + Here, we've mapped two variables to the *x and y aesthetics* (which we'd usually think of as just a graph's x and y axes) - but there are bunch of others. More on that next.
* **the geometry.** Again, look at your cheat sheet, page 1. Almost all of the first page **gives you all the different geometries ggplot can use**. We used **geom_point** so that x and y are mapped to points.
* You can also get a quick guide to the geoms using RStudio's autocomplete. This will list them all and give a little help overview. 

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-11-1.png" width="360" />

As with all other functions, for the full help page, use e.g.:


```r
?geom_point
```

> While we're here: **try the zoom button and export button above the plot. Each of the options will give you a pop-out version of the plot that can be re-sized with the corner handle. It can then either be saved or copied to the clipboard. We'll look at how to save the plot programmatically shortly.**

*****

> If you look at geom_point on the cheatsheet, you'll see this list: 'alpha, colour, fill, shape, size, stroke'. **This is the list of other aesthetics you can map variables to when you're using the point geometry.** This list differs depending on what you use - **the cheatsheet tells you which you can use for each geometry type**. 

These mappings all happen in the **aes** function, same as we did for x and y. So, for example, we can map colours to the TTWA / city. 


```r
ggplot(saleSample, aes(x = Eastings, y = Northings, colour = ttwa)) +
  geom_point()
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-13-1.png" width="595.2" />

This is not a good map! But it illustrates how **aes** works. There are a few other new things here.

* the **ttwa** variable is **discrete**: it's a list of different places. **ggplot** figures this out and assigns one colour per category. We'll look at what happens with continuous variables below.

* **ggplot** has also **automatically added a legend**. 

So back to the most important principle: **ggplot wants each variable in its own column, in `long form'.** This applies to each variable you map to an aesthetic. 

Here's a little illustration to help with the intuition. If we've mapped **ttwa** to the **colour aesthetic** then**ggplot** will **work out how to map a colour** to each discrete group within that variable. If the variable had been continuous, **ggplot** would have supplied a continuous scale.

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-14-1.png" width="360" />

Later, we'll look at what to do if your data isn't already in long form.

*****

You can of course choose what values to assign to x and y. And notice **what happens if you assign a discrete variable** to one of the axes. Here we put **property sale price on y and ttwa on x:**


```r
ggplot(saleSample, aes(x = ttwa, y = price)) +
  geom_point()
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-15-1.png" width="595.2" />

Again - **ggplot** knows it's discrete and labels each place. **The plot itself is, again, fairly awful: overlapping points and labels, poor axis ticks etc**. We'll come back to all the prettifying things like labelling later, but let's stick to the essentials for now.

*****








So if we want to know something about the impact of the crash, we'll need to start using dates. But using them raw isn't a great idea:


```r
ggplot(saleSample, aes(x = date, y = price)) +
  geom_point() 
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-16-1.png" width="595.2" />

**ggplot** can plot dates correctly and provides axis ticks - but using each day is far too messy. We need to do two things to fix this:

1. **Create a better date category - we'll break the data down by year.**4
2. **Summarise the housing data based on this.**

There are two ways to summarise data for **ggplot**: 

* **ggplot**'s own **stat** functions (more on these after the next section...)
* **Wrangling into the right shape ourselves** using **dplyr** and other R functions. While rather more work, this is the only way to fully control what you want to visualise. **Learning about wrangling and dplyr will be a big chunk of the course.**

First-up though: **making a useable date column.**

*****

## The lubridate library

> **Time for another library: lubridate**. As you'd expect, this makes working with dates a lot easier. Put this library call with the others at the top of the script.



```r
library(lubridate)
```

Again, if it's not already installed, do so in the console:


```r
install.packages('lubridate')
```



The **date** column in the original data is already in ***datetime* format. This is handy: formatting this ourselves is a faff.** (See the tip above about using **readr** to make sure dates load in this format.) It means that we can now use the **lubridate** library to add a column containing the **year** of the property sale:


```r
sales$year <- year(sales$date)
```

If you go back to your dataframe view tab or use the console, you'll see it's been added:

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-20-1.png" width="360" />

We can use the **table** function to get a quick look at the result, counting the number of sales per year:


```r
table(sales$year)
```

You can also get sales per year by type:


```r
table(sales$year, sales$type)
```


*******

## Using ggplot's own stat functions

Now there's a year column, we can start **summarising the data for each year.** Going back to the original question - what impact did the 2007/8 crash have on the housing market - we can start by asking:

> **What happened to the number of sales?** To find this out, we can just **count the number of sales per year.**

As mentioned, one way to do this is to **use ggplot's own summarising functions**. These can be a really useful way to quickly get an overview of the data.

For the plots done so far, all mappings have taken the variable's value and **mapped it directly to a value on the graph.** Instead, **ggplot** stats create a **summary variable first** and then plot it. 

This makes more sense when seen in practice. Here's a simple bar chart: all it's doing is **counting the number of sales in each year**:


```r
ggplot(sales, aes(x = year)) +
  geom_bar()
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-23-1.png" width="595.2" />

So it looks like, for these TTWAs, **the number of sales halved after the crash** and never recovered. As before, we can assign the TTWA to the bar colour - though this time it's **fill** ('colour' is the bar outline). London has vastly more sales per year than any other TTWA. 


```r
ggplot(sales, aes(x = year, fill = ttwa)) +
  geom_bar()
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-24-1.png" width="595.2" />

There are a few principles going on here:

1. **ggplot will use defaults where it can.** In this case, we've **not included a y-axis variable mapping in aes** because **the stat in geom_bar counts the number of observations in each year** and so doesn't need it. Indeed, if you try and give it a y variable, it will throw an error:


```r
ggplot(sales, aes(x = year, y = price, fill = ttwa)) +
  geom_bar()
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-26-1.png" width="576" />

2. Some geometries use **ggplot stats**, others will plot your data directly. How to tell the difference?
  + You'll become familiar with the ones used for summary stats - on the cheatsheet, a lot of them are under **one variable**, **discrete x, continuous y** and **continuous bivariate distribution**. We'll cover some more in a moment.
  + **But there's a principle at work: every geom has a stat**. It's just that some have **stat = "identity"**, telling them to plot the data directly. Take a look at the help for **geom_bar**:
  

```r
?geom_bar
```

The **stat** argument is actually telling the **geom** to use a specific **stat** function: **these are all listed in the left bar of page 2 of the cheatsheet**. In the help file for **geom_bar**, its stat function is also there: **stat_count**. These can actually be used interchangeably. Note that **stat_count's default geom is "bar"**:


```r
ggplot(sales, aes(x = year, fill = ttwa)) +
  stat_count()
```


Under **usage**, the help page lists all of **geom_bar's** arguments: the ones given here **are its defaults**. These are the two most important:

* **stat = "count":** tells geom_bar to count observations in each group
* **position = "stack":** if there are groups, this tells geom_bar to stack them on top of each other. **The cheatsheet lists these on page 2**. We can **override the default simply.** For example, telling geom_bar to find the *proportion* of sales in each year by filling from top to bottom:


```r
ggplot(sales, aes(x = year, fill = ttwa)) +
  geom_bar(position = 'fill')
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-29-1.png" width="595.2" />

In comparison, look again at the help for **geom_point**, that we used to begin with:


```r
?geom_point
```

Its **default stat is "identity"**: this mean it maps data points directly to the aesthetic.

Another principle here:

3. We've said that **ggplot** will attempt to plot your data if it can, but **certain geometries require certain types of data**. As with **geom_bar** - it requires a categorical x variable, in this case we've given it each year.

If we'd wanted to plot a **continuous x variable** as a bar chart, there's one under 'one variable continuous' on the cheat sheet. So say we wanted to use **date** directly, **geom_histogram** will put them into equal sized bins:


```r
ggplot(sales, aes(x = date)) +
  geom_histogram()
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-31-1.png" width="595.2" />

> **There are a lot of different stat functions, each with their own default geoms.** When first learning **ggplot**, it's just a matter of getting to know them through use. **ggplot's help** is really helpful! It'll help for working out what default stats each of them uses.

We'll come back to one or two of these later. For now, on to **using dplyr** to shape data for visualising:

*****







## Getting started with **dplyr** and **piping**

We're going to be mainly using **dplyr** to reshape our data into different forms for the visualisations. (We've already loaded this library as part of the **tidyverse** package.) 

Before we get to **dplyr** itself - Piping! 

> **Piping is *magic*: it will make everything spectacularly easier and tidier.** 

> Specifically, this is **the pipe operator**. It loads with **dplyr** and looks like this: 

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-32-1.png" width="192" />

A quick recap: **pretty much everything in R is a function**. For example, to find the square root of a number, use the **sqrt** function:


```r
sqrt(100)
```

```
## [1] 10
```

Functions can nest in functions. If, for some reason, you wanted to find the base 10 log of the square root of 100, you could nest like this:


```r
log10(sqrt(100))
```

```
## [1] 1
```

And so on, if you had more complex things to accomplish. **The pipe operator makes this much more intuitive and readable**. So instead of the above, we can do this:


```r
100 %>% sqrt()
```

```
## [1] 10
```

```r
100 %>% sqrt() %>% log10()
```

```
## [1] 1
```

So what we're doing here: **piping the result from one function into the next until we get the output we're after**. The number 100 is **piped** into the **sqrt** function - the output from that function (10) is **piped** into the **log** function.

The power of this is: 

* It lets us create a conveyor belt for what we do with data in a way that can very easily be changed at any stage in the process.
* **dplyr** is designed with this in mind.


******
> **As with the assignment operator, typing percent-more-than-percent every time you want the pipe operator is a pain: so RStudio has another shortcut key.**

> **This time it's: CTRL + SHIFT + M. Try this in the next bit of coding.**

> **This is also on your one page shortcut key guide.**

******

## **dplyr**'s verbs

We can use the **pipe operator** to link **dplyr verbs** together - these are **functions that reshape the data in various useful ways**. We'll go through them one by one and end with a **ggplot**.

Let's start by **finding a summary statistic**. We'll find the average price in the housing data.

> **It's good practice to have each dplyr verb on its own line. Notice how RStudio helps with this too: pressing return at the end of one line, after the pipe, automatically indents the next line. We'll do the same with ggplot in the next section.**



```r
sales %>% 
  summarise(mean(price))
```

```
## # A tibble: 1 x 1
##   `mean(price)`
##           <dbl>
## 1       225522.
```

******

> ***Verb 1: summarise*. This passes all values from the column name you pass - in this case price - and we tell it to find the mean. It then gives you a *single row back* with the summary in.**

******

Notice here: **dplyr** (like almost all **tidyverse** functions) takes in **bare variable names.** It knows the variable is from **sales** as we've just piped that in.

But that's the average price for the whole time range - **what about one year?** 

******

> ***Verb 2: filter*. We can filter by year. So we've now got *two* pipe operators:**

******


```r
sales %>% 
  filter(year == 2018) %>% 
  summarise(mean(price))
```

```
## # A tibble: 1 x 1
##   `mean(price)`
##           <dbl>
## 1       390511.
```

The **filter** verb uses **logical operators** to query each row in the data. The full list of these **is on the data wrangling cheatsheet**. Here they are again:

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-38-1.png" width="240" />

Note especially the **double equals** we just used: this allows us to find exact matches for values and text (in this case, matching to 2015).

**A quick reminder of how R uses logical operators to create TRUE/FALSE vectors**. (TRUE/FALSE values are also known as **boolean** values.) Here's an illustration of two logical operators checking their condition against each row of the chosen variable:

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-39-1.png" width="384" />



So all **filter** does is take in a vector like this ... 


```r
ttwa=='Bradford'
```

```
##  [1] FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE
```

... and then use that to **keep the TRUE values**. This is worth repeating, as once that's clear, you can produce **any kind of boolean vector you like** to filter the data. More on this shortly.



So: **filter** picked out one particular year. But what if we want average price **for each year?**

*****

> ***Verb 3: group_by*. This will *group the data by the category or categories we give it*. The next function will then *apply to each group.* You'll get one row per group with the mean in:**

*****


```r
sales %>% 
  group_by(year) %>% 
  summarise(mean(price))
```

```
## # A tibble: 24 x 2
##     year `mean(price)`
##    <dbl>         <dbl>
##  1  1995        79425.
##  2  1996        84693.
##  3  1997        94675.
##  4  1998       104499.
##  5  1999       120137.
##  6  2000       137448.
##  7  2001       151563.
##  8  2002       173274.
##  9  2003       188621.
## 10  2004       212300.
## # ... with 14 more rows
```

That's given us average price per year - but has just showed some of them in the console. **To be able to work with this returned dataframe, we need to assign it to a variable name:**



```r
saleSummary <- sales %>% 
  group_by(year) %>% 
  summarise(mean(price))
```

You'll see **saleSummary** has appeared in the environment pane: **click on it to view the new summary data.**

**************

One more thing before making another graph: if we want to find out average price per year **and per city/ttwa**, just include both in the **group_by** function.

We'll add one more thing here too. **dplyr** defaults the summary variable name to **mean(price)** - but we can **set the name ourselves in summarise** if we want something more sensible:


```r
saleSummary <- sales %>% 
  group_by(ttwa,year) %>% 
  summarise(meanPrice = mean(price))
```

```
## `summarise()` has grouped output by 'ttwa'. You can override using the `.groups` argument.
```

saleSummary now has **one column each for ttwa and year in long format**, each with a price average. **Which is exactly what we need to map each of those to aesthetics in ggplot.**

Note also: an advantage of this separate-line approach to coding is: it's easy to try different things, keep them and comment them out. So for instance, for the previous code, we could have kept the **filter** verb in place in case we wanted to come back to it:


```r
saleSummary <- sales %>% 
  #filter(year == 2018) %>% 
  group_by(ttwa,year) %>% 
  summarise(meanPrice = mean(price))
```

*****

**This can now go straight into ggplot:**


```r
ggplot(saleSummary, aes(x = year, y = meanPrice, colour = ttwa)) +
  geom_point()
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-47-1.png" width="595.2" />



## And a few extras while we're here... 

There are a number of other **dplyr** verbs and we'll cover some of them below, but for now, let's just make some additions to what we've done, to introduce some new ideas.




1. **Using another geometry**

First: **we can use a different geometry** - we don't have to stick to points. With data over time, it makes sense to link time points with a **line**. As you might guess, the **geom_line** geometry will do this. Comment out **geom_point** for now and add it:


```r
ggplot(saleSummary, aes(x = year, y = meanPrice, colour = ttwa)) +
  geom_line()
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-48-1.png" width="595.2" />

```r
  #geom_point()
```




2. **Layering geometries**

You're not limited to one geometry: **you can layer them.** So if we just **un-comment geom_point** (and make sure **there's a plus** at the end of geom_line):


```r
ggplot(saleSummary, aes(x = year, y = meanPrice, colour = ttwa)) +
  geom_line() +
  geom_point()
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-49-1.png" width="595.2" />

Note that our **aesthetic mapping of colour to TTWA has applied to both lines and points.** More on that shortly.

What if we want **geom_point** to represent something different? Well...





3. **Summarising for more than one variable**

Say we want to show the **number of sales for each TTWA in each year**. The first thing to do is **count the sales via dplyr's summarise**. This requires an update to our previous **dplyr** code - **just add another summary variable to the summarise function:**


```r
saleSummary <- sales %>% 
  group_by(ttwa,year) %>% 
  summarise(meanPrice = mean(price), countOfSales = n())
```

```
## `summarise()` has grouped output by 'ttwa'. You can override using the `.groups` argument.
```

You'll see we now have **countOfSales** as well as **meanPrice**:

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-51-1.png" width="384" />

**What does n() do?** It's **dplyr** shorthand for 'number of observations': if we've grouped the data, **it will give us the number of observations per group**. (You can see this and other **summarise** functions on page 2 of the **dplyr** cheatsheet.)

> **Now we have a count of sales, we can use this directly in *geom_point*.** This is done by **using  the aes function in the geometry itself:**


```r
ggplot(saleSummary, aes(x = year, y = meanPrice, colour = ttwa)) +
  geom_line() +
  geom_point(aes(size = countOfSales))
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-52-1.png" width="595.2" />

The **size of the points** now represents **count of sales**. **ggplot** gives it its own legend.

Two things to note here:

* If you've mapped an aesthetic in the top **ggplot** function **it will cascade to all other geometries.** However, we can **over-ride this within those geometries using their own aes function.**
* **The order of geometries determines which draws first.** This can be used to control the look. We'll do that next.




4. **The order of drawing and deciding where to map aesthetics**

Say we don't want colour to be mapped to both points and lines. There are a couple of options - one (the most flexible) is to **overwrite the colour mapping in geom_point** by **choosing our own colour directly**. 

* We do this by setting the points' colour **outside of aes** to what we want. We're not mapping to any variable this time, just setting it to a single value. There are a **list of named colours we can use**, including 'grey' (more on this list below):


```r
ggplot(saleSummary, aes(x = year, y = meanPrice, colour = ttwa)) +
  geom_line() +
  geom_point(aes(size = countOfSales), colour = 'grey')
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-53-1.png" width="595.2" />

The general principle here:

1. **Each list of aesthetics under the geometries on the cheatsheet can be *either* mapped to a variable (by including them in the *aes* function ) *or* set directly to a single type.**
2. Setting these within a **geom** has the effect of **over-riding** the cascading value.

******

In this graph, **points are drawn over the lines.** This might look better if they were under them. **To do this, just change the order.** Having everything on separate lines makes this a little easier, though **be careful to make sure pluses are in the right place**. 

Also: **remember you can use ALT + up/down arrows to move lines of code.** So, shifting **geom_point** behind **geom_line** (and remembering to shift the **plus** as well...):


```r
ggplot(saleSummary, aes(x = year, y = meanPrice, colour = ttwa)) +
  geom_point(aes(size = countOfSales), colour = 'grey') +
  geom_line() # <<< moved this down one line and moved the plus too
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-54-1.png" width="595.2" />

*****

## Using scales to control appearance

The last graph was getting there: it's possible to see that **prices were rising up until the crash** - we'll need some more tweaks to properly compare places with different average house prices.

(The count of sales isn't the clearest way to show that the rate dropped - our earlier **geom_bar** did that better, but it illustrates using two geoms.)

It would be good to change a few things to make this more clear. One of the most essential ways of controlling appearance is through **scales**. The principle here is:

> **Every aesthetic mapping has its own scale. Each of these can be controlled.**

This is true for the **x and y mappings** as well as everything else, including the **colour, fill and size mappings we've used so far.**

The basics are:

* **All scales are controlled using functions that begin with scale_. Page 2 of the ggplot cheatsheet lists them.**
* As the cheatsheet shows, the format is (for example) **scale_*_continuous** - replacing the asterisk with the mapping we want to control.

The most obvious kind of scale control you'll want to do is **on the x and y axes mappings.** Particularly with prices, the most common of these has its own function: **scale_y_log10** and **scale_x_log10** both change the scales to log (base 10).

**For house prices, this is ideal: it makes proportional change comparable** so that (e.g.) London's much higher prices can be visually compared to cheaper TTWAs. 

This scale can be added with one line:


```r
ggplot(saleSummary, aes(x = year, y = meanPrice, colour = ttwa)) +
  geom_point(aes(size = countOfSales), colour = 'grey') +
  geom_line() +
  scale_y_log10() # <<< new log y scale
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-55-1.png" width="672" />

Where previously there appeared to be a marked difference in the post-crash response, the **log scale shows that is perhaps not the case**. London is still its own thing, as always.

> **Note: these are 10 of the richest areas. There will be a chance later to compare richer and poorer TTWAs to see if there was any difference.**

*****

Scale changes for other aesthetics have a range of options. An example will make this more clear. Say you want to **control the size range for the points** in the previous plot. Add the following scale code.


```r
ggplot(saleSummary, aes(x = year, y = meanPrice, colour = ttwa)) +
  geom_point(aes(size = countOfSales), colour = 'grey') +
  geom_line() +
  scale_y_log10() +
  scale_size_continuous(range = c(0,10))
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-56-1.png" width="672" />

> Another note: for things like scale changes, **it doesn't matter where in the ggplot argument order they go. Line order only makes a difference for the order that geoms draw in.**

**geom_point's** circles are larger - but London is dominating, having by far the most sales. One option is to **remove London to see what the others look like**.

We can use the **dplyr** verb **filter** to do this: it's just a function, so as with anything else in R, it can be used anywhere. Here, we tell **filter** to give us **all ttwas *except* London**:


```r
ggplot(saleSummary %>% filter(ttwa!='London'), 
       aes(x = year, y = meanPrice, colour = ttwa)) +
  geom_point(aes(size = countOfSales), colour = 'grey') +
  geom_line() +
  scale_y_log10() +
  scale_size_continuous(range = c(0,10))
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-57-1.png" width="672" />

**Why did all the points become larger?** Because the top of the range was previously London prices, making all the others **relatively lower.** Removing London changes that.

Note, the range size's appearance will vary **depending on the size of the overall plot.** This can be seen if you look at it via **zoom or export/copy to clipboard**.

**Is grey really working?** If we want to try those points coloured by ttwa again, just **remove the override** (delete *colour = 'grey'*):


```r
ggplot(saleSummary %>% filter(ttwa!='London'), 
       aes(x = year, y = meanPrice, colour = ttwa)) +
  geom_point(aes(size = countOfSales)) + #<<< removing colour = 'grey'
  geom_line() +
  scale_y_log10() +
  scale_size_continuous(range = c(0,10))
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-58-1.png" width="672" />

Well, that's messy! One more option that can sometimes make otherwise unreadable graphs workable: **we change change alpha. This controls transparency:**

* **alpha = 1 means perfectly opaque**
* **alpha = 0 means perfectly transparent**

So giving **geom_point a value between those two** (and note, we're setting it directly so it's **outside of the aes function**):


```r
ggplot(saleSummary %>% filter(ttwa!='London'), 
       aes(x = year, y = meanPrice, colour = ttwa)) +
  geom_point(aes(size = countOfSales), alpha = 0.3) + #<<< adding alpha value here
  geom_line() +
  scale_y_log10() +
  scale_size_continuous(range = c(0,10))
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-59-1.png" width="672" />



## Scales for controlling colour

We've been using ggplot's default colour scheme so far but - as with other scales - we can choose a colour scheme for the **colour mapping** ourselves. There are a huge number of options here, many on **page 2 of the ggplot cheatsheet** - let's just cover two.

As before, we select the aesthetic by having **colour** in the middle of the function name (or **fill** if you're working with, for example, the colour fill of bars.) We'll look at these two options:

* **scale_colour_brewer**
* **scale_colour_manual**

The first of these **gives us a range of pre-set palettes to choose from**, based on the [colour brewer palettes](http://colorbrewer2.org/). They're broken into three types: **sequential, qualitative and diverging.** There is **a function for viewing them** (this is also on the ggplot cheatsheet) but you need to load the **RColorBrewer** package:



```r
library(RColorBrewer)

display.brewer.all()
```

To apply one of these to our data, we just need to add the following. Pick a palette name from the list then add this to the end of your previous **ggplot** code (remembering the plus on the previous line!) ->


```r
scale_color_brewer(palette = 'Paired')
```


```r
ggplot(saleSummary %>% filter(ttwa!='London'), 
       aes(x = year, y = meanPrice, colour = ttwa)) +
  geom_point(aes(size = countOfSales), alpha = 0.3) + #<<< adding alpha value here
  geom_line() +
  scale_y_log10() +
  scale_size_continuous(range = c(0,10)) +
  scale_color_brewer(palette = 'Paired')
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-62-1.png" width="672" />

Another option is to **set the colours manually.** There are a **huge number of pre-defined colour names** in **ggplot**. This website has the full reference: sape.inf.usi.ch/quick-reference/ggplot2/colour

Or you can also use **hex values**. Here's some I took from www.color-hex.com. We have nine TTWAs to colour so I've got nine values. Either set them directly in **ggplot** or put them in a vector to keep the code tidy.


```r
newcols = c('#ff9500','#154935','#f7786b','#410c37',
            '#1242b6','#cc554c','#946b2d','#e0301e','#607d8b')
```

Then use **scale_colour_manual** to apply them:


```r
scale_color_manual(values = newcols)
```


```r
ggplot(saleSummary %>% filter(ttwa!='London'), 
       aes(x = year, y = meanPrice, colour = ttwa)) +
  geom_point(aes(size = countOfSales), alpha = 0.3) + #<<< adding alpha value here
  geom_line() +
  scale_y_log10() +
  scale_size_continuous(range = c(0,10)) +
  scale_color_manual(values = newcols)
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-65-1.png" width="672" />

*****

## Using factors to control order of variables

Up to now, the TTWAs **have appeared in alphabetical order in the legend** - which is a bit visually confusing, as **the highest prices are nearer the top**. It would be nice if the legend matched this.

This is usually a pain to deal with in R but, again - **tidyverse to the rescue**. The **forcats** library helps us with categorical data like place names. Let's load it and see what it does:


```r
library(forcats)
```

If you don't want to think about what it's doing, you can just use **forcats** to re-arrange the order of TTWAs **directly in ggplot**. Building on our previous graph (though **adding London back in**), we can just use the **fct_reorder** function directly in **ggplot**. Give it the **variable** to reorder and **another variable to reorder by**, in this case **meanPrice**. Notice the **minus sign**: this will make it **descending order.**


```r
ggplot(saleSummary, 
       aes(x = year, y = meanPrice, colour = fct_reorder(ttwa,-meanPrice))) +
  geom_point(aes(size = countOfSales), alpha = 0.3) +
  geom_line() +
  scale_y_log10() +
  scale_size_continuous(range = c(0,10))
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-67-1.png" width="672" />

> We'll look a bit more at what fct_reorder does when covering the **dplyr mutate verb** below.


*****

> There's a lot more about controlling graph appearance to talk about, but a last couple of tips for controlling graph view before moving on for now... 

**First-up:** if you want to **control the part of the data that's viewable**, you can use one of the **coordinate functions**. With **coord_cartesian**, the exact window can be set. 

So say we only want to look at **data between the years 2000 and 2008:**


```r
ggplot(saleSummary, 
       aes(x = year, y = meanPrice, colour = fct_reorder(ttwa,-meanPrice))) +
  geom_point(aes(size = countOfSales), alpha = 0.3) +
  geom_line() +
  scale_y_log10() +
  scale_size_continuous(range = c(0,10)) +
  coord_cartesian(xlim = c(2000,2008)) # <<< set the view window
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-68-1.png" width="672" />

**Second-up:** how to control the legends? If they're in the wrong order, or you want to remove them entirely, **use the guides function.**

If we want to force the **count of sales size legend** below the TTWA colour guide, set the order directly by adding this to the ggplot code:


```r
guides(colour = guide_legend(order = 1),
       size = guide_legend(order = 2))
```

**Or to get rid of a legend entirely, just use its aesthetic name and set it to FALSE (or F for short - both work):**


```r
guides(size = F)
```

There'll be a lot more info on controlling appearance later.


***********************************************

##  Joining data sources together


It would be very useful to be able to **adjust our house price data to something that's consistent over time**. But how? We could use some value for inflation, but this doesn't actually include house price change and would only provide a single adjustment figure for the whole of England.

**Another option is to use wages over time**. Not only does this give a simple measure of house cost - **house price as a multiple of the average wage** - but it varies by region, giving a much more localised measure.

To do this, **we need to link the housing data to wage data**. Linking two datasets together is often an essential part of visualisation when there is a need to compare or supplement information. 

R's base commands are not bad for this, but **dplyr's join functions** do the job a little bit quicker.

So first, let's **load the wage data** (taken from NOMIS). It's in CSV format and we'll use the **readr library** mentioned earlier, loaded as part of the **tidyverse package**. Again, remember - you can type 'data/med' and use autocomplete to get the rest of the file name.



```r
wages <- read_csv('data/medianWages_localAuthority.csv')
```

**Click on the new dataframe in the environment panel:** it consists of:

* a column each for the **local authority name and code (the 'mnemonic' column)**
* One column per year **from 1997 to 2018**


## `Gathering' into long form

We want to **merge this with the housing data summary** so that each median wage per year per local authority is matched against the average price at that time and place.

But this is currently **wide data** - the year variable is spread across columns. So the first thing to do: **gather the years into their own column** so that it matches the single year column in the house sales data.

This can be done with another **tidyverse** library: **tidyr**. This just requires *two* things:

* Give **tidyr** a name for the **key** and **value** columns. You can decide on these names. Let's go for a key of **year** and value column name as **medianwage**.
* Tell it which columns to gather.

We can use the pipe operator. This looks like:


```r
wagesLong <- wages %>% 
  gather(key = year, value = medianwage, `1997`:`2018`)
```

> **Note: in this case, the column names in the range we passed in needed surrounding with backticks (very top left on the keyboard). Why? If column names are numbers, R can't parse them well - the tick marks are needed to pass in the names correctly. If they had been plain text, the ticks marks wouldn't be needed. Another joyous R foible.**

Take a look via the environment pane: we now have the **wage data in long form**. Note: we didn't have to say anything about the remaining local authority columns: **tidyr** automatically repeats these for us.

Now it's in long form, here's an opportunity to use another **stat** from **ggplot**


```r
ggplot(wagesLong, aes(x = year, y = medianwage)) +
  geom_boxplot()
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-73-1.png" width="595.2" />

**A boxplot** can help get a quick look at the shape of the data. In this case, it's easy to see median wages going up over time - so the data looks sensible.

## Saving and reloading the housing data

Because memory is a little tight, let's **load a different selection of the housing data.** This is in exactly the same format as before, it's just **sales from a selection of local authorities**, rather than TTWAs.

**If you want to save your previous sales data or any of your other dataframes, now would be a good time. We can then overwrite some of these files without fear of losing anything. Although we've only added the year field so far, so nothing drastic will be lost.**

The **saveRDS function** is a good way to do this: it saves the dataframes as compressed objects that  (a) are very compact and (b) reload in exactly the same form. So for instance, saving to our data folder:


```r
saveRDS(sales,'data/salesTTWAwithYearAdded.rds')
```

**And feel free to save any other dataframes you want to return to.**

We can then **overwrite the sales variable with the new price data**. Again, it's a long file name so use autocomplete again!


```r
sales <- readRDS('data/landRegistryPricePaidLocalAuthoritySelection.rds')
```

And we'll also need to **re-add the year column:**


```r
sales$year <- year(sales$date)
```

*****

## Merging the housing and wages data

Now we've got both of our datasets to combine, let's stop for a moment and think through what we're aiming for.

* The (long) wage data gives us **the median wage for each year and each local authority** - one row for each of these combinations.
* We want to know **how many multiples of this wage** you'd pay for the **average-priced house in each local authority.**
* Which means, first - we need to **repeat our dplyr summarising, but this time at the local authority level**, so it matches our wage data. We want it to **also** have one row per year / local authority combination.

So we first need to **summarise the sales data** as we did before. **Notice how dplyr makes this a simple change compared to before. We just replace ttwa with the new geography:**


```r
saleSummary <- sales %>% 
  group_by(localauthority,year) %>% 
  summarise(meanPrice = mean(price))
```

```
## `summarise()` has grouped output by 'localauthority'. You can override using the `.groups` argument.
```

Looking at the result, **we can see this matches the structure of *wagesLong*: one column for year and one for the local authority.** 

> This stuff is (for me at any rate!) **always a little confusing!**. It is rarely an intuitive process! Taking the time to **look at the data** in the View panel can be really helpful for making sense of what's going on.

******

> **We're now ready to merge in the median wages.**

**The dplyr cheatsheet has a neat diagram showing our various joining options.** We want to use an **inner join** because we only want to **keep local authorities that the two dataframes have in common.**

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-78-1.png" width="288" />

*****
> **When doing joins, it's generally wise to make a new variable. Joins often go wrong on first attempts: it's useful to be able to compare with the previous data to make sure it's done what you wanted it to.**

> Note also: when merging/joining, it's often necessary to do some checks that the data is formatted in the same way in both cases for the join fields, especially for variables like postcodes that may contain spaces. We'll see an example of this in a moment...

*****

The **dplyr cheatsheet** shows how to use join to merge on single variables - that's nice and straightforward. But there are two more things to consider here:

* **We want to join on both year *and* local authority.** This is solved by passing in a **vector of the columns to join on**.
* **The variable name containing the local authorities is *not the same* in both dataframes.** This is solved by **supplying both names connected with an equals**.

This looks like this, and *should* work...


```r
price_n_wage <- inner_join(
  wagesLong,
  saleSummary,
  by = c('year', 'Area' = 'localauthority')
)
```

... but, oh dear, not quite. What went wrong? **This is a rare occasion when an R error message is actually informative: *``Can't join on 'year' x 'year' because of incompatible types (character / numeric)''* **

Ah: the *year* variable in one of them is in character format, not number. But which? Looking in the environment panel, we can **click on the arrow symbol to look**. This reveals, under wagesLong:

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-80-1.png" width="576" />

The **`chr'** next to *year* show it's a character column. So **when we gathered the year column names, they were kept as characters.** Before we can merge, we have to make them the same format:


```r
wagesLong$year <- as.numeric(wagesLong$year)
```

Looking back in the environment panel, wagesLong's year column is now showing itself as **num**. And now we should be able to join:


```r
price_n_wage <- inner_join(
  wagesLong,
  saleSummary,
  by = c('year', 'Area' = 'localauthority')
)
```




Check **price_n_wage** via the environment panel: **we've now got mean price and median wage in the same rows.**

*****

Now we've got those columns together, there are two more things to do:

* **It's currently the *weekly* median wage. We want yearly, to get house price as a multiple of yearly pay.**
* Once we've got yearly pay, turn the house prices into a multiple of this.

How? Time for:

*****

> ***Verb 4: mutate*. This allows us to make whole new variables and attach them to our existing dataframe.**

*****

All mutate does: it **creates new variables and attaches them to the existing dataframe.** This can be something as simple as a single value. Or, say we want to create a *flag* indicating areas with a median wage above £300 a week. Using the pipe operator, that would look like:


```r
price_n_wage <- price_n_wage %>% 
  mutate(wages_above_300 = medianwage > 300)
```

Incidentally, we don't really need that column, so we can drop it with **select** and using a minus:


```r
price_n_wage <- price_n_wage %>% 
  select(-wages_above_300)
```


We want to use mutate for those two jobs: **convert the weekly wage to a yearly one**, and **divide the mean property price by the yearly wage to get a wage multiple value as a house price index.**

As with summarise, **mutate** can do multiple variables at the same time. And, very handily, **dplyr** is also a **lazyeval** function. Which means what? This:

> **We can define one variable and then use it immediately in the next one.** So we can work out yearly pay, then immediately use that to find the house price multiple. Thus:


```r
price_n_wage <- price_n_wage %>% 
  mutate(
    medianwageyearly = medianwage * 52, # weekly wage to yearly wage
    wagemultiple = meanPrice / medianwageyearly # house price as multiple of that yearly wage
    )
```

**Look again the the price_n_wage** dataframe to check it's done what we wanted - and then we can **try a plot.**

There are too many local authorities to fit in a legend, so we can **use the guides code mentioned above** when we plot, to **remove the legend** so we can get a look at all the data together without the legend messing up the plot. (Try it without the **guides** function to see what I  mean.)


```r
ggplot(price_n_wage, aes(x = year, y = wagemultiple, colour = Area)) +
  geom_line() +
  guides(colour = F)
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-87-1.png" width="595.2" />

So: **we now have house prices as a ratio of median yearly wages.** And there's one crazily high outlier and it's difficult to see any effect from the crash. But there are a lot of local authorities here - **how to pick out ones we want to look at?**


## Choosing a subset based on some criterion

A useful first step to deciding how to pare down your data is to **make an ordered list** of some variable of interest to look at. So say we want to see:

* **The order of wage multiples in the final full year of the data**

The advantage of making a separate list is: **we can then use it as a tool for selection**. But first, let's make it. We can just use **filter** to pick out the year we want - but here's a new verb:

*****

> ***Verb 5: arrange*. This re-orders the *actual dataframe* much as *sort* does in Excel. That's quite different to anything else we've look at, where the actual row order of the data itself didn't really matter. (It has no impact on grouping or the order of category drawing, for instance).**

*****

This is really useful for two reasons: first, if we actually want to **see** the order ourselves. Second, there *are* some functions that depend on data order, such as **lag** (see the **window functions** on the dplyr cheatsheet). 

So here's the code: 

* **use filter to get 2018 only** then
* **use arrange to sort the whole dataframe by the wage multiple.** Make it **in descending order with the minus.**


```r
price_n_wage2018 <- price_n_wage %>% 
  filter(year == 2018) %>% 
  arrange(-wagemultiple)
```

**Take a look at the new dataframe: the highest wage multiple is at the top and we can see what local authority it applies to.** No surprise, London local authorities dominate the top of the list. And right at the top, way out in the lead, is **Kensington and Chelsea.** Could this be a combination of England's most expensive housing with a mixed population (so a lower median wage)?

> **We can use a dataframe like this to guide subsetting decisions for graphs.** The essential principle is to **use our selecting dataframe to subset the zones we want.**

*****

Say we want to look only at the **ten local authorities with the lowest wage multiple in 2018.** By looking at the data, we can see this is **those with a wage multiple below 5.78.**


```r
zoneselection <- price_n_wage2018 %>% filter(wagemultiple < 5.78)
```

Or, because the data is **ordered by wage multiple**, we could just grab the bottom ten from the dataframe using the **tail function** (the opposite of head, this gives us the last rows):


```r
zoneselection <- price_n_wage2018 %>% tail(10)
```


Once have this selection, we can tell **ggplot**: *``filter areas by those **%in%** our zone selection''.* This is the same principle as when we removed London - using a logical operator in filter:


```r
ggplot(price_n_wage %>% filter(Area %in% zoneselection$Area), 
       aes(x = year, y = wagemultiple, colour = Area)) +
  geom_line() 
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-91-1.png" width="595.2" />

> The **%in% operator** is fantastic: it can be used for multiple selections. As with everything else in R, it **works with vectors** - we just passed it a dataframe column, which is a vector. If we wanted to pass a vector directly, we could - e.g.:


```r
ggplot(price_n_wage %>% filter(Area %in% c('Camden','Oxford','Wirral','Liverpool')), 
       aes(x = year, y = wagemultiple, colour = Area)) +
  geom_line() 
```

> **So the impact of the crash appears to be quite apparent in some of the local authorities with the cheapest housing. Wage multiples appear to have *decreased over time* since the crash.**

*****

You might also want to **select particular row numbers** based on the data you can see in the View panel. Row numbers are shown on the left. Say we want to look at the **top and bottom five** but **exclude Kensington and Chelsea**. We can use a **new dplyr verb:**

> ***Verb 6: slice*. Pass in the row numbers you want - simple. Put a minus before the selection to keep all *but* those. Place in a vector for multiple selections.**


```r
#Top ten, excluding Kensington and Chelsea (no vector function needed)
zoneselection <- price_n_wage2018 %>% slice(2:11)

#Top and bottom five, excluding Kensington and Chelsea
#Use a vector function for multiple selection
zoneselection <- price_n_wage2018 %>% slice(c(2:6,72:76))
```

So: plotting our selected top and bottom five. Let's also **add the fct_reorder code** we used before to make the legend order more readable. And we'll **relabel the legend** while we're at it.


```r
ggplot(price_n_wage %>% filter(Area %in% zoneselection$Area), 
       aes(x = year, y = wagemultiple, colour = fct_reorder(Area,-wagemultiple))) +
  geom_line() +
  labs(colour = 'area')
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-94-1.png" width="595.2" />

> **The advantage of using a selection dataframe or vector like this: the *ggplot* code doesn't need to change. You just need to change the selection.**

*****

Pausing for a moment: looking at the plot of top and bottom local authorities by wage multiple, it's easier to see something about the impact of the crash: **places with cheaper housing have seen a drop in value, relative to wages. Pricier areas have carried on their upward climb, after a brief dip.**


> **We'll come back to the wage multiple data in the facets section later, if you want to look at this in more detail.**

We'll stop there, but it's worth mulling the following: if we plot **wage multiple of house price versus the actual wage**... 


```r
ggplot(price_n_wage2018, aes(x = wagemultiple, y = medianwage)) +
  geom_point()
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-95-1.png" width="595.2" />

... while there's mostly a linear positive relationship, there are outliers in both directions: Kensington and Chelsea we've already seen, that's the point on the right. But there are *also* places with very low wage multiples but **high median wages**. How might you dig into that further?



******

## Saving ggplots as image files

Lastly, **let's save a plot as an image file**. To do this, we need to assign the plot to its own variable. If we re-run the previous **ggplot** of top and bottom wage multiples, it's done like this - assigning to a variable as we would with any other assignment:


```r
zoneselection <- price_n_wage2018 %>% slice(c(2:6,72:76))

output <- ggplot(price_n_wage %>% filter(Area %in% zoneselection$Area), 
       aes(x = year, y = wagemultiple, colour = fct_reorder(Area,-wagemultiple))) +
  geom_line() +
  labs(colour = 'area')
```

If you run that, you'll see the plot does **not immmediately output to the plot window.** To do this, just call the variable, as we've done with any other in the console. This will output our plot:


```r
output
```

Now that we've got the plot assigned to **output**, we can **use it to save as an image.** If there isn't already a (currently empty) **images** folder in your project root folder, create one now. You can do that within RStudio using the **New Folder** option in the **Files** tab. Our **output** variable containing the plot goes into the **ggsave** function:


```r
ggsave('images/topAndBottomLAs_wageMultiples.png', output, dpi = 300, width = 7, height = 4)
```


Some other points about ggsave:

* **It works out what image format to save from the file name.** In this case, it saves a PNG.

* **DPI** controls 'dots per inch'. Higher values will be higher-resolution.

* **Width and height will determine the relative size of text and features in the plot, not dpi.** So, for example, see what happens when doubling both width and height:


```r
ggsave('images/topAndBottomLAs_wageMultiples_large.png', output, dpi = 300, width = 14, height = 8)
```

Whereas if we make a low-res version but keep the dimensions the same:



```r
ggsave('images/topAndBottomLAs_wageMultiples_lowres.png', 
       output, dpi = 75, width = 7, height = 4)
```


*****

## Time for a pause!

So you've successfully loaded data, wrangled it and visualised it. Just a quick reflection on how we did that, before moving on to the second part of this section:

* **We used a bunch of *tidyverse* libraries** to process and visualise data. These are all designed with the same philosophy of `constrain to simplify'.

* **ggplot works with 'long' data: a single column maps to a single aesthetic**. For any particular feature, we fed it a **single variable in a dataframe column**. If that column contained a bunch of categories that we wanted to give a colour to, we just told **ggplot**: *colour = variable*. Same for any other aesthetic, including x and y coordinates.

*****

OK, so next - you've got **six (and a bit) options** to have a go at. For this part of the course I'm going to let you work independently from this booklet and be on hand to help. If anything important comes up, I'll work through it on the screen again.

1. **Working on prettifying the plot you've just made.** This covers some of the most common options for customising plots.

2. **Facetting and dodging**: facetting is a way to use **ggplot's** aesthetics to create multiple plots in one. Dodging is a draw-position function that allows side-by-side comparison of a variable. This section puts both together and looks at house type versus wage multiple. 

Then we have two options for working on **iteration:**

3. **Outputting multiple plots.** Rather than having to manually output individual plots, this introduces a programmatic way to loop through all the data you want to output, giving each its own plot and saving them all to a folder.

4. **Pulling out model values and using them to plot, including error rates.** (And a quick look at functional programming.) ggplot has specific geoms for plotting ranges and error rates. This section looks at pulling coefficients and standard errors from a series of models into one dataframe, so they can all be plotted. **There's also a look at creating your own functions as a way of repeating the same similar tasks. (This is the 'and a bit')** 

And lastly a little exercise using dplyr to summarise some geographical data and find a group's modal value:

5. **Mapping!** This section introduces two ways to make maps from your data: first, using **ggplot** itself and, second, using the **simple features** package - an amazing spatial analysis tool that plays nicely with the **tidyverse**.

6. Freestyle! **Working from the cheatsheets, try and find another way to play with and visualise the data. Or repeat what we've already done with some different data.** In order to aid this process, if you want to try it, there's a **different set of data in the data folder** to the one we originally used. Rather than a selection of largest TTWAs (in terms of their number of sales) this one contains **ten of the largest *and* smallest**, some of which are TTWAs with **much lower house prices**. So this is a chance to ask: **is there a difference in how the richest and poorest areas in England (in terms of house price) responded to the crash?** We've already seen some evidence of a difference - and there's more on this in option 4.

The file is called: **landRegistryPricePaidTopBottomTTWAs.rds**

And this one doesn't have its own section below: you're on your own! Work with the code above and the cheatsheets. **A start would be just swapping the RDS file in the first section and seeing how different it looks.**

*****

# FREEFORM 1: WORK ON NEW IDEAS TOGETHER...

From here on, we can either look at some more examples below, or work on other data ideas e.g. perhaps some Sheffield-specific data sources. Here are six other options if we want to look at those:

# FREEFORM 2: SIX OTHER OPTIONS TO PLAY WITH

## Prettifying a graph

So we made some graphs, but they're lacking finesse. **ggplot** provides many ways to customise its appearance to make it more presentable. **In this option, we'll look at some of the most common functions used to do this.** So here's the plot we were just working on, for reference - **but feel free to go and grab code for the earlier plots if you'd prefer.** This will all apply to those too.

**Here we'll look at the top and bottom local authorities' wage multiple** (excluding Kensington and Chelsea, as we did before).

**Note: this section uses the same *price_n_wage* dataframe from the section on merging. If you've done the facet option before this one, you may have over-written it. If so, here's a quick option to reload. (Or run the code for that section again, whichever you prefer.)**


```r
#reload price_n_wage data we previously made, if it's been over-written with anything
price_n_wage <- readRDS('data/price_n_wage_fromjoinsection.rds')

price_n_wage2018 <- price_n_wage %>% 
  filter(year == 2018) %>% 
  arrange(-wagemultiple)

#choose whichever zone selection option you want. Here's the previous three.
#zoneselection <- price_n_wage2018 %>% filter(wagemultiple < 5.78)
#zoneselection <- price_n_wage2018 %>% slice(2:11)

#We'll use this one here.
#Top and bottom five, excluding Kensington and Chelsea
#Use a vector function for multiple selection
zoneselection <- price_n_wage2018 %>% slice(c(2:6,72:76))
```



We've already seen how to change the label for the legends using **labs** and control legend order using **fact_reorder**  - these are included here:


```r
ggplot(price_n_wage %>% filter(Area %in% zoneselection$Area), 
       aes(x = year, y = wagemultiple, colour = fct_reorder(Area,-wagemultiple))) +
  geom_line() +
  labs(colour = 'area')
```

> **The basic principle is to add cumulatively to a ggplot: just add a *plus* at the end of a line and then include our new tweak on its own line.** An advantage of it being on its own line: *we can comment out any particular feature easily to play around with the output.*

**Try any / all of the following. If you want to see them all together, skip ahead a few pages.**

*****

> * **Change the axis labels**

The x and y axis labels can be changed with the **xlab** and **ylab** functions. So updating the y axis would look like:


```r
ylab('wage multiple') 
```

> * **Add some better ticks to the y axis scale**

You can set any scale ticks completely manually. This can be done by adding a **scale_y_continuous** function. 


```r
scale_y_continuous(breaks = c(0,5,10,15,20,25,30))
```

It's also possible to **over-ride the labels used for those ticks**. Be careful to make sure both of these vectors are same length - it needs a one-to-one correspondence:


```r
scale_y_continuous(breaks = c(0,5,10,15,20,25,30),
                   labels = c('0','5x','10x','15x','20x','25x','30x'))
```


This tells **ggplot** exactly *which* breaks we want and how to label them. (The labels can be text or numbers.) So we have very fine control of these. 




> * **Giving the plot a title**

I always forget how to do this and need to google it! I invariably [copy the code from here](http://www.cookbook-r.com/Graphs/Titles_(ggplot2)/) and amend it. We add a **ggtitle** and then make it bold by changing the **theme**.

The latest **ggplot** aligns titles to the left by default - you can include an **hjust** value in theme


```r
ggtitle("House prices as multiple of yearly wage top and bottom five English local authorities") +
theme(plot.title = element_text(face="bold",hjust = 0.5))
```

**That's a stupidly long title.** You can wrap lines in the title by using **backslash n** where the lines should break. It's hard to spot here: the **backslash n** is after *wage* and before *top*:


```r
ggtitle("House prices as multiple of yearly wage\ntop and bottom five English local authorities") 
```


> * **Removing axis titles entirely**

One might think having the 'year' title for the x axis is a bit superfluous: years are self-explanatory. (Many say axes must always be labelled, mind!) Anyway, if you don't like it, the **theme** function can again be used. **Note here, we're adding the to theme formatting we did for title above.**


```r
  theme(plot.title = element_text(face="bold",hjust = 0.5)),
        axis.title.x=element_blank())
```

The same can be done with text and ticks using **axis.text.x** and **axis.ticks.x** (or y).



> * **Changing the line type and size**

As we did when changing the sales count circles to grey, the line type and size can be altered in the **geom_line** function directly. [Here's a reference](http://docs.ggplot2.org/0.9.3.1/aes_linetype_size_shape.html) for the **linetype** number:

> **0 = blank, 1 = solid, 2 = dashed, 3 = dotted, 4 = dotdash, 5 = longdash, 6 = twodash**


```r
geom_line(size = 1, linetype = 5)
```

> * **Quickly creating a flag for a new aesthetic mapping**

Perhaps you want to mark out which local authorities are in London. All we need for this: **a single column marking which of the local authorities are in London.** We could then use **linetype** to mark this.

In the current data, the three London zones are **Camden**, **Islington** and **Hackney**. You could obviously use some more sophisticated way to pick out your group but let's just make it directly:


```r
londonzones <- c('Camden','Islington','Hackney')
```

We can then use **dplyr** to make a **flag column** (with actual labels rather than just a zero and one, as is common with flag columns.)

There's a new function here: **ifelse**. As the name suggests, this just lets us say: **if this condition is met, do this - else, do that**. (That's the best way to remember the order of the arguments too: *`if, then: this, else that'*.) We can combine it with the **%in%** operator.


```r
price_n_wage <- price_n_wage %>% 
  mutate(inLondon = ifelse(Area %in% londonzones, 'london','other'))
```

As always, take a look at the dataframe to confirm it's done what you wanted it to. Or throw it into the **ggplot** and see... 

> * **Bringing all that together**

Here's those options all in the ggplot code - **including the new linetype aesthetic mapping.** It also hides the *inLondon* variable name above the **linetype** legend.


```r
ggplot(price_n_wage %>% filter(Area %in% zoneselection$Area), 
       aes(x = year, y = wagemultiple, colour = fct_reorder(Area,-wagemultiple))) +
  geom_line(aes(linetype = inLondon), size = 1) +
  ylab('wage multiple') +
  labs(colour = 'local authority', linetype = ' ') +
  scale_y_continuous(breaks = c(0,5,10,15,20,25,30), 
                     labels = c('0','5x','10x','15x','20x','25x','30x')) +
  ggtitle("House prices as multiple of yearly wage\ntop and bottom five English local authorities") +
  theme(plot.title = element_text(face="bold",hjust = 0.5),
        axis.title.x=element_blank())
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-113-1.png" width="691.2" />

<!-- > **Prettifying a log scale** -->

<!-- ```{r echo = F, message = F} -->
<!-- #One I made earlier -->
<!-- saleSummary <- readRDS('data/saleSummary4logprettifying.rds') -->

<!-- ``` -->

<!-- One last thing: we've worked a lot with log scales for prices and they didn't look great. **How to improve them?** Let's look at one of the price graphs using a log scale. Here's the code to create it again. -->

<!-- This has **one easy addition** to make prices more readable: **turning them into multiples of a thousand**. Axes look a lot nicer with *100* and a label explaining they're in thousands. -->

<!-- ```{r eval = F} -->
<!-- sales <- readRDS('data/landRegistryPricePaidTopTTWAs.rds') -->

<!-- sales$year <- year(sales$date) -->

<!-- saleSummary <- sales %>%  -->
<!--   mutate(pricethousands = price/1000) %>%  -->
<!--   group_by(ttwa,year) %>%  -->
<!--   summarise(meanPriceThousands = mean(pricethousands), countOfSales = n()) -->
<!-- ``` -->

<!-- We can then **make some additions to the *scale_y_log10* function**, including setting the scale name directly. The values in **breaks** are where the *real* (non-log) values will have ticks. The **labels** function tells them what to show. We could leave that out here since it's just repeating breaks, but it's worth knowing you have complete control over them. -->

<!-- ```{r fig.width=7.2, fig.height=4.5} -->
<!-- ggplot(saleSummary,  -->
<!--        aes(x = year, y = meanPriceThousands,  -->
<!--            colour = fct_reorder(ttwa,-meanPriceThousands))) + -->
<!--   geom_point(aes(size = countOfSales), alpha = 0.3) + -->
<!--   geom_line() + -->
<!--   guides(size = F) + -->
<!--   labs(colour = 'TTWA') + -->
<!--   scale_y_log10(name = 'average price (log scale in real prices)', -->
<!--                 breaks = c(100,200,400), -->
<!--                 labels = c(100,200,400)) + -->
<!--   scale_size_continuous(range = c(0,10)) + -->
<!--   ggtitle("Average House prices for TTWAs") + -->
<!--   theme(plot.title = element_text(face="bold",hjust = 0.5), -->
<!--         axis.title.x=element_blank()) -->

<!-- ``` -->

*****

\clearpage{\pagestyle{empty}\cleardoublepage}

## Facetting and dodging: getting as much info into one graph as humanly possible

There's a quote about visualisation doing the rounds:

> **``A designer knows he has achieved perfection not when there is nothing left to add, but when there is nothing left to take away.''**

That's all very well, but sometimes it's good to **stuff as much information into one chart as possible**... This section covers two useful things to help us do this:

**ggplot** has a rather nice feature called **facetting** that allows us to put data into separate panels in one plot. As with other mapping of aesthetics, to do this we need **one column that will act as our facet category**, to split across multiple panels.

The **position** function in geometries also has a very useful option: **"dodge"**. We've already seen **position = "stack"**: this stacked mapped variables on top of each other in a bar chart so their counts summed. Instead, **dodge places them next to each other.**

We'll also use this as an opportunity to explain a bit more how **factors** work.

Let's ask:

> **How have prices (in terms of wage multiple) of different *types* of house changed (detached, terraced etc) for a range of years, in four local authorities?**

Again, this is the wage data combined with local authority house price data. In case this isn't already loaded, here's the code again. Note, we already know the **year** column will need converting to **numeric**, so we do that here too.


```r
wages <- read_csv('data/medianWages_localAuthority.csv')

#Make wages into long data, year in its own column
wagesLong <- wages %>% 
  gather(key = year, value = medianwage, `1997`:`2018`)

#Make year numeric in preparation for the join
wagesLong$year <- as.numeric(wagesLong$year)

#Reload sales at local authority level
sales <- readRDS('data/landRegistryPricePaidLocalAuthoritySelection.rds')
#Add the year column
sales$year <- year(sales$date)
```

As before, we need to make a **summary of the house price data** - but with an addition. We want **average price per year, per place AND per house type.** As always, you can just add this to the **group_by** verb and **dplyr** will create the grouped data already in long form.

We also initially filter to get **just four specific years**, two each side of the crash. **Each of these will get its own facet.**


```r
saleSummary <- sales %>% 
  filter(year %in% c(2000,2005,2010,2015)) %>% 
  group_by(localauthority,year,type) %>% 
  summarise(meanPrice = mean(price))
```

```
## `summarise()` has grouped output by 'localauthority', 'year'. You can override using the `.groups` argument.
```

We're now ready to join, as we did before. We use **inner_join** again: so this will **only keep years (and local authorities) common to both**, in this case just 2000, 2005, 2010 and 2015.

Because the saleSumary data now has **type** in long form, the join will **repeat values for the joined wages dataframe.** Take a look once joined, you can see there are **repeated wages** for each house type (but unique price averages).

Let's also add the **yearly wage** and **wage multiple** columns here. Note: you could of course join these two separate tasks with the **pipe operator**. It doesn't always help with readability though - sometimes it's better to keep things a little separate.


```r
#See the dataframe: median wage repeated for each year / place
price_n_wage <- inner_join(
  wagesLong,
  saleSummary,
  by = c('year', 'Area' = 'localauthority')
)

#Make new columns
price_n_wage <- price_n_wage %>% 
  mutate(
    medianwageyearly = medianwage * 52, # weekly wage to yearly wage
    wagemultiple = meanPrice / medianwageyearly # house price as multiple of that yearly wage
  )
```

> **OK, the data's ready for plotting.** A reminder of the principle here: **ggplot wants one column per variable mapping / aesthetic**. We do that by **using long data**. So now we've got each of the following in its own column:

* wagemultiple
* Area (the local authority)
* type (the house type)
* year

The only **new type of mapping** we now do is the **facet** itself. Here's another R/ggplot quirk: **unlike everything else, this one requires a tilde before the variable name**. (Look up **facet_grid** to see why this is actually useful.)

So let's try this:


```r
ggplot(price_n_wage %>% filter(Area %in% c('Camden','Oxford','Wirral','Liverpool')), 
       aes(x = Area, y = wagemultiple, fill = type)) +
  geom_col() +
  facet_wrap(~year)
```

Hmm. Not quite: **the wage multiples are stacked** (this is **geom_col**'s default position - check its help file to confirm), which doesn't make sense here. They should be side-by-side. **Dodge to the rescue! Over-ride *geom_col's* default position (remembering the plus for the next line):**


```r
geom_col(position = 'dodge')
```

**Ah ha! Each value is now side-by-side and makes sense against the y axis.** But it would be useful to tell **ggplot** to place all the facets on one row to make it easier to compare the y-axis between categories. How? **Use autocomplete to get your list of facet options. Put a comma after year then press CTRL+SPACE**. Use the mouse or cursor: the help tells you how to use **ncol, nrow** and **scales**:

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-119-1.png" width="576" />

So we can set all the facets on one row with:


```r
facet_wrap(~year, nrow = 1)
```

Starting to look better, but **the order and labels for the house type are poor.** The order of the local authorities could do with tweaking too.

For this, we need to return to **factors** and using **forcats**. 

* Recall that ggplot uses **factor order for ordering its legends and plots**. (Or alphabetical / numerical order if the variables are plain character or number.)
* We've already used **fct_reorder**: this orders a variable by another - we've used it to order place names by average house price. But it also **converts the variable to a factor in the process** as **only factors can have a defined order in R.**

To see what's going on, it's useful to look closer at the variables. The current **type** variable is a plain character:


```r
class(price_n_wage$type)
```

```
## [1] "character"
```

The first thing we'll do is use **forcats** to **recode the names** to something more readable. We'll make a **new** variable, **type2**, so we can compare the difference: in practice **we'd usually overwrite the original**.

Using **mutate** to carry out the recode, we make a new **type2** variable from the old **type**:


```r
price_n_wage <- price_n_wage %>% 
  mutate(type2 = fct_recode(type,
                            'flat' = 'F',
                            'terrace' = 'T',
                            'semi' = 'S',
                            'detached' = 'D'
  ))
```

As with **fct_reorder**, the act of recoding converts the variable to a factor. And we can see this factor **has an order to it** as well - **this defaults to alphabetical.** By converting to **numeric**, you can also see what **factor** does: the coding has a number under the surface, **marking what order the factors are in.**


```r
class(price_n_wage$type2)
```

```
## [1] "factor"
```

```r
unique(price_n_wage$type2)
```

```
## [1] detached flat     semi     terrace 
## Levels: detached flat semi terrace
```

```r
as.numeric(unique(price_n_wage$type2))
```

```
## [1] 1 2 3 4
```

A more sensible order for house type would be **by size and likely cost**. Use **fct_relevel** to do this (and this time over-write **type2**):


```r
price_n_wage <- price_n_wage %>% 
  mutate(type2 = fct_relevel(type2,
                             'detached',
                             'semi',
                             'terrace',
                             'flat'
  )) 
```

If you now repeat the previous look at the variable, you can see the **levels have the order we've given them** (as has the number order.)


```r
unique(price_n_wage$type2)
```

```
## [1] detached flat     semi     terrace 
## Levels: detached semi terrace flat
```

```r
as.numeric(unique(price_n_wage$type2))
```

```
## [1] 1 4 2 3
```

It's worth emphasising: **this order has nothing to do with row order in the dataframe. It's the coding for the variable itself.**

> **OK, so that's enough about factors.** We'll just do one last thing: **reorder place names by the wage multiple**, as we've done before. This factor can overwrite the previous plain-character variable:


```r
price_n_wage <- price_n_wage %>% 
  mutate(Area = fct_reorder(Area,-wagemultiple))
```

> **Bringing all that together, the plot should now look something like this. Note also that *geom_col* has its colour set directly. This makes the bar outlines a little better defined:**


```r
geom_col(position = 'dodge', colour = 'grey') 
```

You could also try **coord-flip** - this can work well with categorical x axes. 



<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-129-1.png" width="883.2" />

And - because we're using three different categorical variables, try different combinations of **mapping them to fill, facet and x axis.**  What works best? For example, if we **swap year with Area** and **set a free y scale**, we can look at changes within local authorities over time. Though you **need to be careful to note that they're less visually comparable**, if a scale is free, **ggplot** will add individual tick marks for each.

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-130-1.png" width="883.2" />


**facet_wrap** has a [range of other options](http://docs.ggplot2.org/current/facet_wrap.html). Also useful is **scales**. As the link above explains (and as we saw in the autocomplete) this can be **scales = 'free'**. Or also **'free_y'**, **'free_x'** to control them separately. In this case, 'free_y' would allow **ggplot** to adjust each separately to fill the graph (but at the cost of the **wage multiple** not being as comparable.)



*****

## Iteration


*****

## 1. Outputting multiple plots

It's often useful to be able to look at many different elements of your data in their own separate plots - for example, looking at each city/town or local authority separately. This isn't often the kind of task you might need for **presenting data** - but as a way to **understand your own data**, being able to output many plots easily is really useful.

> **One option is to use a for-loop to do this. This will allow us to loop over each plot we want and output them separately.**

> What we'll do here: **cut up the local authorities from the work done in the *joining-data section* into equal size groups** and plot each of the groups.

We can work with the list of local authorities in price_n_wage2018. As usual, the tidyverse supplies a feature for cutting numeric data up in various ways.

******

**If you haven't still got *price_n_wage* and *price_n_wage2018* in memory from the join section, here's the *price_n_wage* dataframe with code for re-grabbing just 2018.**


```r
#reload price_n_wage data we previously made
#if it's been over-written with anything or removed
price_n_wage <- readRDS('data/price_n_wage_fromjoinsection.rds')

price_n_wage2018 <- price_n_wage %>% 
  filter(year == 2018) %>% 
  arrange(-wagemultiple)
```

******

**So how to cut up the local authority data into equal size groups? Here's code that does that in two forms: the first is base R, the second uses the pipe operator in dplyr** - just to compare legibility between the two.

**There's very useful auto-help for the cut functions: if you just type *cut_*, this should appear. Each of the three cut functions is explained.** **cut_number** will create a column marking out which rows for **wagemultiple** are in each group:


```r
#Base R version
price_n_wage2018$groupToPrint <- as.numeric(cut_number(price_n_wage2018$wagemultiple,8))

#dplyr piping version, same result
price_n_wage2018 <- price_n_wage2018 %>% 
  mutate(groupToPrint = wagemultiple %>%
           cut_number(8) %>%
           as.numeric
         )
```

Note: the **cut** functions are *not* cutting according to row - it's done according to value. That's why group number one is *lowest-value* local authorities and eight the *highest*.

Get a list of the unique values we're going to iterate over. **This could be a vector of character names like place-names** - it wouldn't have to be numeric.


```r
groupsToPrint <- unique(price_n_wage2018$groupToPrint)

groupsToPrint
```

```
## [1] 8 7 6 5 4 3 2 1
```

> **Now we're going to loop over those eight groups and produce a plot for each.**

> **If you've not come across *for-loops* before, they're straightforward. Translated to English, for-loops are just: 'for each of this set of values (in our case, it'll be our eight groups), carry out this bunch of tasks, once per value'.**


That vector can now be used in the for loop. **Set up the for loop first just to see what it's doing:**


```r
for(grp in groupsToPrint){
  
  print(grp)
  
}
```

The for-loop **assigns each value from *groupsToPrint* to the *grp* variable in turn**. It then executes the code between the curly braces. In this case, we're just printing the grp number - **but the principle is the same for whatever code we put between them. We just need to replace *print(grp)* with our code.**


The first job for the loop: **pull out the list of local authorities to print on each iteration**. We **filter by group** and then **pull** out the single vector of local authorities in the **Area** variable (we also use **print** here so the result is visible in the for loop):


```r
for(grp in groupsToPrint){
  
  #get vector of zones to draw
  zoneselection <- price_n_wage2018 %>% 
    filter(groupToPrint == grp) %>% 
    pull(Area)
  
  print(zoneselection)
  
}
```

A couple of things before starting:

> **We'll add our plots to a sub-folder in the images folder. Make that now with RStudio's 'new folder' option in the file tab, inside the images folder: something like *groupsOfLocalAuthorities*.**

> **It's tricky trying to debug code that's running inside a for loop. A useful thing to do is: pick one value to assign to *grp* so that we can then run the code by highlighting, without having to run the whole for loop. For example:**


```r
grp <- 1
```

When we run the actual for loop, it will overwrite this with the value it assigns. But we can work with it while getting the code right.

There's nothing much new in the code below: this is just our previous wage multiple plot code, working on each group in turn. The only other thing to note:

> **At the bottom, we're making a filename that includes the first and last *local authority* names in the group (as well as the group name). This is done with the *paste0* function. *Paste0* just takes in a bunch of bits of text and variables, separated by commas, and turns them into one character. This allows us to save each group as its own file.**

> There is also an added **geom_point** showing the median wage itself.


```r
for(grp in groupsToPrint){
  
  print(paste0('outputting group ',grp))
  
  #get vector of zones to draw
  zoneselection <- price_n_wage2018 %>% 
    filter(groupToPrint == grp) %>% 
    pull(Area)
  
  output <- ggplot(price_n_wage %>% filter(Area %in% zoneselection),
                   aes(x = year, y = wagemultiple, colour = fct_reorder(Area,-wagemultiple))) +
    geom_point(aes(size = medianwage), alpha = 0.2) +
    scale_size_continuous(range = c(0,10)) +
    geom_line(size = 0.75) +
    labs(colour = 'area')
  
  #save the plot
  #text of zones
  zonetext <- paste0(zoneselection[1],'_to_',zoneselection[length(zoneselection)])
  
  filename <- paste0('images/groupsOfLocalAuthorities/group_',grp,'_',zonetext,'.png')
  
  ggsave(filename, output, dpi = 300, width = 9, height = 5)

}
```

*****

### 2. Pulling out multiple model values and visualising them


This section is inspired by code from the excellent book [R for Data Science](http://r4ds.had.co.nz/) and the section on mapping with the **purrr** library (another one that comes packaged with the **tidyverse library**).

Academic papers are still full of endless regression tables. They are not very aesthetically pleasing. Another option is to **visualise your model's findings** in some way.

This section gives an example - it has little statistical merit but illustrates the basic idea:

> **If you're running any kind of model on multiple subsets of data, how can you pull out the results of interest and visualise them? How do you also show error?**

**ggplot** has a number of geometries specifically for showing ranges - as well as showing error, these can be used for e.g. showing mins and maxes. **You must set the values for these yourself**


> **The basic principle here is simple: pull out all of the results you want into a dataframe, then apply your dplyr and ggplot knowledge to visualise it and create error values**

*****

**We'd expect employment and house prices to have a positive relationship but what's the magnitude of the relationship, how much does it vary between places and has it changed over time?**

To look at this, **we'll combine house price data with employment data** so that we have these in their own columns:

* **Average house price per ward for a range of TTWAs, for 2001 and 2011**
* **Percent of employed people in those wards for 2001 and 2011**

We'll look at the same house price data, but this version is subsetted to:

> **2001 and 2011 so we can compare to employment data from the Censuses in those years.**
> **Only TTWAs that have wards with 30 or more sales in each time period.**

*****

If you like, **there’s the option of skipping ahead a few steps and just loading the pre-prepared data** for the regressions. Otherwise, **let's start by loading another subset of the sales data**:


```r
sales <- readRDS('data/sales2001and2011wardsWithMoreThan30sales.rds')

#Note it's already got year in
names(sales)
```

```
##  [1] "price"              "date"               "postcode"          
##  [4] "type"               "Eastings"           "Northings"         
##  [7] "wardcode"           "ttwa"               "ttwa_code"         
## [10] "localauthority"     "localauthoritycode" "year"
```

And this is the employment data: the columns **2001** and **2011** contain the **percent of economically active people in employment** in that ward.


```r
employment <- read_csv('data/percentEmployedByWard2001n2011.csv')
```

Now, as before, the job is just to:

* **summarise the housing data: average price per ward and per year** - with the added detail that we want to **keep the TTWA name these wards are in.**
* **Join this summary with the employment data**, linking on **year** and **ward**.

Notice the trick used in **summarise** here to keep the TTWA name in the summary: **using max(ttwa)**. What does this do? In short: it's a way of easily grabbing a column we want in our summary, if we know there's a single value per group. (The **sales** dataframe has already had its wards set to only be in one TTWA.)


```r
#Average price per ward per year
priceSummary <- sales %>% 
  group_by(year,wardcode) %>% 
  summarise(meanprice = mean(price), count =n(), ttwa =max(ttwa))
```

```
## `summarise()` has grouped output by 'year'. You can override using the `.groups` argument.
```

```r
#p.s. if we wanted to find the modal ttwa, we could use this.
#ttwa = names(which.max(table(ttwa))
```

As the **employment** data has one column for each year, this has to be **made into long-form.** The two can then be **joined** using inner_join again to keep only wards common to both:


```r
empLong <- employment %>% 
  gather(key = year, value = percentEmployed, `2001`:`2011`) %>% 
  mutate(year = as.numeric(year))

avpriceplusemp <- inner_join(priceSummary,empLong,
                             by = c('year','wardcode'))

#count of wards per ttwa / year
table(avpriceplusemp$ttwa, avpriceplusemp$year)
```

```
##                           
##                            2001 2011
##   Blackburn                  50   50
##   Bradford                   32   32
##   Brighton                   54   54
##   Cambridge                  67   67
##   Doncaster                  21   21
##   Hull                       61   61
##   London                    926  926
##   Middlesbrough & Stockton   71   71
##   Oxford                     66   66
##   Poole                      24   24
```

**Here's the pre-prepared and joined price and employment data, if you skipped the last chunk:**





```r
avpriceplusemp <- readRDS('data/avpriceplusemp.rds')
```

*****

So: **the aim is to do a regression of house price on employment for each TTWA, using its wards as data points.** Before attempting multiple regressions, though, let's **work through a single regression** to see what needs to happen.

We'll be using **log of house price** as the dependent variable and using this to tell us about **percentage change**. And we'll even use **R's base plotting function to quickly look at it.**



```r
#test a single regression, look at plot.
#Pull out a single year and TTWA
testinz <- avpriceplusemp %>% filter(year == 2001, ttwa == 'Bradford')

#run the regression and look at a summary - log of house price as 
rez <- lm(data = testinz, formula = log(meanprice) ~ percentEmployed)
summary(rez)
```

```
## 
## Call:
## lm(formula = log(meanprice) ~ percentEmployed, data = testinz)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.27890 -0.16621  0.02439  0.13770  0.31521 
## 
## Coefficients:
##                 Estimate Std. Error t value Pr(>|t|)    
## (Intercept)     4.804860   0.760030   6.322 5.69e-07 ***
## percentEmployed 0.066004   0.008179   8.070 5.22e-09 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.1921 on 30 degrees of freedom
## Multiple R-squared:  0.6846,	Adjusted R-squared:  0.6741 
## F-statistic: 65.13 on 1 and 30 DF,  p-value: 5.223e-09
```

```r
#Look at the data and the estimated regression line
plot(log(testinz$meanprice) ~ testinz$percentEmployed)
abline(rez)
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-144-1.png" width="672" />

In Bradford in 2001, an employment increase of 1% was associated with a house price increase of about 6.6%.

But how to get the coefficients out of the ugly table and into a lovely graph? You'll have to work this out for whatever model type you use, but for **lm** it looks like this. Read the comments...


```r
#Get a model summary object
rezsummary <- summary(rez)

#Some things like R-squared are easily accessible... 
rezsummary$r.squared
```

```
## [1] 0.6846464
```

```r
#But we want the slope coefficient and standard error.
#Coefficients are stored in a matrix...
rezsummary$coefficients
```

```
##                   Estimate  Std. Error  t value     Pr(>|t|)
## (Intercept)     4.80485956 0.760030304 6.321932 5.690004e-07
## percentEmployed 0.06600402 0.008178535 8.070397 5.223239e-09
```

```r
#... so we just reference using row and column position to get them:
rezsummary$coefficients[2,1] # coefficient for employment 
```

```
## [1] 0.06600402
```

```r
rezsummary$coefficients[2,2] # standard error
```

```
## [1] 0.008178535
```

Now we know **where to find the coefficients and standard errors** all that needs to happen is: **find a way to repeatedly run the model for each TTWA.**

We've already used a **for loop** to iterate over a process. R has a few other methods for iterating over groups of objects - and again the **tidyverse** provides a really neat version: the **map** function from the **purrr** library.

Since we've already used **summarise**, this is a good way to think about how **map** works. The notation is lengthy to explain - check the **R for data science** book if you want to know more. But this allows us to pull out the price means from each TTWA into a variable (of `double' format, i.e. can have good decimal precision).

> **Note: split is a base-R function that *splits* a dataframe into a bunch of dataframes, based on the category passed in. So this is splitting the sales dataframe into smaller ones for each TTWA.**

**The purrr library should be already loaded as part of the tidyverse library.**


```r
x <- sales %>% 
  split(.$ttwa) %>% 
  map_dbl(~mean(.$price))

x
```

```
##                Blackburn                 Bradford                 Brighton 
##                 74787.08                 78759.26                186405.66 
##                Cambridge                Doncaster                     Hull 
##                189188.19                 76228.50                 85228.74 
##                   London Middlesbrough & Stockton                   Oxford 
##                277824.28                 89690.92                208710.30 
##                    Poole 
##                189531.80
```




The notation used makes it very easy to create tidy iterations. And here, we can break down the process of running many models and pulling out the numbers of interest **using exactly the same approach we just used to get those means**. First, **running a linear model on each TTWA for 2001**. Note we combine map with the **dplyr filter** verb.



```r
models <- avpriceplusemp %>% 
  filter(year == 2001) %>% 
  split(.$ttwa) %>% 
  map(~lm(log(meanprice) ~ percentEmployed, data = .))
```

And to check we can now use those models to access the coefficients in the way we previously worked out:


```r
models %>% 
  map(summary) %>% 
  map_dbl(~.$coefficients[2,1])
```

```
##                Blackburn                 Bradford                 Brighton 
##               0.11050658               0.06600402               0.02570804 
##                Cambridge                Doncaster                     Hull 
##               0.09532273               0.12828774               0.08965422 
##                   London Middlesbrough & Stockton                   Oxford 
##               0.03491091               0.07675510               0.06060024 
##                    Poole 
##               0.10562224
```

**Tick!** Great. Now what? Well, **we can use this repeatedly to directly create a dataframe.** So using the check code we just tested and two others, the following code does this:

* **Creates a dataframe of coefficients and standard errors (and pulls out the TTWA names in the process)**
* **Uses mutate to multiply the coefficients by 100 to give percentages**
* **Then uses mutate again to create a 95% confidence interval using the standard error**


```r
alloutput <- data.frame(
  
  names = models %>% 
    map(summary) %>% 
    map_dbl(~.$coefficients[2,1]) %>% names,
  
  coeffs = models %>% 
  map(summary) %>% 
  map_dbl(~.$coefficients[2,1]),
  
  se = models %>% 
  map(summary) %>% 
  map_dbl(~.$coefficients[2,2])
  
) 

#Multiply by 100
alloutput <- alloutput %>% 
  mutate(
    coeffs = coeffs * 100,
    se = se * 100
    )

#add in some min/max confidence intervals from standard error
alloutput <- alloutput %>% 
  mutate(
    minn = coeffs - (se * 1.96),
    maxx = coeffs + (se * 1.96)
  )
```

As always, **take a look at the resulting dataframe.** We've got everything we need to plot. But notice the new thing here:

> **geom_errorbar takes in values for ymin and ymax from the data**: these geoms in ggplot are **not** doing any of their own stats - you need to supply the mins and maxes directly, which is why we calculated them. (This gives us a lot more flexibility about what we want to show.)


```r
ggplot(alloutput, aes(x = fct_reorder(names,-coeffs), y = coeffs)) +
  geom_point(size = 5) +
  geom_errorbar(aes(ymin = minn, ymax = maxx), width = 0.5) +
  coord_flip()
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-151-1.png" width="672" />

As a last exercise: **how would you go about running the models for both decades and then comparing?** The aim, as with all **ggplots**, would be to have **year in its own column** so it can be mapped to an aesthetic. You could also use **dodge**.

You could just re-run the code above, changing the year in **filter** to 2011. But another option is to **turn the above code into a function**. Doing this provides another way of iterating your code. Some points on functions:

* **As we've already said, R is a functional language: everything is a function, and they can all be composed together in whatever way produces valid output.**
* Functions are just **input/output machines**: you just need to tell it what goes in and what you want out.

A basic function might look like this. This is obviously a trivial example but the idea applies to anything more complex - the structure of writing one is exactly the same. Say we want to know: is a number divisible by two? (As if this isn't obvious, but this illustrates the principle!)


```r
isDivisibleByTwo <- function(x){
  
  #Use R's modulus operator %% - gives the remainder from dividing by a number
  result <- x %% 2
  
  output <- ifelse(result == 0, TRUE, FALSE)
  
  #We could also do this as the remainder from 2 is only 1 or 0
  #and R interprets 1 and 0 as TRUE and FALSE
  #return(!as.logical(x))
  
  #By default, an R function will return the last created variable. 
  #Or you can tell it explicitly what to return like this.
  return(output)
  
}
```

You then need to highlight the whole code block and run it, as usual. Nothing will happen - except **you'll now see the function name in the environment panel.**

Once that's done, your new in-out machine should work:


```r
isDivisibleByTwo(46)
```

```
## [1] TRUE
```

```r
isDivisibleByTwo(127)
```

```
## [1] FALSE
```

The principle of building functions is simple: **where possible, put what doesn't change into a function, pass what *does* change as *arguments* to the function.** In this simple case, it's our number we want dividing by two that changes. (Note: the name of the variable is arbitrary: whatever you pass in will be assigned to it.)

> **So: how would you apply this to the model-running code? Here are some ideas.**

* The only thing that changes is the year: it's either 2001 or 2011. Everything else can be the same as the code used above.
* All of this code could go inside the function:
    + The first **models <- avpriceplusemp** code, where currently year is set to either 2001 or 2011. It's here we'd use the value passed into the function.
    + Then the code creating the **alloutput** dataframe. This is the thing we want the function to return.

There would also be nothing wrong with adding the extra year column in the function itself - but you would need that for creating **a single year column** that ggplot can use to map to an aesthetic.

> **Note: you can view a working version of this function in the file containing all the code, in the project folder, if you want to see how it's put together to help write your own / cheat!**


```r
#Pass a year into the function, then add a column to mark the year.
model01 <- modelz(2001) %>% mutate(year = 2001)
model11 <- modelz(2011) %>% mutate(year = 2011)

#Both will be the same structure - combine the rows from both
bothmodels <- rbind(model01,model11)
```

And with the addition of **position = 'dodge'** in **geom_errorbar**, this could be used to create the following. Note here we're setting **dodge spacing** directly so we can control the point **and** error bar position to both match each other:

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-155-1.png" width="672" />

Again, the **R for Data Science** book has a lot more on functional programming - hopefully this gives a hint of its power.

***********

## A little bit of mapping

In this section, we'll take a quick look at three different ways to make maps from the housing data:

* The first two use ggplot again, to show two very simple ways it can be used to view geographical data. ggplot can do a lot more, but this is a start.
* Then we'll introduce a couple of new libraries: **the simple features (sf) library** and **tmap** for making maps.

The **sf library** is relatively new: it's particularly great because it works excellently with all the ***dplyr** data wrangling skills you've already learned. We'll run through an example of doing that.



### One simple way to use ggplot for mapping: the 2D geoms

A really simple way to make quick maps is to use ggplot's **2D geoms**. One of these included on the ggplot cheatsheet - **geom_bin2d** - does a single job: as the help says, if you have two dimensions of continuous data, it:

> divides the plane into rectangles, counts the number of cases in each rectangle, and then (by default) maps the number of cases to the rectangle's fill.

We have exact postcode locations for each sale: these can be our two dimensions. So in practice that means we can easily make a map using this geom that **counts how many sales there are in each rectangle**. First, let's re-load the sales data (adding the year column back in) and subset to London:


```r
sales <- readRDS('data/landRegistryPricePaidTopTTWAs.rds')
sales$year <- year(sales$date)

london <- sales %>% filter(ttwa=='London')
```

Then try the new geom, subsetting to a single year:


```r
ggplot(london %>% filter(year == 2018), aes(x = Eastings, y = Northings)) +
  geom_bin2d()
```

A map! It could with a few little extras. The next version shows that you can:

* Control the number of bins by defining their dimensions. This geographical data is in British National Grid projection: **Easting and Northing units are in metres.** So we can make a map with 1km square grid by **setting bin width to 1000.** As with geom_bar and other bin stats, this is set in the geom itself. 
* Pick a colour scale, as we've done before - but with one difference: use **distiller**. This is for continuous variables: it distills continuous values from color brewer's discrete scales. (You can also add **trans = 'log'** into this function if you want a log fill scale showing the correct values.)
* **coord_fixed** does what the name suggests: the x and y axis are fixed relative to each other. It's also possible to set a ratio for the two of them - check the help file.
* **theme_void()** drops almost all extras from the graph, just leaving the data itself and the guide/legend.



```r
ggplot(london %>% filter(year == 2018), aes(x = Eastings, y = Northings)) +
  geom_bin2d(binwidth = c(1000,1000)) +
  scale_fill_distiller(palette = 'Spectral') +
  coord_fixed() +
  theme_void()
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-158-1.png" width="672" />

**But what about things other than count?**

What if we want to, say, **find the median sale value per square?** ggplot has a **stat** for that - though it's not listed on the cheatsheet: **stat_summary_2d**. This gives us total control over what goes into each square. The only extra thing we need to do here:

> **Provide a z value**: this will be the column used in the grid square statistic. So we'll use price.

stat_summary_2d's default is to give you the mean, but we can provide any function we like. So here's the median (and we're including all the other extras we added to the last one). Note, we've only changed three things: the geom used, and adding 'z = price' into the aesthetic. We've also done as mentioned above: told the fill scale **we want a log transformation:**



```r
ggplot(london %>% filter(year == 2018), aes(x = Eastings, y = Northings, z = price)) +
  stat_summary_2d(fun = median, binwidth = c(1000,1000)) +
  scale_fill_distiller(palette = 'Spectral', trans = 'log') +
  coord_fixed() +
  theme_void()
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-159-1.png" width="672" />

Try finding the **minimum** and **maximum** property value per square (using the min and max functions). This reveals something interesting about the difference in property types in the centre versus the outskirts.

> **You have a couple of options now:** you can skip ahead to the next section if you want to do some proper mapping with actual map data, get to use the simple features package and learn how to wrangle spatial data.

> Or the last part of this section just shows quickly how to use the **map** function from the **purrr** library (also used in the 'pulling out multiple values' section) to get around a problem with using facet (see the facet section).


### Using cowplot to get around the facetting problem

As the section above on facetting shows, **ggplot** can be used to 'facet' produce many sub-plots based on a factor, like property type. However, facets all **keep the same colour scale**. This can be a problem if e.g. the count of flats and detached houses is very different: each individual map will have its scale compressed and look flat and boring.

One workaround: **create a number of individual plots and then combine them.** We can do this with the **cowplot** library. As always, use **install.packages** if this isn't already installed.


```r
library(cowplot)
```

This library can be used to **very neatly arrange multiple ggplots.** 

So let's aim to make a single plot showing the **count of each different property type**. We can start with the same code we just wrote for getting a count of properties per grid square, except subset to single property types:


```r
flats <- london %>% filter(type == 'F')

flatplot <- ggplot(flats %>% filter(year == 2018), aes(x = Eastings, y = Northings)) +
  geom_bin2d(binwidth = c(1000,1000)) +
  scale_fill_distiller(palette = 'Spectral') +
  coord_fixed() +
  theme_void()

flatplot


terraces <- london %>% filter(type == 'T')

terraceplot <- ggplot(terraces %>% filter(year == 2018), aes(x = Eastings, y = Northings)) +
  geom_bin2d(binwidth = c(1000,1000)) +
  scale_fill_distiller(palette = 'Spectral') +
  coord_fixed() +
  theme_void()

terraceplot
```

We can see how **cowplot** works now just with these two. We can combine multiple plots just by supplying them to **plot_grid**:


```r
plot_grid(flatplot,terraceplot)
```


But how to avoid having to manually create each plot? There are several options, but here's a neat one using **purrr**. All this does:

> Uses base R's **split** function to split the dataframe into each house type
> Passes each subgroup to the map function. 
> Note, this is **exactly the same ggplot code we just used** (except we're filtering to 2018 in the first line). The *only* other difference: we've **replaced the dataframe name with the dot operator**. The dot stands in for each of the smaller dataframes that **map** passes in.
> Note also the tilde (~): that's just shorthand for passing into a function.


```r
plots <- london %>%
  filter(year == 2018) %>% 
  split(.$type) %>% 
  map(
    ~ggplot(., aes(x = Eastings, y = Northings)) +
      geom_bin2d(binwidth = c(1000,1000)) +
      scale_fill_distiller(palette = 'Spectral') +
      coord_fixed() +
      theme_void()
  )
```

All that's done is map each of the plots we were previously doing manually to a list. We could view any of them by looking at the list directly. For example, here's the first:


```r
plots[[1]]
```

Now that whole list can just be passed directly into cowplot's plot_grid. (We're also now telling cowplot the number of rows and columns we want):



```r
plot_grid(plotlist = plots, ncol = 2, nrow = 2)
```

OK, looking good. There are a couple of things it would be nice to do now. See if you can work out how. Some hints:

* We need to label each house type. Using info from the 'prettifying' section, can you use **ggtitle** to add that in? Hint: use the 'max' trick, also used in the 'pulling out multiple model values' section to get a single value from the type column. There will only be e.g. a single 'F' repeated in the flats sub-dataframe, so you can pull that out be e.g. doing this. You just need to use the dot operator instead.


```r
max(flats$type)
```

* Coordinates for each plot are currently different, because ggplot adjusts each to its min and max range. We could do with **setting them to be the same**. Hint: in the prettifying section, we used coord_cartesian and set the plots **xlim** values. We can set them here directly in coord_fixed. The limits we're after are just the minimum and maximum for both eastings and northings. These could be dropped directly into the right place in coord_fixed...


```r
range(london$Eastings)
range(london$Northings)
```

The result should look something like this:

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-168-1.png" width="672" />

*****

## Making a map using the simple features library, tmap and a bit of wrangling

Another way to map data is the **simple features library**. As always, if it's not installed, do so with:


```r
install.packages('sf')
```

And then load it:


```r
library(sf)
```

The **sf** library has been designed from the ground up to work with the **tidyverse** - so any kind of wrangling you've already learned can be used here too. 

If you want to learn more, take a look at the excellent free online book [Geocomputation with R](https://geocompr.robinlovelace.net/) by Robin Lovelace, Jakub Nowosad and Jannes Muenchow. We'll just be making a map here, but **sf**, combined with the **tidyverse**, is a powerful spatial analysis and manipulation tool.

**We'll start by loading some map data - London wards.** All we'll then do is make a map of the average house price per ward.



```r
#Note it appears as a standard dataframe. But look, geometries!
londonwards <- st_read('data/mapdata/londonwards.shp')
```

```
## Reading layer `londonwards' from data source `C:\Users\admin\Dropbox\Training\R_PrinciplesOfViz_and_Datawrangling_2021\data\mapdata\londonwards.shp' using driver `ESRI Shapefile'
## Simple feature collection with 962 features and 1 field
## Geometry type: MULTIPOLYGON
## Dimension:     XY
## Bounding box:  xmin: 501183 ymin: 149641 xmax: 576444 ymax: 208030
## Projected CRS: Transverse_Mercator
```

Take a quick look at the loaded spatial data. You can just use **plot(londonwards)** but that gives one map per column by default. To just check it's looking correct, you can use:


```r
plot(st_geometry(londonwards))
```

Let's also reload the house sales data just for those London wards:


```r
#Use London-only ward subset:
sales <- readRDS('data/landRegistryPricePaid_LondonWards.rds')

#Add year column back in
sales$year <- year(sales$date)
```

The plan is to link these two - it's always a good idea to make sure the link columns are behaving and there are no bad links. A good way to do this is just to **table up a question: are the london wardcodes present in the sales wardcodes?** 


```r
#Check there's a good link between the mapping and housing data. Tick.
table(londonwards$wardcode %in% sales$wardcode)
```

```
## 
## TRUE 
##  962
```

All true - so yes, it's fine, we'll be able to successfully link the mapping and housing data on that column.

Now, we'll just do as we've previously done: find a **summary of the housing data per geographical zone**, ward in this case. And filter down to a single year:



```r
#Summarise
salesSummary <- sales %>%
  filter(year==2018) %>% 
  group_by(wardcode) %>% 
  summarise(meanprice = (mean(price)/1000) %>% as.integer(), count = n())
```

So now that gives us **single wards in each row** (check by looking via the environment panel), each one summarised with a mean and count of sale number.

We can now **link this summary to our mapping data** using the same **dplyr** join functions we've already used. But note, there's little wrinkle here. Let's run this twice, but with the dataframes in a different order:



```r
london1 <- inner_join(salesSummary, londonwards, by = 'wardcode')
london2 <- inner_join(londonwards, salesSummary, by = 'wardcode')

class(london1)
```

```
## [1] "tbl_df"     "tbl"        "data.frame"
```

```r
class(london2)#Only this one is spatial
```

```
## [1] "sf"         "data.frame"
```

Both dataframes look the same if viewed but, if we check the class, only the second has "sf" as its first class. The lesson: **if you're joining spatial sf data and want to keep the spatial part, put it first in a join.** There are ways around that but this is the easiest way.

**We're now ready to make a map.** This will require a new library: **tmap**. As always, install first if it's not already installed, and then load:


```r
library(tmap)
```

And then we can jump straight into making a map. All we do is **supply the column value we want to plot in tm_polygons:**



```r
tm_shape(london2) +
  tm_polygons("meanprice")
```

A map! But it needs a few extras. First-up, you may want to pick a better colour scheme. As with color brewer, there's a function for looking at all the options:


```r
tmaptools::palette_explorer()
```

There are a few other tweaks added here as well - the [tmap help files](https://cran.r-project.org/web/packages/tmap/index.html) explain the vast number of others available to you. That includes a great [getting started](https://cran.r-project.org/web/packages/tmap/vignettes/tmap-getstarted.html) page.

Here, we make these additions:

* Set the style to 'jenks': this makes for a better visual spread of values. 
* Set the number of legend categories with n to get a nicer spread.
* Set the palette, having picked one from the palette explorer. (Just put a minus before the palette name to reverse its order.)
* Reduce the border alpha so it doesn't block the polygons as much. (See the 'prettifying' section for more on alpha values: 0 is totally transparent; 1 is opaque.)
* Move the legend outside of the main map box. This is a quick way to make sure legends don't clash with the map. See the **?tm_layout** help for a load more legend positioning options.



```r
tm <- tm_shape(london2) +
  tm_polygons("meanprice", style = 'jenks', n = 10, palette = 'viridis', border.alpha = 0.3) +
  tm_layout(
    legend.outside = T,
    legend.position = c(0.05,'center')
    )

tm
```

And because we've assigned the map to a variable, we can also save it:



```r
tmap_save(tm, filename = "images/londonhouseprices_ward2018.png")
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-180-1.png" width="576" />

*****

### A last little ggplot mapping example


We've already seen at the start, if you have point coordinates you can map these to the x and y axes to get an idea of the geography of your data.

Here, we just combine this idea with **dplyr's summary ability** to ask:

> **What's the most common type of house in each postcode in London?**

To do this, we'll apply a simple function that finds the modal property type. The general principle here is: **you can use any function in summarise**. 

So it's the same sales data, containing the London TTWA. And we reduce it to London:


```r
sales <- readRDS('data/landRegistryPricePaidTopTTWAs.rds')

london <- sales %>% filter(ttwa == 'London')
```

Then it's good old **dplyr** again for finding the mode. Note we can use **max** here as the data has been **grouped by postcode** - we only have one location value per postcode, so the max is correct.


```r
cityModalTypes <- london %>% 
  group_by(postcode) %>% 
  summarise(mode = names(which.max(table(type))),
             Eastings = max(Eastings),
             Northings = max(Northings)) 
```

To see how the mode is found, take some time to break down the full list of functions and check the help files too:


```r
table(city$type)
which.max(table(city$type))
names(which.max(table(city$type)))
```

As in the facetting section, we can also recode the property type to something more sensible:



```r
cityModalTypes <- cityModalTypes %>% 
  mutate(mode2 = fct_recode(mode,
    'flat' = 'F',
    'terrace' = 'T',
    'semi' = 'S',
    'detached' = 'D'
  )) %>% 
  mutate(mode2 = fct_relevel(mode2,
    'flat',
    'terrace',
    'semi',
    'detached'
  )) 
```

And then plot! A couple of extras here to notice:

* We set the shape by number: the **ggplot** cheatsheet has a little guide to the available shape codes.
* the **guides** function is used to make the categories more clear - otherwise it defaults to the displayed size which, in this case, would be tiny.
* **labs** is used to remove the legend title - it's clear enough from the labels what it refers to.

Now it just needs some less hideous colours...


```r
ggplot(cityModalTypes,aes(x = Eastings,y = Northings, colour = mode2)) +
  geom_point(shape = 15, size = 0.25) +
  scale_color_brewer(palette = 'Set1', direction = -1) +
  #https://stackoverflow.com/questions/20415963/how-to-increase-the-size-of-points-in-legend-of-ggplot2
  guides(colour = guide_legend(override.aes = list(size=10))) +
  coord_fixed() +
  labs(colour = '') +
  theme_void()
```

<img src="02_viz_n_wrangling_files/figure-html/unnamed-chunk-185-1.png" width="672" />




*****

# Data sources

The original data used in the workshop can be downloaded here:

* Land registry 'price paid' data: [www.gov.uk/government/statistical-data-sets/price-paid-data-downloads](https://www.gov.uk/government/statistical-data-sets/price-paid-data-downloads)
* 'Code-point open' postcode data containing geolocations for each postcode - scroll down the list here: [www.ordnancesurvey.co.uk/opendatadownload/products.html](https://www.ordnancesurvey.co.uk/opendatadownload/products.html) 
* Employment / 'economically active' data from the English 2001 and 2011 Census. My version is a bespoke geographically harmonised dataset - the original data is available at [CASWEB](http://casweb.ukdataservice.ac.uk/). If anyone is interested in the harmonised dataset, get in touch.
* Wage data for English local authorities: [NOMIS official labour market statistics](https://www.nomisweb.co.uk/)
* Ward map data from [borders.ukdataservice.ac.uk](https://borders.ukdataservice.ac.uk/bds.html)


