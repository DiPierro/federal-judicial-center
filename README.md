# Project 

Welcome to the GitHub repository for the Federal Judicial Center Dashboard!

The Federal Judicial Center is the agency within the judicial branch of the U.S. government tasked with examining federal court practices and policies. Among the information it shares with the public is the Integrated Data Base, a repository of data on all federal courts.

To build a custom dashboard using Federal Judicial Center civil court data, take these steps:

1) Download this repository.
2) Download civil court data from the Federal Judicial Center [here](https://www.fjc.gov/research/idb/civil-cases-filed-terminated-and-pending-sy-1988-present).
3) Then, go to the /scripts directory and edit `dashboard.yaml` with the file path to your data and the parameters you'd like to search.
4) Finally, navigate to the local copy of this repository on your computer from the command line and type `make`. Hit enter.
5) Wait a few minutes and your custom dashboard will open in Google Chrome.

Disclaimers:

* This dashboard is not a product of the Federal Judicial Center.
* This dashboard is a work in progress. Check back for updates and improvements.
* The data presented here have been de-duplicated and cleaned at a basic level, but may still include duplicate cases and other errors. Plaintiff and defendant names have not been standardized.

For questions, comments and bugs, contact dipierro@stanford.edu.
