#!/bin/bash

#sbs_create_phntrans_UR.sh
#usage: scriptname.sh listOfUtteranceIDs g2pDict numeralsDict transcriptDir temporaryStorageDir

LISTOFUTTID=$1
PHONEDICT=$2
NUMERALDICT=$3
DATADIR=$4
TEMPDIR=$5

#Preprocess the transcripts by replacing numerals with spelled out names
python sbs_transcripts_preprocess.py $LISTOFUTTID $NUMERALDICT $DATADIR $TEMPDIR 

#Create the Phonemic transcriptions
python sbs_create_phntrans_UR.py $LISTOFUTTID $PHONEDICT $TEMPDIR
