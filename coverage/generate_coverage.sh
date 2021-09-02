#!/bin/bash

usage() {
  echo "Usage: $0 [ -p ] [ -a ] [ -g ]" 1>&2
  echo "-p run pytest" 1>&2
  echo "-c coverage only for changed files in branch project folder" 1>&2
  echo "-g report formatted for github-actions" 1>&2
  exit 1
}

run_pytest=0
changed_files_only=0
ga_report=0

while getopts ":pcg" opt; do
  case $opt in
    p)
      run_pytest=1
      ;;
    c)
      changed_files_only=1
      ;;
    g)
      ga_report=1
      ;;
    \?)
      usage
      ;;
  esac
done

if [ $run_pytest = 1 ]; then
  pytest --cov-branch --cov=. --cov-report= tests/
fi

#base root folder
REPO_FOLDER="$(git rev-parse --show-toplevel)"

#folder of the project without root folder
CURRENT_PROJECT_FOLDER="${PWD#$REPO_FOLDER/}"

files=""
report=""

if [ $changed_files_only = 1 ]; then
  # $files will receive a list of all .py files changed in project folder by the pr with exception
  # of files in tests/ folder
  files=$(git diff --name-only --merge-base origin/master -- '*.py' ':!tests/' | cat)
  if [ -n "$files" ]; then

    # remove project folder from path.
    # ie. ./lib/metadata_synch/metadata_synch/services/clean_folder.py = metadata_synch/services/clean_folder.py
    files="$(echo "$files" | grep -oP "^$CURRENT_PROJECT_FOLDER\/\K.*")"
    # replace newline with ','
    files=${files//$'\n'/','}
    # generate coverage report based on files changed
    report=$(coverage report --include="$files")

  fi
else
  report=$(coverage report --omit=./tests/*,./.venv/*)
fi

if [ $ga_report = 1 ]; then
  # github actions output does not accept multiline string so we replace that newline and other special characters
  report="${report//'%'/'%25'}"
  report="${report//$'\n'/'%0A'}"
  report="${report//$'\r'/'%0D'}"
  echo "::set-output name=coverage_result::$report"
else
  echo "$report"
fi
