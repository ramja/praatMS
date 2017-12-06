# praatMS
Tools for prosodic analysis of audio conversations using PraatR

## Visualization tool
To execute visualization tool execute from RStudio:

shiny::runGitHub('ramja/praatMS', 'rstudio')

### Linux
To run on linux you have to have some .wav audios in the /tmp directory
The standard sampling for this application to work is 16 bit, 16 KHz and mono aural recording. This can be done with "Audacity" or some similar tool.
Also the /tmp directory (or wherever you will put  your audios, you can configure it 
on the server.R PitchDirectory variable) has to have read and write user permisions.

There are some prerequisites to be installed on a linux system:

zlib1g-dev
cairo
libssl-dev
libxml2-dev
gfortran
libudunits2-dev
praat