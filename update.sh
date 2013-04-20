#!/bin/bash

# Where is this script? Move to that directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

# Where to find cURL and git
CURL=/usr/bin/curl
GIT=/usr/bin/git

# Base to download datasets
URLBASE="http://hatrafficinfo.dft.gov.uk/feeds/datex/England"

# Datasets to download
DATASETS="PredefinedLocationJourneyTimeSections JourneyTimeData"

function die() {
	echo $1 >&2
	exit 1
}

# Dowload datasets
for ds in $DATASETS; do
	echo "Downloading dataset $ds"
	mkdir --p "$ds"
	$CURL -s "${URLBASE}/${ds}/metadata.xml" > "${ds}/metadata.xml" || die "Failed to downliad $ds metadata"
	$CURL -s "${URLBASE}/${ds}/content" > "${ds}/content.xml" || die "Failed to download $ds content"
done

echo "Checking in any changes"
$GIT add .
$GIT commit -m "Automatic commit for `date`"
$GIT push

