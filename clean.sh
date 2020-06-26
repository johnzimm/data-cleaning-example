#!/usr/bin/env bash

cp "INPUTFILE.csv" "RESULTFILE.csv"

# SUPPRESSIONFILE should not contain a header row

while IFS="" read -r SUPPRESSIONROW || [ -n "${SUPPRESSIONROW}" ]
do
    echo "Checking for ${SUPPRESSIONROW}..."
    sed -i "/.*${SUPPRESSIONROW}.*/Id" RESULTFILE.csv
done < SUPPRESSIONFILE

# vim: set expandtab smarttab tabstop=4 shiftwidth=4 softtabstop=4 syntax=sh:

