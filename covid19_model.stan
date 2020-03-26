data { 
  int N; 
  real cases[N];
  real deaths[N];
  int day[N];
  real<lower=0> tau_t;
  real<lower=0> tau_delta;
} 
parameters {
  real<lower=0,upper=1> gamma;
  real<lower=0,upper=0.02> delta;
  real<lower=0> alpha;
  real<lower=0> I0;
} 
model {
    for(i in 1:N) {
      real nc = I0 * exp(alpha * (day[i] - tau_t));
      cases[i] ~ normal(nc * gamma, nc * gamma * (1 - gamma));
      real nd = I0 * exp(alpha * (day[i] - tau_delta));
      deaths[i] ~ normal(nd * delta, nd * delta * (1 - delta));
    }
}
