# Helper function to extract proper root tokens

.substr.right <- function(input.string) {

  input.string.temp <- as.character(input.string)
  output.string <- NULL
  output.string <- substr(input.string, 18, nchar(input.string.temp))
  return(output.string)

}

# Helper function for cleaning emails and formatting for analysis

.mail.cleaninput <- function(input.subjects) {

  # parse email subject text using spacy

  mail_parse <- spacy_parse(as.character(mail_temp$subject),dependency = TRUE, lemma = FALSE, pos = FALSE)

  # Remove spaces and punctuation

  mail_parse <- as.data.frame(mail_parse)

  # Remove punctuation, errors, spacing, modifiers

  mail_parse <- mail_parse[mail_parse$dep_rel != "",]
  mail_parse <- mail_parse[mail_parse$dep_rel != "punct",]
  mail_parse <- mail_parse[mail_parse$dep_rel != "case",]
  mail_parse <- mail_parse[mail_parse$dep_rel != "poss",]
  mail_parse <- mail_parse[mail_parse$dep_rel != "nummod",]

  # Return parsed subjects

  return(mail_parse)

}

# Find the most common root word, the mode, in each subject line

.mail.findmode <- function(input.mail_parse, input.mail_temp) {

  mail_parse <- NULL
  mail_temp <- NULL
  mail_parse <- as.data.frame(input.mail_parse)
  mail_temp <- as.data.frame(input.mail_temp)

  # extract mode root words from email subjects

  for (i in 1:nrow(mail_temp)) {

    # Find the most common root word id in each email

    curr.text <- NULL
    curr.text <- mail_parse[mail_parse$doc_id == mail_temp$textid[i],]
    curr.textid <- NULL
    curr.textid <- curr.text[,5]
    uniqv <- NULL
    uniqv <- unique(curr.textid)
    curr.rootid <- NULL
    curr.rootid <- as.numeric(uniqv[which.max(tabulate(match(curr.textid, uniqv)))])

    mail_temp$mode_root_id[i] <- curr.rootid

    # Pull the root word associated with each root word id

    try(mail_temp$mode_root[i] <- as.character(curr.text[as.numeric(curr.text$token_id) == as.numeric(curr.rootid), 4]), silent=TRUE)

  }

  # return entire processed df

  return(mail_temp)

}

# Find words associated with the root word in each subject
# Group for brevity

.mail.assocwords <- function(input.mail_parse, input.mail_temp) {

  mail_parse <- as.data.frame(input.mail_parse)
  mail_temp <- as.data.frame(input.mail_temp)

  associated_words_full <- structure(list(Associated = character(),
                                        Root = character()),
                                   class = "data.frame")

  for (i in 1:length(mail_temp$textid)) {

    # Collect words associated with root id

    curr.text <- NULL
    curr.text <- mail_parse[mail_parse$doc_id == mail_temp$textid[i],]

    # Grab Associated words

    associated_words_temp <- as.character(curr.text[curr.text$head_token_id == mail_temp$mode_root_id[i] & curr.text$head_token_id != curr.text$token_id, 4])
    associated_words_temp <- as.data.frame(associated_words_temp)
    associated_words_temp$Root <- cbind(rep(mail_temp$mode_root[i],nrow(associated_words_temp)))

    # Build the entire associated words df

    names(associated_words_temp) <- c("Associated", "Root")
    associated_words_full <- rbind(associated_words_full, associated_words_temp)

  }

  # Create return df

  associated_words <- NULL
  associated_words <- data.frame(matrix(ncol=2, nrow=length(unique(associated_words_full$Root))))
  names(associated_words) <- c("Associated", "Root")

  # Initialize return df with unique root words

  associated_words$Root <- unique(associated_words_full$Root)

  # Loop to extract top associated words for each root

  for (j in 1:length(associated_words$Root)) {

    associated_table <- NULL
    associated_temp <- NULL
    associated_temp <- subset(associated_words_full, associated_words_full$Root == associated_words$Root[j])
    associated_table <- table(as.character(associated_temp$Associated))
    try(associated_words$Associated[j] <- dimnames(sort(associated_table)[1:3]), silent=TRUE)

  }

  # Return only associated words

  return(associated_words)

}
