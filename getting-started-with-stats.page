---
title: Getting started with ... Stats
created: 2017-04-27
author: Haoyang Xu
description: some basic statistics concepts
status: in progress
type: rational
importance: 5
tags: test, statistics, descriptive
...

What is statistics?
===================

We measure things. In practice, there are two major difficulties: 1)
there are too many things of the same kind, and it is not possible to
measure every one of them; 2) you cannot eliminate errors when you
measure, so different individuals gives you different measurements, even
multiple measurement of the same individual yields different results;
how do you describe this character being measured for the whole
population of this kind of things?

Staticstics was invented to solve this problem. In short, it a)
describes the similarity and variation of measurements (scores) within a
group of individuals (sample) that you can measure, which is called
**descriptive statistics**; and b) help us estimate the characteristics
in question in a larger group, which we often cannot or should not
measure one by one, and this is called **inferential statistics**.

Descriptive statistics
======================

When we obtain scores over a sample, the first things that we need to
know are: what are these values? What is the maximum and the minimum
value? How large are the differences between the scores? What
information do the values tell us as a whole? These questions are
answered by descriptive statistics.

Central tendency
----------------

Central tendency tells you where the typical or common value is in your
sample's scores. The mostly widely used central tendency measures are
(in that order): the mean, the median, and the mode.

### The Mean

Just the arithmetic mean of all scores in the sample.

$$
      \bar{X} = \frac{\sum_{i=1}^{n}{X_{i}}}{n}
$$

where \\(n\\) is sample size, \\(X_{i}\\) is the score for the individual \\(i\\).

**In R**, the mean is calculated with

``` r
mean(x, trim = 0, na.rm = FALSE, ...)
```

### The Median

If you sort your sample scores in ascending order, and pick the one in
the middle if you have a sample size of odd value, or the mean of the
two in the middle if you have a sample size of even value, you get the
sample's median. A median is no smaller than half of the scores in the
sample and no larger than the other half.

Median is more useful than the mean in telling you the position of the
typical value if you have some extreme values on either end of the score
distribution, or the scores are ordinal values but not interval, i.e.
the distance between values has no meaning.

**In R**, the median is calculated with

``` r
median(x, na.rm = FALSE)
```

### The Mode

The mode is simply the value that appears most frequently in the sample
scores. Note that in some samples, there may be two or more modes. These
are called bimodal and multimodal distributions. Also note that the mode
is not necessarily close to the mean.

**In R**, you can use such a function to find mode numbers for a
univariate sample:

``` r
Mode <- function(x) {
  ux <- unique(x)
  tab <- tabulate(match(x, ux)); ux[tab == max(tab)]
}
```

Alternatively you can use `modeest` package.

Dispersion
----------

Dispersion tells you how large are the differences between scores. Some
measurements here, namely variance and standard deviation, are basis of
inferential statistics later, as they combined with central tendency
give us ideas about where to expect scores in the population.

### The Range

The range is the distance between the largest and the smallest value in
the sample. It is often reported with the max/min values.

$$
      R = X_{\text{max}} - X_{\text{min}}
$$

**In R**, the range is calculated with

``` r
range(..., na.rm = FALSE)
```

Note that it reports the min and max values in a pair, not the range
itself.

### The Interquartile Range

The interquartile range is less influenced by extreme values than the
range. As finding the median, you sort the scores, find the median and
divide the samples into two groups, and find the medians in the two
groups respectively. If you find the medians by calculating means, use
the larger score. The distance between the two values you find is the
interquartile range.

**In R**, the interquartile range is calculated with

``` r
# assuming continuous sample
IQR(x, na.rm = FALSE, type = 7)
```

### Variance

Variance indicates the average of the amount of dispersion in a
distribution of scores. To calculate variance, you add the distances of
each score from the mean together and divide the sum by population size.
But by definition, if you just add positive and negative distances
themselves, the result would be 0. So the differences are squared first.

