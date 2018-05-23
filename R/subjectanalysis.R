# Core processing for the main subject analysis function

.mail.subjinsight <- function(input.subjects, input.read, min_mails = 2, outputrows = NULL) {

  # first load and clean the data

  mail_temp <- NULL
  mail_temp$subject <- as.character(input.subjects)
  mail_temp <- as.data.frame(mail_temp)
  mail_temp$id <- 1:length(mail_temp$subject)
  mail_temp$textid <- paste("text",mail_temp$id, sep="")

  # Construct regression df
  # First parse and clean inputs
  message("Parsing and cleaning email subjects ... ", appendLF = FALSE)

  mail_parse_temp <- NULL
  mail_parse_temp <- .mail.cleaninput(mail_temp$subject)

  message("Done", appendLF = TRUE)

  # Second, find the mode root of each email subject

  message("Deconstructing subject lines ... ", appendLF = FALSE)
  mail_temp <- suppressWarnings(.mail.findmode(mail_parse_temp, mail_temp))
  message("Done", appendLF = TRUE)

  # Third, add the target variable

  mail_temp$read <- round(as.numeric(input.read))

  # Remove Unique roots

  min_n <- min_mails # Specifies minimum number of occurances in the dataset

  n_occur <- data.frame(table(mail_temp$mode_root))
  mail_temp <- mail_temp[mail_temp$mode_root %in% n_occur$Var1[n_occur$Freq > (min_n - 1)],]

  # Logistic regression to explore relationships -- but why mail models?

  message("Analyzing email open probabilities ... ", appendLF = FALSE)
  mailmodel <- glm(read ~ factor(mode_root), data=mail_temp, family="binomial")
  message("Done", appendLF = TRUE)

  # Clean output -- but why mail models?

  mail_results <- NULL
  mail_results <- as.data.frame(coef(summary(mailmodel)))

  # Converting log odds ratio to odds ratio

  mail_results$oddsratio <- exp(mail_results[,1])

  # Remove factor tags from root word display

  mail_results$root <- .substr.right(rownames(mail_results))

  # Make output df

  mail_output <- NULL
  mail_output <- as.data.frame(mail_results$root)
  mail_output$oddsratio <- mail_results$oddsratio

  # Add in associated words

  message("Finding phrases associated with success ... ", appendLF = FALSE)
  mail_assoc_temp <- NULL
  mail_assoc_temp <- .mail.assocwords(mail_parse_temp, mail_temp)
  mail_output$Associated <- mail_assoc_temp$Associated[match(mail_output$`mail_results$root`,mail_assoc_temp$Root)]
  message("Done", appendLF = TRUE)
  message("", appendLF = TRUE)

  # Output full or summary table (add this toggle)

  # Define output parameters
  if(is.numeric(outputrows)) {
    mail_output <- head(mail_output[order(mail_output$oddsratio,decreasing=T),],outputrows)
  }

  names(mail_output) <- c("Root Word", "Odds Ratio","Associated")

  return(mail_output)

}
