# multilinear     

## Overview
This R package is a practice for the coursework Biostat 625 at University of Michigan - Ann Arbor, which provides comparible analytical results to R built-in functions for multiple linear regression:     
* `mlr()`outputs a list of analytical results, including a summary table of coefficients, model-fitted response values, residuals of response based on the model, variance-covariance matrix and ANOVA results.     
* `coefs()`provides a brief comparible estimates of all coefficients.      
* `select.cov()`selects covariates passing a given threshold of significance.  
## Installation
```
# install.packages("devtools")
devtools::install_github("superggbond/multilinear")
```
## Usage
```
# load the package and the dataset
library(multilinear)
data(longley)
head(longley)
#>      GNP.deflator     GNP Unemployed Armed.Forces Population Year Employed
#> 1947         83.0 234.289      235.6        159.0    107.608 1947   60.323
#> 1948         88.5 259.426      232.5        145.6    108.632 1948   61.122
#> 1949         88.2 258.054      368.2        161.6    109.773 1949   60.171
#> 1950         89.5 284.599      335.1        165.0    110.929 1950   61.187
#> 1951         96.2 328.975      209.9        309.9    112.075 1951   63.221
#> 1952         98.1 346.999      193.2        359.4    113.270 1952   63.639

# run the main function mlr with default setting of decimals to be 3. 
# to keep n decimals in the results, you can use the argument "decimal = n" in the function
fit.mlr <- mlr("Employed", c("GNP.deflator","GNP","Unemployed","Armed.Forces","Population"), 
               longley)
#> The regression model is:
#> Employed ~ intercept + GNP.deflator + GNP + Unemployed + Armed.Forces + Population

fit.mlr
#> $summary
#>              Estimate Std.error t.value    p.value
#> Intercept      92.461    35.169   2.629 0.02520371
#> GNP.deflator   -0.048     0.132  -0.366 0.72166022
#> GNP             0.072     0.032   2.269 0.04665052
#> Unemployed     -0.004     0.004  -0.921 0.37875618
#> Armed.Forces   -0.006     0.003  -1.975 0.07652157
#> Population     -0.404     0.330  -1.222 0.24981149
#> 
#> $y.fitted
#>                1947   1948   1949   1950   1951   1952   1953   1954
#> Fitted.value 60.045 61.263 60.081 61.577 63.679 64.192 64.788 63.542
#>                1955   1956   1957   1958   1959   1960   1961   1962
#> Fitted.value 65.928 66.923 67.734 66.524 69.011 69.532 69.193 71.059
#> 
#> $y.res
#>            1947   1948 1949  1950   1951   1952  1953  1954  1955  1956
#> Residuals 0.278 -0.141 0.09 -0.39 -0.458 -0.553 0.201 0.219 0.091 0.934
#>            1957   1958   1959  1960  1961   1962
#> Residuals 0.435 -0.011 -0.356 0.032 0.138 -0.508
#> 
#> $vcov.matrix
#>                  Intercept  GNP.deflator           GNP    Unemployed
#> Intercept     1.236876e+03 -3.5540623633  1.100410e+00  1.326737e-01
#> GNP.deflator -3.554062e+00  0.0174894664 -3.573526e-03 -4.183822e-04
#> GNP           1.100410e+00 -0.0035735258  1.007038e-03  1.171132e-04
#> Unemployed    1.326737e-01 -0.0004183822  1.171132e-04  1.923133e-05
#> Armed.Forces  2.518234e-03 -0.0001126875  5.082830e-06  4.360727e-06
#> Population   -1.145533e+01  0.0283088511 -9.931526e-03 -1.216230e-03
#>               Armed.Forces    Population
#> Intercept     2.518234e-03 -1.145533e+01
#> GNP.deflator -1.126875e-04  2.830885e-02
#> GNP           5.082830e-06 -9.931526e-03
#> Unemployed    4.360727e-06 -1.216230e-03
#> Armed.Forces  8.054968e-06  2.961211e-05
#> Population    2.961211e-05  1.090744e-01
#> 
#> $ANOVA.table
#>              Df  Sum.Sq Mean.Sq F.value      p.value
#> GNP.deflator  1 174.397 174.397 746.806 9.967417e-11
#> GNP           1   4.787   4.787  20.499 1.095464e-03
#> Unemployed    1   2.264   2.264   9.695 1.099160e-02
#> Armed.Forces  1   0.876   0.876   3.751 8.151854e-02
#> Population    1   0.349   0.349   1.494 2.496244e-01
#> Residuals    10   2.335   0.234      NA           NA

coefs(fit.mlr)
#>    Intercept GNP.deflator          GNP   Unemployed Armed.Forces 
#>       92.461       -0.048        0.072       -0.004       -0.006 
#>   Population 
#>       -0.404

select.cov(fit.mlr, 0.05)
#> [1] "Intercept" "GNP"
```
