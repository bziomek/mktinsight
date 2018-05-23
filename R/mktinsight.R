# Document package with roxygen2

#' \code{mktinsight}: A package to contextually analyze email subject lines
#'
#' The \code{mktinsight} package provides two functions that are useful for email marketers:
#' \code{\link{titlesort}} and \code{\link{mail.subject}}. Together they can automate the difficult and very
#' manual tasks of segmenting email recipients and determining what subject lines worked best
#' to get readership, and why.
#'
#' @section \code{mail.subject}:
#' \code{mail.subject} is the core function in \code{mktinsight}. It allows marketers to analyze
#' the success of their email subject lines without having to resort to old-fashioned sets of rules
#' or leverage massive marketing toolkits. \code{mail.subject} contains three key analytical steps:
#' Identifying email topics (1),
#' identifying the topics that align with successful emails (2, as measured by open rates to senior contacts),
#' then finding the words that contextualize those topics most successfully (3).
#'
#' To extract topics, the function generates dependency trees from email subjects and parses them
#' to find the most important topic. The function then calculates the odds ratio that an email with
#' a certain topic is opened and read versus that with a different topic, and finds words associated
#' with that topic to guide future email creation.
#'
#' Subject Insights also has the option of determining the level of a contact using \code{titlesort},
#' then presenting the top predictors of an email being disproportionately opened by senior rather
#' than junior contacts, to help marketers target senior customers. All this is done in a single command
#' aid in accelerating marketing workflows.
#'
#' @section \code{titlesort}:
#' \code{titlesort} is a binary classifier that takes a job title and outputs the probability that
#' the job title is management-level. Job titles can vary widely, and both one- and two-word as well
#' as very long titles are common (“Director” or “Technical Director” compared to “Vice President of
#' Regional Software and Patent Licensing Operations, United Kingdom, Ireland, and Nordics”). Because of this,
#' parsing job titles as sentences didn’t work well. Instead, titles are tokenized, stop words and punctuation
#' are removed, and a bag of words analysis is performed to predict title seniority.
#'
#' @docType package
#' @name mktinsight
#'
#' @import quanteda
#' @import spacyr

NULL
