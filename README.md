# NASCAR Research
University sponsored research focused on sport analytics.

## Data
This folder consists of the data I gathered and collected from the internet myself. Most files are utilized in SAS, though some never contributed to the project itself. 

Locations I found this data include:
- http://www.espn.com/racing/standings
- http://www.espn.com/racing/drivers/_/year/2019
- https://www.mrn.com/2018-monster-energy-nascar-cup-series-stage-points/
- https://www.racing-reference.info/trackdet?s=3&show=1&series=W&trk=029
- https://fantasyracingcheatsheet.com/nascar/races/schedule

It is worth nothing that "Track Type.xlsm" uses an SQL query to automate data collection.

## SAS Code
The code shared consists of three separate .sas files. All datasets created for this project were stored in libraries so that other programs could access any dataset seamlessly. Because of this, the "coherent" way to read through this project (or if one were to replicate it) starts with "NASCAR Merge", then "Track Type", and finishes with "Team ANOVA". Additionally, I utilized local paths which would be different if reproduced elsewhere.

"NASCAR Merge" uses PROC SQL and macro programs to merge together most of the data so that it is useable for other purposes. 

"Track Types" uses some PROC SQL and macro programs, but also uses PROC FREQ to produce the "Track Type ChiSq" report.

"Team ANOVA" uses PROC SQL, PROC SORT, and PROC ANOVA to generate the "ANOVA by Team" report.

## Reports
These reports provide a peek into the research I was working on. These are not meant to be final reports, just drafts. 
