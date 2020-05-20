# praatMS
Tools for prosodic analysis of audio conversations using PraatR


## Explanation
The aim of this project is to "visualize" cooperation on audio recording of conversations. It is observed that in conversations in which 2 persons are cooperating for a mutual goal the distribution of somo property of the audio signal (F0) follows a normal distribution. If the conversation is altered by one or the two participants this distribution is also altered:

![GitHub Logo](/images/cooperation.png)
Format: ![Alt Text](url)

## Visualization tool
To execute visualization tool execute from RStudio:

shiny::runGitHub('ramja/praatMS', 'rstudio')

### Linux
To run on linux you have to have some .wav audios in the /tmp directory
The standard sampling for this application to work is 16 bit, 16 KHz and mono aural recording. This can be done with "Audacity" or some similar tool.