Therefore, for the population's variance:

$$
      \sigma^{2} = \frac{\sum{(X-\mu)}^{2}}{N}
$$

where \\(N\\) is the size of the population, \\(\mu\\) is the population mean.

For the sample's variance, because the mean of the sample is a parameter
calculated with all the sample scores, the degree of freedom is 1 less
than the sample size:

$$
      s^{2} = \frac{\sum{(X-\bar{X})}^{2}}{n - 1}
$$

where \\(\bar{X}\\) is the sample mean, and \\(n\\) the sample size.

**In R**, variance is calculated with

``` r
var(x, y = NULL, na.rm = FALSE)
```

### Standard Deviation

SD is the typical deviation between individual scores in a distribution
and the mean of the distribution.

It is simply calculated by obtaining the square root of variance.

**In R**, the sample's SD is calculated with `sd` from `stats` package.

``` r
sd(x, na.rm = FALSE)
```

Standardization and z-score
---------------------------

z-score is a quick way to describe how far the score is from the mean.

$$
     z = \frac{X - \bar{X}}{SD}
$$

So, if \\(X\\) is 0.5 SD larger than the mean, its z-score is 0.5. If \\(X\\) is
1 SD smaller than the mean, its z-score is -1.

**In R**, z-scores can be calculated with

``` r
scale(x, center = TRUE, scale = TRUE)
```

Inferential statistics
======================

Inferential statistics is used when we know some characteristics of the
sample, and want to infer whether such characteristics exist in the
larger population.

Standard error of the mean
--------------------------

Suppose we have a population. We randomly draw a sample, calculate its
mean. Then we put the sampled individuals back into the population, and
randomly draw another sample, we can again calculate its mean. Repeat
this a few (hundred) more times, the means you calculated forms a
distribution, called **the sampling distribution of the mean**, and the
standard error of the mean is the standard deviation of this sampling
distribution of the mean.

