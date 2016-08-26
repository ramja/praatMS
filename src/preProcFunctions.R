### We use part of scripts of praatR from 
##  Aaron Albin (www.aaronalbin.com)

getIntervals <- function(RichData) {
  ##We analize the silence intervals
  ##Parameter silence threshold: miliseconds without F0 component detectable
  ##In our case we use 200 miliseconds
  Intervals <- fIntervals(RichData[, 2], 200)
  SilIntervals <-
    cbind(RichData$Time[Intervals$min], RichData$Time[Intervals$max] - RichData$Time[Intervals$min])
  
  ##Retrieve silence and voice intervals
  
  inter <- list()
  inter$Intervals <- Intervals
  inter$SilIntervals <- SilIntervals
  
  return(inter)
}


getProsodicData <- function(fileName) {

  #########################################################
  # We extract F0,Strength and Intensity from audio files #
  #########################################################
  
  # Set up the file paths we will need for the input and output
  # Do this by substituting the file extensions with the sub() function
  WavePath = FullPath(fileName)
  PitchPath = sub(WavePath, pattern = ".wav", replacement = ".Pitch")
  PitchTierPath = sub(WavePath, pattern = ".wav", replacement = ".PitchTier")

  # Now, we will use PraatR to execute the "To Pitch..." command, which has the following arguments and default values:
  # Time step (s):        0.0 (= auto)
  # Pitch floor (Hz):    75.0
  # Pitch ceiling (Hz): 600.0
  # It's always important to adjust these settings to suit the soundfiles you're working with.
  # For the example files, the following settings work well:
  PitchArguments = list(0.001, 95, 370)
  
  # Run the command to create a Pitch object
  if (!file.exists(PitchPath)) {
    praat(
      "To Pitch...",
      arguments = PitchArguments,
      input = WavePath,
      output = PitchPath,
      overwrite = TRUE
    )
  }

  # The Pitch file contains a large amount of information
  # To extract only the [time,F0] points, convert to PitchTier format
  # Save it in 'headerless spreadsheet' format (in order to make the data easier to work with in R)
  if (!file.exists(PitchTierPath)) {
    praat(
      "Down to PitchTier",
      input = PitchPath,
      output = PitchTierPath,
      overwrite = TRUE,
      filetype = "headerless spreadsheet"
    )
  }

  # Read in the PitchTier
  if (file.exists(PitchTierPath)) {
    PitchTierData = read.table(PitchTierPath, col.names = c("Time", "F0"))
  }

  # First, read in the Pitch object
  FullText = readLines(PitchPath)

  # Make a convenience function for extracting out all lines with a specific text string
  Extract = function(text, target) {
    as.numeric(gsub(
      grep(
        text,
        pattern = target,
        fixed = TRUE,
        value = TRUE
      ),
      pattern = target,
      replacement = ""
    ))
  }

  # In Pitch objects, time information is not stored for every frame but is instead split into several pieces of information in the header of the file.
  # First, extract out these pieces of information:
  FirstFrame = Extract(FullText, "x1 = ")
  nTimeSteps = Extract(FullText, "nx = ")
  TimeStepSize = Extract(FullText, "dx = ")
  
  # Assemble this information and reconstruct the time domain
  TimeValues = FirstFrame + (1:nTimeSteps) * TimeStepSize
  # The body of a Pitch object contains data that is structured like the following:
  # "    frame [1825]:"
  # "        intensity = 0.02003845615648611 "
  # "        nCandidates = 2 "
  # "        candidate []: "
  # "            candidate [1]:"
  # "                frequency = 0 "
  # "                strength = 0 "
  # "            candidate [2]:"
  # "                frequency = 230.70632488746742 "
  # "                strength = 0.28233906236705225 "
  
  # As can be seen above, each frame has an associated intensity value
  # These intensity values range from 0 (silence) to 1 (maximum volume)
  # Use the Extract() function to pull out this information
  
  IntensityValues = Extract(FullText, "intensity = ")
  
  # Each frame has one or more 'candidates', each of which has an associated 'frequency' and 'strength' attribute.
  # The frequency of the candidate represents the F0 value.
  # The strength of the candidate represents how good/reliable that F0 estimate is.
  # As with intensity, strength also ranges from 0 (bad) to 1 (good).
  # Every frame has one 'voiceless candidate', where frequency=0 and strength=0.
  # If the voiceless candidate is ranked first (i.e. candidate [1], as in the above example), Praat treats that frame as voiceless
  
  # For this example, let's pull out all candidates that are ranked first and determine their frequency and strength values
  # First, make a vector of the line numbers that say 'candidate [1]'
  FirstCandidateLines = which(FullText == "            candidate [1]:")
  
  # Immediately following each of these lines is the line with information on that candidate's frequency (F0)
  FrequencyLines = FullText[FirstCandidateLines + 1]
  
  # Pull out the numbers from these lines, which begin at the 29th character, and convert this to a numeric variable (rather than character)
  F0Values = as.numeric(substring(
    FrequencyLines,
    first = 29,
    last = nchar(FrequencyLines)
  ))
  
  # Since '0' is just a stand-in indicating voiceless frames, change '0's to NAs
  F0Values[F0Values == 0] = NA
  
  # Now do the same for the candidate strength information
  # This is found *two* lines following the lines that say 'candidate [1]', and the numbers begin at the 28th character
  StrengthLines = FullText[FirstCandidateLines + 2]
  StrengthValues = as.numeric(substring(
    StrengthLines,
    first = 28,
    last = nchar(FrequencyLines)
  ))
  StrengthValues[StrengthValues == 0] = NA

  # Assemble all the information created up to this point in a dataframe
  RichData <-
    data.frame(
      Time = TimeValues,
      F0 = F0Values,
      Strength = StrengthValues,
      Intensity = IntensityValues
    )
  RichData
  
}
