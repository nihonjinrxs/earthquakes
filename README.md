# earthquakes
[![Travis-CI Build Status](https://travis-ci.org/nihonjinrxs/earthquakes.svg?branch=master)](https://travis-ci.org/nihonjinrxs/earthquakes)

## Coursera *Mastering Software Development in R* Specialization Capstone
This project is the capstone project for the Coursera Specialization *Mastering Software Development in R*, offered by The Johns Hopkins University.

For more information on the specialization, you can view the overview page on Coursera at: [https://www.coursera.org/specializations/r](https://www.coursera.org/specializations/r)

## The Project
In this project, we're building an R package with tools to assist in analyzing historical earthquake data provided by the U.S. National Oceanic and Atmospheric Administration (NOAA).

### The Data
The [NOAA Significant Earthquake Database](https://www.ngdc.noaa.gov/nndc/struts/form?t=101650&s=1&d=1)[1] contains information on destructive earthquakes from 2150 B.C. to the present that meet at least one of the following criteria: Moderate damage (approximately $1 million or more), 10 or more deaths, Magnitude 7.5 or greater, Modified Mercalli Intensity X or greater, or the earthquake generated a tsunami.

The full database [can be downloaded as a tab-delimited text file](https://www.ngdc.noaa.gov/nndc/struts/results?type_0=Exact&query_0=$ID&t=101650&s=13&d=189&dfn=signif.txt), and [variable definitions are available online](https://www.ngdc.noaa.gov/nndc/struts/results?&t=101650&s=225&d=225) also.

[1] National Geophysical Data Center / World Data Service (NGDC/WDS): Significant Earthquake Database. National Geophysical Data Center, NOAA. [doi:10.7289/V5TD9V7K](http://dx.doi.org/10.7289/V5TD9V7K)

### The Package
The tools we're building include facilities for:

* data loading and cleaning
* timeline plots of earthquakes
* maps of earthquakes

### The Goals
The goals of the capstone are to demonstrate understanding of and ability to use R's capabilities to build a reusable, sharable package, including:

* package structure
* revision control
* continuous integration
* data provisioning and preparation
* custom visualization tools
* package namespace and exported functions
* package testing and CRAN checks
* documentation tools (function help and vignettes)