Because of the [central limit
theorem](https://en.wikipedia.org/wiki/Central_limit_theorem), the
sampling distribution of the mean will be approching normal
distribution. This makes standard error an indispensible tool in
inferential statistics.

Standard error of the mean is calculated from SD and sample size like
this:

$$
     S_{e} = \frac{SD}{\sqrt{n}}
$$

**In R**, you can use the above equation, or use `std.error` from the
`plotrix` package.

t distributions and t-value
---------------------------

t distributions are a family of symmetrical distributions. They describe
the probability distributions that arise when estimating the mean of a
normally distributed population when the sample size is small and the
population SD is unknown. The larger the sample, the closer t
distribution resembles the normal distribution. When sample size is
around 120, t distribution is almost identical to normal distribution.

Similar to z-score describing a score relative to the mean, t-value
describes how far the sample mean is from the population mean, with the
unit being standard error, given a certain sample size (degree of
freedom). With t-value, we can lookup what is the probability of
obtaining such a sample mean, if we know the population mean. In
reverse, we can tell the probability that the population mean is to an
extent near the sample mean we obtained. Thus inferring parameters of
population from those of samples is possible.

The t-value is calculated with the population mean, the sample mean and
SE like this:

$$
     t = \frac{\bar{X} - \mu}{S_e}
$$

**In R**, you can use `dt` in `stats` package to calculate the
probability of obtaining a certain t-value by chance in sampling.

Statistical significance and hypothesis testing
-----------------------------------------------

Suppose a theory declares that a measurement of population should have a
mean value of \\(\mu\\), while a study of a sample from the population
yields a mean value of \\(\bar{X}\\) that is different from \\(\mu\\). Is the
difference due to chance (random sampling error) or indicating an error
in theory?

The hypothesis that observed difference is due to chance is called null
hypothesis, and the other is called alternative hypothesis. In most
cases, only when statistics tells us that the probability that null
hypothesis is valid is less than 0.05, can we claim that the observed
difference is significant, i.e. alternative hypothesis is valid. To
calculate the probability, we calculate the t-value, then lookup the
corresponding probability. A large t-value means the alternative
hypothesis is more likely.

Confidence interval of the mean
-------------------------------

Suppose a randomly selected sample of size \\(n\\) yields a mean of
\\(\bar{X}\\), how can we estimate the population mean \\(\mu\\)? We can almost
be certain that \\(\mu \neq \bar{X}\\). What we care about, is how large the
range around \\(\bar{X}\\) should be, if we are 95% or 99% sure that \\(\mu\\)
is in this range.

This range is called 95% confidence interval or 99% confidence interval,
the formula to calculate it is

$$
\begin{eqnarray}
     CI_{95} & = & \bar{X} \pm t_{95}S_e \\
     CI_{99} & = & \bar{X} \pm t_{99}S_e
\end{eqnarray}
$$

\\(t_{95}\\) and other t-values corresponding to the confidence required can
be found by looking up a t distributions table. **In R**, you can use

``` r
qt(.95, df)
```

to get the \\(t_{95}\\) value given sample size (degree of freedom) `df`.

Correlation
-----------

When we measure two or more variables, the question of correlation often
pops up. In many cases, we raise correlation questions to begin with
("is the amount of people entering the mall related to weather?").

We calculate correlation coefficients, to see how strong the correlation
is between variables. The most used may be the Pearson product-moment
correlation coefficient. To calculate it, we first standardize the
variables \\(X\\) and \\(Y\\), to convert them to z-scores. For each case in the
sample, we multiply its \\(X\\) variable's z-score by its \\(Y\\) variable's
z-score, add up the products for all the cases, then divide the sum by
the sample size:

$$
     r = \frac{\sum{z_{x}z_{y}}}{N}
$$

The coefficient will be between -1 and 1. Higher absolute value means a
strong correlation and 0 means no correlation at all. Positive value
indicates a positive correlation.

**In R**, Pearson correlation coefficient can be calculated with

``` r
cor(x, y, method = "pearson")
```

When \\(X\\) is a continuous variable and \\(Y\\) a naturally two-category
nominal variable, one can use a special case of Pearson coefficients
called
[point-biserial](https://en.wikipedia.org/wiki/Point-biserial_correlation_coefficient).

**In R**, point-biserial coefficient can be calculated with
`biserial.cor` from the `ltm` package.

If both \\(X\\) and \\(Y\\) are dichotomous variables, one can use a phi
coefficient, or use chi-square analysis. Phi coefficient is yet another
special case of Pearson coefficient.

**In R**, you can use `phi` from the `psych` package to calculate phi
coefficients.

If one of the variable is an ordinal but not interval variable, one
should use Spearman's rho coefficient. It is, you guessed right, another
specialized form of Pearson coefficient.

**In R**, you can use the same `cor` function, with `method` =
`"spearman"`.

### Significance of correlation

The correlation coefficient \\(r\\) can tell us whether a correlation exists
between two variables in the sample. But is the correlation significant?
Can we say the correlation exists in the population? We use the
versatile t distributions again to answer the question.

The t value for the correlation is

$$
      t = \frac{r - \rho}{s_r}
$$

where \\(r\\) is the sample correlation coefficient, \\(\rho\\) is the
population correlation coefficient, for a null hypothesis it is 0, and
\\(s_r\\) is the standard error of the sample correlation coefficient.

\\(s_r\\) can be calculated with the following formula:

$$
      s_r = \sqrt{(1 - r^2) + (N - 2)}
$$

where N is the sample size.

So the formula for calculating \\(t\\) can be written as

$$
      t = r \sqrt{\frac{N - 2}{1 - r^2}}
$$

Then we can obtain the probability that null hypothesis is true by
looking up tables.

### The coefficient of determination

\\(r^2\\) actually denotes how much variance is shared between the two
variables, if you look closely. So the value of \\(r^2\\) is interpreted as
how much variance in one variable can be explained by the variance in
another.

### Correlation and causality

Correlation does not imply causality. In many cases, the logical
relationship between the two variables is not directly explained by
their correlation. Maybe a third unobserved variable causes both
variables to change. Maybe the two have no relationships whatsoever and
we are observing "artifacts".

On the other hand, if you want to prove the existence of causality, you
have to first prove there is correlation between the independent
variable and the dependent variable.

Independent samples t-test and pair-samples t-test
--------------------------------------------------

It is a common task in statistics that we want to know whether the
difference observed in two groups of samples are the result of
differences in the populations delinated by a grouping variable, or are
they just due to chances. If the variable in question is a continuous
interval or ratio variable, and the grouping variable is a nominal or
categorial variable that separates the samples into independent groups,
e.g. men and women, non-smokers and smokers, 3-graders and 5-graders, we
can use the independent samples t-test to see if the differences are
statistically significant.

The basic idea is the same as estimating the probability of the
population parameter falling into a certain interval given the sample
parameters. We have the parameter differences between the two groups of
samples, and obtain the t-value by dividing the difference with the
standard error, then we look up a probability table to see how likely
the t-value is the result of chances alone.

For example, if we need to calculate whether the difference in the mean
of two groups of samples is significant, we use the following equation:

$$
     t = \frac{\bar{X}_1 - \bar{X}_2}{S_e}
$$

\\(S_e\\) here is the standard error of the difference between the means.
From the name you can tell it is a bit more complex than the sample's
standard error of the mean. \\(S_e\\) is calculated as follows:

$$
      S_e = \sqrt{S_{X_1}^2 + S_{X_2}^2}
$$

where \\(S_{X_1}\\) and \\(S_{X_2}\\) are the two groups' respective standard
errors of the mean ... if the two groups of samples are similar in size.
In some cases this can be a very big IF. When the two groups differ
greatly in size or variance, or the data are not normally distributed,
you may want to use some non-parametric alternatives such as
Mann-Whitney U test.

When looking up the table, the degree of freedom is the sum of two
sample sizes minus 2, because you have two parameters: the means of two
groups:

$$
     df = n_1 + n_2 - 2
$$

Paired-sample t-test answers a similar question, but in this case, each
individual in one group is paired with one individual in another group
in some way. For example, we want to look at the effect of father's TV
watching habits on their eldest children, so we take observations of two
groups, fathers in a group, their child in another, the sample comprise
father-child pairs. Or, we do a longitudinal research, observe some
children when they are 3, then take another measure of the same
indicators at the age of 7, in this case the samples are also paired, or
dependent.

Again,

$$
     t = \frac{\bar{X} - \bar{Y}}{S_e}
$$

\\(S_e\\), the standard error of the difference between dependent sample
means, is even more complex to calculate here. You have to first
calculate the standard deviation of the difference between dependent
sample means:

$$
     SD = \sqrt{\frac{\sum{D^2} - \frac{(\sum{D})^2}{N}}{N-1}}
$$

and then calculate the standard error in the good old way:

$$
     S_e = \frac{SD}{\sqrt{N}}
$$

In this and previous equations, \\(N\\) stands for the number of pairs in
the sample. The degree of freedom in this case is \\(N - 1\\).

References
==========

-   [Statistics in Plain English,
    3rd Edition.](https://amzn.com/041587291X)

Descriptive statistics
----------------------

-   [Is there a built-in function for finding the
    mode?](http://stackoverflow.com/questions/2547402/is-there-a-built-in-function-for-finding-the-mode)
-   [R Tutorial Series: Centering Variables and Generating Z-Scores with
    the Scale()
    Function](http://www.r-bloggers.com/r-tutorial-series-centering-variables-and-generating-z-scores-with-the-scale-function/)

Inferential statistics
----------------------

-   [Student's
    t-distribution](https://en.wikipedia.org/wiki/Student%2527s_t-distribution)

