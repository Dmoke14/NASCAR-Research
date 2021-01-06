/* Read in data as libraries */
%let path = /folders/myfolders/NASCAR Research/Import Data/;
libname stand xlsx "&path.NASCAR Standings.xlsx";
libname drivers xlsx "&path.NASCAR Drivers.xlsx";
libname stage xlsx "&path.Stage Points.xlsx";

/* Create library for tables to be used in other programs */
libname rsrch "/folders/myfolders/NASCAR Research";

/* Merge macro merges standings data with car make and team of drivers */
/* Use only for year 2015-2016 */
%macro merge(year);

proc sql;
  create table NASCAR&year. as
    select "&year." as Year, RK, Driver, POINTS, WINS, POLES, TOP_5, TOP_10, Make, Team
    from stand.s&year. as s left join drivers.d&year. as d
	on s.Driver = d.Name;
quit;

proc sort data=NASCAR&year.;
  by RK;
run;

%mend merge;

%merge(2015);
%merge(2016);

/* Stage macro merges standings data with car make and team of drivers and stage points */
/* Use only for year 2017-2019 */
%macro stage(year);

proc sql;
  create table Part1&year. as
    select "&year." as Year, RK, Driver, POINTS, WINS, POLES, TOP_5, TOP_10, Make, Team
    from stand.s&year. as s left join drivers.d&year. as d
	on s.Driver = d.Name;
quit;

proc sql;
  create table NASCAR&year. as
    select p.*, stage_points, stage_wins
    from Part1&year. as p left join stage.stage_&year. as s
    on p.Driver = s.Driver;
quit;

proc sort data=NASCAR&year.;
  by RK;
run;

%mend stage;

%stage(2017);
%stage(2018);
%stage(2019);

libname stand clear;
libname drivers clear;
libname stage clear;

/* Exploring Data */
proc print data=NASCAR2019 noobs;
run;

/* Output macro outputs the final tables as a .csv file  */
%macro output(year);

ods csvall file="&path.Output Data/NASCAR&year..csv";

proc print data=NASCAR&year. noobs;
run;

ods csvall close;

%mend output;

/* %output(2015); */
/* %output(2016); */
/* %output(2017); */
/* %output(2018); */
/* %output(2019); */

/* Combine all years */
data rsrch.all_year;
  set nascar2015 nascar2016 nascar2017 nascar2018 nascar2019;
run;
