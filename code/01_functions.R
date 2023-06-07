# this file contains any custom functions; 
# well commented and documented, with a manifest.

# best keep these together rather than defining
# in situ when used.


#' an abridged life expectancy function, anticipating 21 abridged age groups
#' @param mxc a vector of age-cause specific mortality rates, ages in order within cause
#' @return e0 a scalar value of life expectancy at birth for a given strata
calc_e0 <- function(mxc){
  # we exploit regular data structure
  n  <- 21
  dim(mxc) <- c(n,length(mxc)/n)
  mx       <- rowSums(mxc,na.rm=TRUE)
  
  # simple ax assumptions
  ax      <- c(.1,2,rep(2.5,n-2))
  age_int <- c(1,4,rep(5,n-2))
  
  # convert to probabilities
  qx      <- (age_int * mx) / (1 + (age_int - ax) * mx)
  px      <- 1 - qx
  
  # suvivorship
  lx      <- c(1,cumprod(px))
  dx      <- -diff(lx)
  
  # lifetable exposure
  Lx <- rep(0,n)
  Lx[1:(n - 1)]      <-
    age_int[1:(n - 1)] * lx[2:n] + ax[1:(n - 1)] * dx[1:(n - 1)]
  Lx[n]		        <- lx[n] * ax[n] #open interval
  
  # with a radix of 1, no need to calc Tx
  sum(Lx)
}

