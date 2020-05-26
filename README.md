# praatMS
Tools for prosodic analysis of audio conversations using PraatR


## Explanation
The aim of this project is to "visualize" cooperation on audio recording of conversations. It is observed that in conversations in which 2 persons are cooperating for a mutual goal the distribution of somo property of the audio signal (F0) follows a certain distribution. If the conversation is altered by one or the two participants this distribution is also altered:

![GitHub Logo](/images/cooperation.png)
Format: ![Alt Text](url)

## Visualization tool

The visualization tool allows to load one (or two for comparision) audio files (mp3 format), visualize the distribution of the F0 component of the signal, analize the participants segments of the conversation and to visualize (and compare) audios as a generated graph.

![GitHub Logo](/images/prosodic0.png)
Format: ![Alt Text](url)

To execute visualization tool execute from RStudio:


...................................
shiny::runGitHub('ramja/praatMS', 'rstudio')

previously install manually rPraat lingustic package on the system. For ubuntu:

sudo apt-get install -y praat

Tested with rstudio 1.2.50
### Linux
To run on linux you have to have some .wav audios in the /tmp directory
The standard sampling for this application to work is 16 bit, 16 KHz and mono aural recording. This can be done with "Audacity" or some similar tool.
