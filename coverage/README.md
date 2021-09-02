# Code Coverage Report

Script used to generate code coverage report of your project using python
coverage.

Usage: generate_coverage.sh [ -p ][ -a ] [ -g ]

-p run pytest. will run pytest with the correct setup to generate coverage
information for the report

-c coverage only for changed files in branch project folder.

-g report formatted for github-actions. used by github workflow.

Examples:

1. generate coverage report of changed files in metadata_synch

   ```bash
   ~/data/bin/metadata_synch/
   ../../scripts/generate_coverage.sh -p -c
   ```

2. generate coverage report of all files in metadata_synch

   ```bash
   ~/data/bin/metadata_synch/
   ../../scripts/generate_coverage.sh -p
   ```
