#!/bin/bash

# Where is this script? Move to that directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

# Where to find cURL, HTML tidy and git
CURL=/usr/bin/curl
TIDY=/usr/bin/tidy
GIT=/usr/bin/git

# Base to download datasets
URLBASE="http://hatrafficinfo.dft.gov.uk/feeds/datex/England"

# Datasets to download
DATASETS="PredefinedLocationJourneyTimeSections JourneyTimeData UnplannedEvent CurrentPlanned CurrentRoadworks"

function die() {
	echo $1 >&2
	exit 1
}

# Dowload datasets
for ds in $DATASETS; do
	echo "Downloading dataset $ds"
	mkdir --p "$ds"
	$CURL -s "${URLBASE}/${ds}/content.xml" > "${ds}/content.xml" || die "Failed to download $ds content"
	$TIDY -m -i -w 102 -xml --quiet y "${ds}/content.xml"
done

echo "Checking in any changes"
$GIT add .
$GIT commit -m "Automatic commit for `/bin/date`"

