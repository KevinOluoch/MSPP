% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mergeSummarySheets.R
\name{mergeSummarySheets}
\alias{mergeSummarySheets}
\title{Merge the summary sheets}
\usage{
mergeSummarySheets(xlsxfiles.dir)
}
\arguments{
\item{xlsxfiles.dir}{a path to the directory of xlsx files}
}
\value{
A dataframe of data in the xlsx files. The files are bind rowwise 
   and an extra column with file names added.
}
\description{
This function merges the summary sheets of workbooks generated from the MSPP
Tool. It adds a column with the filename for ease in identifying the source file.
}
