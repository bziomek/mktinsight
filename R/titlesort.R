#' Predicts the seniority of contacts based on their job titles
#'
#' \code{titlesort} returns a vector of 1s and 0s corresponding to the predicted
#' seniority of input job titles. A prediction of 1 corresponds to a director-level-or-higher
#' position, and a contact with a 0 is predicted to be an individual contributor
#' or junior manager. Based on a bag of words method, it has 95%+ precision and recall
#' for most English-language job titles, with a slight bias towards the technology industry.
#' Also works OK for German and French titles, and should not be used for other languages.
#' \code{titlesort} is embedded inside \code{\link{mail.subject}} and does not need to be used
#' separately with that function.
#'
#'@param input.title Vector of strings of job titles
#'
#'@return Returns a vector of 1s and 0s corresponding to predicted job titles.
#'
#'@examples
#'titlesort(mail$title)
#'
#'@export

titlesort <- function(input.title) {

  input.corpus <- corpus(as.character(input.title))

  input.dfm <- dfm(input.corpus, remove = stopwords("english"), stem = TRUE, remove_punct = TRUE)
  input.dfm.union <- dfm_select(input.dfm,titledfm)
  title.pred.nb <- predict(titlenb, input.dfm.union)

  return(round(as.numeric(title.pred.nb$nb.predicted)))

}
