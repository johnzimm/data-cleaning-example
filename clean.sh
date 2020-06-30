#!/usr/bin/env bash

# CHECK FOR RESULTFILE AND ABORT IF IT EXISTS
if [ -f RESULTFILE.csv ]; then
    echo "RESULTFILE.csv EXISTS.  Exiting..."; exit 1
fi

cp "INPUTFILE.csv" "RESULTFILE.csv"

# SUPPRESSIONFILE should not contain a header row

#
# Suppress by email
#
echo ""
echo ""
echo "SUPPRESS BY EMAIL"
echo ""
while IFS="" read -r SUPPRESSIONROW || [ -n "${SUPPRESSIONROW}" ]
do
    echo "Checking for ${SUPPRESSIONROW}..."
    sed -i.temp "/.*${SUPPRESSIONROW}.*/Id" RESULTFILE.csv
    diff RESULTFILE.csv RESULTFILE.csv.temp >> RESULTFILE.csv.diffs
    DIFF_RC=$?
    case $DIFF_RC in
        [0]*)
            echo "${DIFF_RC}   NOTFOUND: ${SUPPRESSIONROW}" | tee --append RESULT_EMAIL_NOTFOUND.csv
            ;;
        [1]*)
            echo "${DIFF_RC}    REMOVED: ${SUPPRESSIONROW}" | tee --append RESULT_EMAIL_REMOVED.csv
            ;;
           *)
            echo "${DIFF_RC} UNEXPECTED: ${SUPPRESSIONROW}" | tee --append RESULT_EMAIL_UNEXPECTED.csv
            ;;
    esac
    rm -f RESULTFILE.csv.temp
done < SUPPRESS_BY_EMAIL

#
# Suppress by name
#
echo ""
echo ""
echo "SUPPRESS BY NAME"
echo ""
while IFS="" read -r SUPPRESSIONROW || [ -n "${SUPPRESSIONROW}" ]
do
    echo "Checking for ${SUPPRESSIONROW}..."
    sed -i.temp "/.*${SUPPRESSIONROW}.*/Id" RESULTFILE.csv
    diff RESULTFILE.csv RESULTFILE.csv.temp >> RESULTFILE.csv.diffs
    DIFF_RC=$?
    case $DIFF_RC in
        [0]*)
            echo "${DIFF_RC}   NOTFOUND: ${SUPPRESSIONROW}" | tee --append RESULT_NAME_NOTFOUND.csv
            ;;
        [1]*)
            echo "${DIFF_RC}    REMOVED: ${SUPPRESSIONROW}" | tee --append RESULT_NAME_REMOVED.csv
            ;;
           *)
            echo "${DIFF_RC} UNEXPECTED: ${SUPPRESSIONROW}" | tee --append RESULT_NAME_UNEXPECTED.csv
            ;;
    esac
    rm -f RESULTFILE.csv.temp
done < SUPPRESS_BY_NAME

#
# Suppress by company
#
echo ""
echo ""
echo "SUPPRESS BY COMPANY"
echo ""
while IFS="" read -r SUPPRESSIONROW || [ -n "${SUPPRESSIONROW}" ]
do
    echo "Checking for ${SUPPRESSIONROW}..."
    sed -i.temp "/.*${SUPPRESSIONROW}.*/Id" RESULTFILE.csv
    diff RESULTFILE.csv RESULTFILE.csv.temp >> RESULTFILE.csv.diffs
    DIFF_RC=$?
    case $DIFF_RC in
        [0]*)
            echo "${DIFF_RC}   NOTFOUND: ${SUPPRESSIONROW}" | tee --append RESULT_COMPANY_NOTFOUND.csv
            ;;
        [1]*)
            echo "${DIFF_RC}    REMOVED: ${SUPPRESSIONROW}" | tee --append RESULT_COMPANY_REMOVED.csv
            ;;
           *)
            echo "${DIFF_RC} UNEXPECTED: ${SUPPRESSIONROW}" | tee --append RESULT_COMPANY_UNEXPECTED.csv
            ;;
    esac
    rm -f RESULTFILE.csv.temp
done < SUPPRESS_BY_COMPANY
# vim: set expandtab smarttab tabstop=4 shiftwidth=4 softtabstop=4 syntax=sh:
