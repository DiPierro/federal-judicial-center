# Search path
VPATH = dashboard scripts

# Dashboard
DASHBOARD = dashboard.html

# All targets
all : $(DASHBOARD)

# Data dependencies
dashboard.rds : dashboard.yaml
dashboard.html : dashboard.rds cb_county_population_2000_2018.rds

# Pattern rules
%.rds : %.R
	Rscript $<
%.html : %.Rmd
	Rscript -e 'rmarkdown::render(input = "$<")'
	open -a "Google Chrome" dashboard/dashboard.html
