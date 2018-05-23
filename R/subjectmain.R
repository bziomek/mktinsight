#' Analyzes email subjects in the context of read metrics and contact seniority
#'
#' \code{mail.subject} returns a data frame of extracted email subject topics, their estimated
#' odds ratios of the email being read, and key words associated with each topic
#'
#' This function can evaluate the effectiveness of email subjects in attracting readers either
#' for an entire group of contacts, or based on the recipients' seniority levels. It can
#' effectively predict contact seniority based on their titles with reasonable accuracy
#' and uses dependency parsing to extract the topics and tone of email subject lines. The function
#' then analyzes them in the context of their relative success at attracting readers. It outputs
#' a data frame of extracted topics, their effectiveness (as measured by odds ratios of the email
#' being read if it includes that topic), and words associated with that topic, to guide future
#' email creation. Leverages \code{\link{titlesort}} to predict seniority, and does not need to be used
#' at the same time as that function.
#'
#' @param subjects Vector of strings of  email subjects
#' @param readflag Vector of 1s and 0s representing if an email has been read or not
#' @param jobtitles Vector of strings that is the job title of the email recipient (optional)
#' @param minmails Integer corresponding to the minimum instances of a subject line that
#' will be included in the analysis (optional, default 2)
#' @param outputrows Integer, the number of rows of email topics that should be output
#' (optional, defaults to outputting the entire data frame of results).
#'
#' @return If \code{outputrows} is omitted or NULL, returns a data frame of all distinct extracted topics,
#' along with their odds ratios and associated words. If \code{outputrows} is specified as integer
#' \emph{n}, returns a dataframe with \emph{n} rows for \emph{both} senior and junior title
#' classes. If \code{jobtitles} is specified, also includes a column denoting a contact's predicted
#' seniority, with 1 as senior and 0 as junior.
#'
#' @examples
#' mail.subject(mail$subjects, mail$read, jobtitles=mail$titles, minmails=5, outputrows=10)
#' mail.subject(mail$subjects, mail$read)
#'
#' @export

# Core user function that takes inputs and runs the main subject analysis function

mail.subject <- function(subjects, readflag, jobtitles = NULL,
                         minmails = 2, outputrows = NULL) {

  # Validate basic inputs
  if (length(subjects) != length(readflag)) {
    return(message("ERROR: Input subjects and read data of different lengths.", appendLF = TRUE))
  }

  output.mail.df <- NULL

  # Check if job titles are present, if not, run function

  if(missing(jobtitles)) {

  output.mail.df <- .mail.subjinsight(subjects, readflag, minmails, outputrows)

  } else {

      # Validate input job titles
      if (length(subjects) != length(jobtitles)) {
        return(message("ERROR: Input job titles and email data of different lengths.", appendLF = TRUE))
      }

      titles.mail.df <- NULL
      input.mail.df <- NULL

      # Initialize sorting df
      input.mail.df <- data.frame(matrix(ncol=3, nrow=length(subjects)))
      names(input.mail.df) <- c("Subjects", "Read", "Titles")

      # Fill sorting df
      input.mail.df$Subjects <- subjects
      input.mail.df$Read <- readflag

      # Predict job titles using titlesort model
      message("Predicting seniority from supplied job titles ...", appendLF = FALSE)
      input.mail.df$Titles <- titlesort(jobtitles)
      message("Done", appendLF = TRUE)
      message("", appendLF = TRUE)

      output.mail.0 <- NULL
      output.mail.1 <- NULL
      input.mail.0 <- NULL
      input.mail.1 <- NULL

      # Split data by predicted seniority
      input.mail.0 <- input.mail.df[input.mail.df$Titles == 0,]
      input.mail.1 <- input.mail.df[input.mail.df$Titles == 1,]

      # Analyze Junior Data
      message("Analyzing emails to junior contacts:", appendLF = TRUE)
      output.mail.0 <- .mail.subjinsight(input.mail.0$Subjects,
                                         input.mail.0$Read, minmails,
                                         outputrows)

      # Analyze Senior Data
      message("Analyzing emails to senior contacts:", appendLF = TRUE)
      output.mail.1 <- .mail.subjinsight(input.mail.1$Subjects,
                                         input.mail.1$Read, minmails,
                                         outputrows)

      output.mail.0$Senior <- cbind(rep(0,nrow(output.mail.0)))
      output.mail.1$Senior <- cbind(rep(1,nrow(output.mail.1)))

      output.mail.df <- rbind(output.mail.0, output.mail.1)

    }

  return(output.mail.df)

}
