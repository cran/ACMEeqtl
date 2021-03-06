\name{effectSizeEstimation}
\alias{effectSizeEstimationC}
\alias{effectSizeEstimationR}
\title{
    Estimate Non-Linear Model for the Effect of Genotype on Gene Expression
}
\description{
    Estimate non-linear model for the effect of genotype on 
    the phenotype of interest, i.e. gene expression.
}
\usage{
effectSizeEstimationC(x, y, cvrt)
effectSizeEstimationR(x, y, cvrt)
}
\arguments{
    \item{x}{
        Genotype vector. 
        Typically having 0/1/2 values.
    }
    \item{y}{
        Phenotype vector.
        Typically gene expression in normalized raw counts.
    }
    \item{cvrt}{
        Matrix of covariates.
    }
}

\value{
    Returns a vector with estimated parameters and diagnostics information, 
    such as number of iterations till convergence.
    
    The items of the vector include:
    \item{beta0}{
        The constant parameter in the non-linear model.
    }
    \item{beta1}{
        The effect size parameter in the non-linear model.
    }
    \item{nits}{
        Number of iterations till convergence of the estimation algorithm.
    }
    \item{SSE}{
        Sum of squared residuals of the fitted model.
    }
    \item{SST}{
        Sum of squared residuals of the model with zero effect.
    }
    \item{F}{
        The F test for the significance of the genotype effect.
    }
    \item{eta}{
        The effect size parameter for simplified model (beta1/beta0).
    }
    \item{SE_eta}{
        Standard error of the eta estimate.
    }
}
\author{
    Andrey A Shabalin \email{andrey.shabalin@gmail.com}, John Palowitch
}
\references{
    The manuscript is available at:
    \url{http://onlinelibrary.wiley.com/doi/10.1111/biom.12810/full}
}
\details{
    The function has two implementations, one fully coded in R and
    a faster version with core coded in C.
}
\seealso{
    For package overview and code examples see the package vignette via:\cr
    \code{browseVignettes("ACMEeqtl")}\cr
    or\cr
    \code{RShowDoc("doc/ACMEeqtl.html", "html", "ACMEeqtl")}
    
    For fast testing of all local gene-SNP pairs (local eQTL) see 
    \code{\link{multithreadACME}}.
}
\examples{
# Model parameters
beta0 = 10000
beta = 50000

# Data dimensions
n = 1000
p = 19

# Standard deviation of covariate effects and noise
cvrtsd = 10
noisesd = 1

### Data generation
### Zero average covariates
cvrt = matrix(rnorm(n * p, sd = cvrtsd), n, p)
cvrt = t(t(cvrt) - colMeans(cvrt))

c_eff = rnorm(p, sd = cvrtsd)
error = rnorm(n, sd = noisesd)

# Generate SNPs
x = rbinom(n, size = 2, prob = 0.2)
y = log(beta0 + beta * x) + cvrt \%*\% c_eff + error

### Model estimation

z1 = effectSizeEstimationR(x, y, cvrt)
z2 = effectSizeEstimationC(x, y, cvrt)

### Compare the estimates

show(cbind(z1, z2))
}