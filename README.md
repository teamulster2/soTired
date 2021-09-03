# soTired

## Motivation

soTired is an application for cognitive fatigue assessment.
It includes a stand-alone Android app for fatigue detection and an additional part for data management and further analysis.
The project is structured as client side (stand-alone app) implemented in Dart/Flutter and a server side (data management) written in Golang.
Besides Android, Dart/Flutter provides the ability to add an iOS, desktop and / or web application from a single codebase.


soTired is a rewrite of the application presented in the [Validation of a Smartphone-Based Approach to In Situ Cognitive Fatigue Assessment](https://mhealth.jmir.org/2017/8/e125) paper by Edward Price, George Moore, Leo Galway and Mark Linden.

## Contributions

For communication through the code, please use one of the following tags:
```
FIXME - for a bug which can't be fixed now
TODO - for a feature or are a design change that has to be done later on
NOTE - for an important information
```

The git workflow for this repo is **rebase-merge**, which results in a history of this form:

```
                             F--G
                            /    \
   feature-1 ->     B--C   E------H    <- feature-2
                   /    \ /        \
                --A------D----------I  <-main

```
In conclusion, the main branch only contains merge commits from other branches,
which are rebased onto the most recent commit.
