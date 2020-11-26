#'mlr
#'
#'Conduct basic analyses with multiple linear regression
#'
#'@param res the name of the response variable in the model
#'@param covs the names of covariates you'd like to involve in the model
#'@param df the name of your dataset
#'@param decimal number of decimals to keep, the default is 3
#'
#'@return a list of analytical results
#'
#'@examples
#'mlr("Employed", c("GNP.deflator","GNP","Unemployed","Armed.Forces","Population"), longley, 5)
#'
#'@export
#'
mlr = function(res, covs, df, decimal=3) {
  cat("The regression model is:\n")
  part1 = paste(res,"~ intercept +")
  part2 = paste(covs, collapse = " + ")
  cat(paste(part1,part2))
  y = df[,res]
  cov.info = as.matrix(df[,covs])
  X = cov.info
  rownames(X) <- NULL
  colnames(X) <- NULL
  X = cbind(1,X)

  # check colinearity
  check = t(X)%*%X
  if(det(check) == 0) {error = 1} else {
    error = 0
    beta.est = solve(check)%*%t(X)%*%y
    SSE = t(y)%*%y - 2*t(beta.est)%*%t(X)%*%y + t(beta.est)%*%t(X)%*%X%*%beta.est
    sigma.sq.est = SSE/(nrow(X)-ncol(X))
    var.beta.mat = as.numeric(sigma.sq.est) * solve(t(X)%*%X)
    var.beta.est = diag(var.beta.mat)
    sd.beta.est = sqrt(var.beta.est)
    t.stat = beta.est / sd.beta.est
    p.val = 2*pt(-abs(t.stat), df=nrow(X)-ncol(X))

    # keep n decimals
    Estimate = as.numeric(format(round(beta.est, decimal), nsmall = decimal))
    Std.error = as.numeric(format(round(sd.beta.est, decimal), nsmall = decimal))
    t.value = as.numeric(format(round(t.stat, decimal), nsmall = decimal))

    # generate summary table
    res.sum = cbind(Estimate, Std.error, t.value, p.val)
    rownames(res.sum) = c("Intercept",colnames(cov.info))
    colnames(res.sum) = c("Estimate","Std.error","t.value", "p.value")

    # generate fitted values
    y.fitted = X%*%beta.est
    y.fitted = as.matrix(as.numeric(format(round(y.fitted, decimal), nsmall = decimal)))
    rownames(y.fitted) = rownames(cov.info)
    colnames(y.fitted) = "Fitted.value"

    # generate residuals
    y = as.numeric(format(round(y, decimal), nsmall = decimal))
    y.res = y - y.fitted
    colnames(y.res) = "Residuals"

    # variance-covariance matrix
    vcov.mat = var.beta.mat
    rownames(vcov.mat) = c("Intercept",colnames(cov.info))
    colnames(vcov.mat) = c("Intercept",colnames(cov.info))

    # generate ANOVA table
    ssr.list = c()
    for (i in 2:(length(covs)+1)) {
      ssr.list = c(ssr.list, get.ssr(X[,1:i],y))
    }
    ssr.list.new = c()
    ssr.list.new[1] = ssr.list[1]
    for (i in 2:length(covs)) {
      ssr.list.new[i] = ssr.list[i] - ssr.list[i-1]
    }
    ssr.list.new = round(ssr.list.new, decimal)
    F.val = ssr.list.new/as.numeric(sigma.sq.est)
    F.val = round(F.val, decimal)
    p.val2 = pf(F.val, 1, nrow(X)-ncol(X), lower.tail = FALSE)
    anova = cbind(1,ssr.list.new,ssr.list.new,F.val,p.val2)
    rownames(anova) = covs
    colnames(anova) = c("Df", "Sum.Sq", "Mean.Sq", "F.value", "p.value")
    Residuals = NA
    anova = rbind(anova, Residuals)
    anova["Residuals",1] = nrow(X)-ncol(X)
    anova["Residuals",2] = round(SSE, decimal)
    anova["Residuals",3] = round(sigma.sq.est, decimal)
  }

  if(error == 1) {cat("Colinearity existed!")} else {
    return(list(summary = res.sum, y.fitted = t(y.fitted), y.res=t(y.res), vcov.matrix = vcov.mat, ANOVA.table = anova))
  }
}

get.ssr = function(X,y) {
  y.bar = mean(y)
  beta.est = solve(t(X)%*%X)%*%t(X)%*%y
  y.est = X%*%beta.est
  ssr = sum((y.est-y.bar)^2)
  return(ssr)
}

