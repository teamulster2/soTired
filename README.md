# soTired

## Motivation

soTired is an application for cognitive fatigue assessment.
It includes a stand-alone Android app for fatigue detection and an additional part for data management and further analysis.
The project is structured as client side (stand-alone app) implemented in Dart/Flutter and a server side (data management) written in Golang.
Dart/Flutter provides the ability to simply add an iOS, desktop and / or web application besides Android.


soTired is a rewrite of the application presented in the [Validation of a Smartphone-Based Approach to In Situ Cognitive Fatigue Assessment](https://mhealth.jmir.org/2017/8/e125) paper by Edward Price, George Moore, Leo Galway and Mark Linden.

## Contributions

For all files within the repository one of the following tags might only be used:
```
FIXME - for a bug which can't be fixed now
TODO - for a feature or are a design change to be done later
NOTE - for an important information
```

all of these have to be completely upper case.

The git workflow for this repo is rebase-merge so that a history of this form is created:

                             F--G
                            /    \
     feature-1 ->   B--C   E------H    <- feature-2
                   /    \ /        \
                --A------D----------I  <-main

So that the main branch only contains merge commits from other branches,
which are rebased onto the most recent commit.
