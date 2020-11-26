#'coefs
#'
#'Print out the estimated values of coefficients for the fitted model
#'
#'@param res the result object from mlr function
#'
#'@return The estimated values of coefficients
#'
#'@examples
#'data(longley)
#'obj = mlr("Employed", c("GNP.deflator","GNP","Unemployed","Armed.Forces","Population"), longley, 5)
#'coefs(obj)
#'
#'@export
#'
coefs = function(res) {
  return(res$summary[,"Estimate"])
}
