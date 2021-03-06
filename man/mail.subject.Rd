% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/subjectmain.R
\name{mail.subject}
\alias{mail.subject}
\title{Analyzes email subjects in the context of read metrics and contact seniority}
\usage{
mail.subject(subjects, readflag, jobtitles = NULL, minmails = 2,
  outputrows = NULL)
}
\arguments{
\item{subjects}{Vector of strings of  email subjects}

\item{readflag}{Vector of 1s and 0s representing if an email has been read or not}

\item{jobtitles}{Vector of strings that is the job title of the email recipient (optional)}

\item{minmails}{Integer corresponding to the minimum instances of a subject line that
will be included in the analysis (optional, default 2)}

\item{outputrows}{Integer, the number of rows of email topics that should be output
(optional, defaults to outputting the entire data frame of results).}
}
\value{
If \code{outputrows} is omitted or NULL, returns a data frame of all distinct extracted topics,
along with their odds ratios and associated words. If \code{outputrows} is specified as integer
\emph{n}, returns a dataframe with \emph{n} rows for \emph{both} senior and junior title
classes. If \code{jobtitles} is specified, also includes a column denoting a contact's predicted
seniority, with 1 as senior and 0 as junior.
}
\description{
\code{mail.subject} returns a data frame of extracted email subject topics, their estimated
odds ratios of the email being read, and key words associated with each topic
}
\details{
This function can evaluate the effectiveness of email subjects in attracting readers either
for an entire group of contacts, or based on the recipients' seniority levels. It can
effectively predict contact seniority based on their titles with reasonable accuracy
and uses dependency parsing to extract the topics and tone of email subject lines. The function
then analyzes them in the context of their relative success at attracting readers. It outputs
a data frame of extracted topics, their effectiveness (as measured by odds ratios of the email
being read if it includes that topic), and words associated with that topic, to guide future
email creation. Leverages \code{\link{titlesort}} to predict seniority, and does not need to be used
at the same time as that function.
}
\examples{
mail.subject(mail$subjects, mail$read, jobtitles=mail$titles, minmails=5, outputrows=10)
mail.subject(mail$subjects, mail$read)

}
