# mktinsight

This package is a R tool for the contextual analysis of sentences in email subject lines. It automates contact segmentation based on job titles and the evaluation of which email topics are most successful at attracting readers.

## Installing the package

1. Installing Python dependencies

Install python. Then install spacy for your platform, as documented on [https://spacy.io/usage/](its website).

2. Install `mktinsight`

Run the command:
```
devtools::install_github("bziomek/mktinsight")
```

3. If the above command throws dependency errors, install dependencies manually
```
install.packages("quanteda")
install.packages("spacyr")
```

## Usage

To access functionality, start with `package?mktinsight`.