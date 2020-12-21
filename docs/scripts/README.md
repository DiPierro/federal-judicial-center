# Scripts

To make a custom dashboard, start by editing `dashboard.yaml`.

When you run `make`, changes in `dashboard.yaml` will trigger changes to the parameters used in `dashboard.R`. The script `cb_county_population_2000_2018.R` will also run as triggered by `make`, but its parameters remain the same regardless of the input to dashboard.yaml.
