/* Totalling up wins to be used for ANOVA on NASCAR Merge.sas */
proc sql;
  create table winner_count as
	select winner, count(winner) as Wins
	from rsrch.all_tracks
	group by winner
	order by wins desc
;
quit;

/* Joins team with driver and number of wins */
proc sql;
  create table wins_driver_team as 
	select winner, w.wins, team
	from winner_count as w left join rsrch.all_year as n
	on w.winner = n.driver
;
quit;

/* Gets rid of duplicates and drivers w/o teams (bad data) */
proc sort data = wins_driver_team nodupkey out=all_teams;
  by winner team;
  where team not is missing;
run;

/* top 5 teams */
proc sort data = all_teams out=major_teams;
  by winner team;
  where team in ("Chip Ganassi Racing with Felix Sabates" "Hendrick Motorsports"
  	"Joe Gibbs Racing" "Penske Racing" "Stewart-Haas Racing");
run;

/* Two ANOVA Procedures: All teams and Top 5 teams */

ods pdf file="/folders/myfolders/NASCAR Research/Output Info/ANOVA by Team.pdf";
options orientation=landscape nodate nonumber;
ods noproctitle;

title "ANOVA Analysis by Team since 2010";
title2 "All Teams Included";
/* ods trace on; */
ods exclude classlevels nobs overallanova fitstatistics;
proc anova data= all_teams;
  class team;
  model wins = team;
  label team = "Team";
  
quit;
/* ods exclude none; */

title2 "Top 5 Teams";
ods exclude classlevels nobs overallanova fitstatistics;
proc anova data= major_teams;
  class team;
  model wins = team;
  label team = "Team";
run;
/* ods trace off; */

title;
ods pdf close;%  