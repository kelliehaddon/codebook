# Codebook

This [codebook](codebook.pdf) is part of an [assignment](codebook-assignment.pdf) in my data analysis class. The assignment was to find and wrangle a dataset, prepare it for "public" use, and create a codebook for the dataset to serve as a reference guide for anyone who wants to use this data.

The final dataset is stored as both a [.csv file](maternal_health_2014.csv) and an [.rdata file](maternal_health_2014.rdata).

This dataset pulls from data published by the [World Bank](WB_MMR_2014.csv) and [UNICEF](Maternal-and-Newborn-Coverage-Database-December-2022.xlsx). The data in the UNICEF Excel spreadsheet was separated out into individual files so it could be imported into R. These files include [anc1.xlsx](anc1.xlsx), [anc4.xlsx](anc4.xlsx), [csec.xlsx](csec.xlsx), [instdel.xlsx](instdel.xlsx), [pncmom.xlsx](pncmom.xlsx), [pncnb.xlsx](pncnb.xlsx), and [sab.xlsx](sab.xlsx).

Also included in this repository is the [script](codebook.Rproj) used to wrangle the data and the [R Markdown](codebook.Rmd) file used to create the codebook.
