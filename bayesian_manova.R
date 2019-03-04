setwd("/Users/clinpsywoo/Nas/replication/data/")

library(brms)

# Read rejection data, in which x, y, z peak coordinates and the group information 
# (original [coded as a] vs. replication studies [coded as b]) are stored
dat = read.table("manova_data_rejection.txt", header = TRUE, dec = ',')

# Set the priors:
# We used weakly-informative priors recommended by Gelman and Hill, 2007 (Ch 13, 17)
#      from STAN manual [v2.17.0] 9.13 and 9.15
prior1 <- c(set_prior("normal(0,5)", class = "Intercept"),
            set_prior("lkj(4)", class = "rescor"),
            set_prior("normal(0,5)", class = "b"),
            set_prior("normal(0,5)", class = "b", resp = "x"),
            set_prior("normal(0,5)", class = "b", resp = "y"),
            set_prior("normal(0,5)", class = "b", resp = "z"),
            set_prior("normal(0,5)", class = "b", coef = "groupb", resp = "x"),
            set_prior("normal(0,5)", class = "b", coef = "groupb", resp = "y"),
            set_prior("normal(0,5)", class = "b", coef = "groupb", resp = "z"),
            set_prior("normal(0,5)", class = "Intercept", resp = "x"),
            set_prior("normal(0,5)", class = "Intercept", resp = "y"),
            set_prior("normal(0,5)", class = "Intercept", resp = "z"),
            set_prior("cauchy(0,2.5)", class = "sigma", resp = "x"),
            set_prior("cauchy(0,2.5)", class = "sigma", resp = "y"),
            set_prior("cauchy(0,2.5)", class = "sigma", resp = "z"))

# Fit the model (H1)
fit1 <- brm(
  cbind(x., y., z.) ~ group,
  data = dat, chains = 2, cores = 6,
  prior = prior1,
  save_all_pars = TRUE,
  iter=10000
)

summary(fit1)

prior2 <- c(set_prior("normal(0,5)", class = "Intercept"),
            set_prior("lkj(4)", class = "rescor"),
            set_prior("normal(0,5)", class = "Intercept", resp = 'x'),
            set_prior("normal(0,5)", class = "Intercept", resp = 'y'),
            set_prior("normal(0,5)", class = "Intercept", resp = 'z'),
            set_prior("cauchy(0,2.5)", class = "sigma", resp = 'x'),
            set_prior("cauchy(0,2.5)", class = "sigma", resp = 'y'),
            set_prior("cauchy(0,2.5)", class = "sigma", resp = 'z'))

# Fit the null model (H0)
fit2 <- brm(
  cbind(x., y., z.) ~ 1,
  data = dat, chains = 2, cores = 6,
  save_all_pars = TRUE,
  prior = prior2,
  iter=10000
)

summary(fit2)

BF_rejection = bayes_factor(fit2, fit1, log = FALSE)
BF_rejection$bf
# [1] 0.07540801

# Read pain data
dat = read.table("manova_data_pain.txt", header = TRUE, dec = ',')

# Fit the model (H1)
fit1 <- brm(
  cbind(x., y., z.) ~ group,
  data = dat, chains = 2, cores = 6,
  prior = prior1,
  save_all_pars = TRUE,
  iter=10000
)

summary(fit1)

# Fit the null model (H0)
fit2 <- brm(
  cbind(x., y., z.) ~ 1,
  data = dat, chains = 2, cores = 6,
  save_all_pars = TRUE,
  prior = prior2,
  iter=10000
)

summary(fit2)

BF_pain = bayes_factor(fit2, fit1, log = FALSE)
BF_pain$bf
# [1] 2.557132