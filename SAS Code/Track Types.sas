options validvarname=v7;
libname track xlsx "/folders/myfolders/NASCAR Research/Import Data/Track Type.xlsx";

/* Create empty data set */
data tracks;
run;

/* Append each year's data together */
%macro setter(year);

data tracks;
  length Winner $75.;
  set tracks track.track&year.;
run;

%mend setter;

%setter(10);
%setter(11);
%setter(12);
%setter(13);
%setter(14);
%setter(15);
%setter(16);
%setter(17);
%setter(18);
%setter(19);

/* Joining winners and track type - keeping only drivers with 5+ wins */
proc sql;
  create table rsrch.all_tracks as
    select a.Race_Track, a.Winner, b.Type
    from tracks as a inner join track.track19 as b
    on a.Race_Track = b.Race_Track
    order by a.Winner
;
quit;

proc sql;
  create table tracks_chisq as 
    select *
    from rsrch.all_tracks
    group by Winner
    having count(Winner) > 5 /* to meet chi-square req and to set pattern */
;
quit;
  
/*   Changing up the template for PROC FREQ */
proc template;
  define crosstabs Base.Freq.CrossTabFreqs;
    cellvalue frequency rowpercent;
    
    define frequency;
      format = 8.;
      header = "# Wins";
    end;
    
	define rowpercent;
/*       format=pctfmt.2; */
      header='Row %';
	end;

	define header tableof;
	  text "Table of Driver Wins by Track Type";
	end;

	define header rowsheader;
	  text _row_label_ / _row_label_ ^= ' ';
	  text _row_name_;
	end;
	
	define header colsheader;
	  text _col_label_ / _col_label_ ^= ' ';
	  text _col_name_;
	end;
	
	cols_header=colsheader;
	rows_header=rowsheader;
	header tableof;
  end;
run; 
  
options orientation=landscape nodate nonumber center leftmargin=0cm rightmargin=0cm;
ods noproctitle;
ods graphics on;
ods pdf file="/folders/myfolders/NASCAR Research/Output Info/Track Type ChiSq.pdf";
  
/* Frequenct table and Chi-Square Test on driver/track type */
/* 		Not SRS, but all drivers = pop.; Cat vars; Freq count > 5 */
title "Chi Square Analysis Across Driver Wins and Track Type";
proc freq data=tracks_chisq order=freq;
  table Type*Winner / nocol nocum nopercent  
    plots=freqplot(groupby=row twoway=cluster scale=freq) chisq;
    label type = "Track Type";
run;
/* With such a low p-value, we can conclude significance between driver and track type */

ods _all_ close;
