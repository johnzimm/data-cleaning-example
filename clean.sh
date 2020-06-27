#!/usr/bin/env bash

# RESET RESULT FILES
rm -f RESULT*

cp "INPUTFILE.csv" "RESULTFILE.csv"

# SUPPRESSIONFILE should not contain a header row

while IFS="" read -r SUPPRESSIONROW || [ -n "${SUPPRESSIONROW}" ]
do
    echo "Checking for ${SUPPRESSIONROW}..."
    sed -i.temp "/.*${SUPPRESSIONROW}.*/Id" RESULTFILE.csv
    diff RESULTFILE.csv RESULTFILE.csv.temp >> RESULTFILE.csv.diffs
    DIFF_RC=$?
    case $DIFF_RC in
        [0]*)
            echo "${DIFF_RC}   NOTFOUND: ${SUPPRESSIONROW}" | tee --append RESULT_NOTFOUND.csv
            ;;
        [1]*)
            echo "${DIFF_RC}    REMOVED: ${SUPPRESSIONROW}" | tee --append RESULT_REMOVED.csv
            ;;
           *)
            echo "${DIFF_RC} UNEXPECTED: ${SUPPRESSIONROW}" | tee --append RESULT_UNEXPECTED.csv
            ;;
    esac
    rm -f RESULTFILE.csv.temp
done < SUPPRESSIONFILE

# vim: set expandtab smarttab tabstop=4 shiftwidth=4 softtabstop=4 syntax=sh:

