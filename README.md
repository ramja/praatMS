# praatMS
Tools for prosodic analysis of audio conversations using PraatR


## Explanation
The aim of this project is to "visualize" cooperation on audio recording of conversations. It is observed that in conversations in which 2 persons are cooperating for a mutual goal the distribution of somo property of the audio signal (F0) follows a certain distribution. If the conversation is altered by one or the two participants this distribution is also altered:

![GitHub Logo](/images/cooperation.png)
Format: ![Alt Text](url)

## Visualization tool

The visualization tool allows to load one (or two for comparision) audio files (mp3 format), visualize the distribution of the F0 component of the signal, analize the participants segments of the conversation and to visualize (and compare) audios as a generated graph.
It has the following visualizations panels:

### Signal View
![GitHub Logo](/images/sig0.png)
Format: ![Alt Text](url)


### Segments of the Conversation
![GitHub Logo](/images/sig1.png)
Format: ![Alt Text](url)


### Distribution of the Conversation components
![GitHub Logo](/images/sig2.png)
Format: ![Alt Text](url)


### Visualization as a Graph
![GitHub Logo](/images/sig3.png)
Format: ![Alt Text](url)



## Installation

To execute visualization tool execute from RStudio:


...................................
`shiny::runGitHub('ramja/praatMS', 'rstudio')`

previously install manually rPraat lingustic package on the system. For ubuntu:

`sudo apt-get install -y praat`

Tested with rstudio 1.2.50; R version 3.4.2

### Linux

To run on linux you have to have some .wav audios in the /tmp directory

The standard sampling for this application to work is 16 bit, 16 KHz and mono aural recording. This can be done with "Audacity" or some similar tool.

### Docker

PraatR library is no longer mainained for current R versions. For compatibility is maybe a better idea to use a docker image with the correct package versions

For a quick review of this code execute the following docker command:

`docker run --network host -e PASSWORD=yourpass --name praatviz -v /path/to/audios:/tmp  ramja/praatrviz  Rscript -e "shiny::runGitHub('ramja/praatMS', 'rstudio')"`


