# mktinsight

This package is a R tool for the contextual analysis of sentences in email subject lines. It automates contact segmentation based on job titles and the evaluation of which email topics are most successful at attracting readers.

## Installing the package

1. Installing Python dependencies:

     Install python. Then install spacy for your platform, as documented on [its website](https://spacy.io/usage/).

2. Install `mktinsight`:

     Run the command:
```
install.packages("devtools")
devtools::install_github("bziomek/mktinsight")
```

3. If the above command throws dependency errors, install dependencies manually:
```
install.packages("quanteda")
install.packages("spacyr")
```
4. Then re-run the installation command, if needed:
```
remove.packages("mktinsights")
devtools::install_github("bziomek/mktinsight")
```

## Usage

To access functionality, start with `package?mktinsight`.