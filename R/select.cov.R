#'select.cov
#'
#'Select covariates passing a given threshold of significance
#'
#'@param res the result object from mlr function
#'@param alpha the given threshold of p-value, default is 0.05
#'
#'@return A vector of names of selected covariates
#'
#'@examples
#'data(longley)
#'obj = mlr("Employed", c("GNP.deflator","GNP","Unemployed","Armed.Forces","Population"), longley, 5)
#'select.cov(obj)
#'
#'@export
#'
select.cov = function(res, alpha=0.05) {
  covs = rownames(res$summary[res$summary[,"p.value"] <= alpha,])
  return(covs)
}
