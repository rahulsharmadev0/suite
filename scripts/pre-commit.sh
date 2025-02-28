#!/bin/bash

# Get all staged files in the specified packages
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACMR | grep -E "^packages/(bloc_suite|dart_suite)/.*\.(dart)$")

if [ -n "$STAGED_FILES" ]; then
  echo "Running dart fix on staged Dart files..."
  
  # Check if bloc_suite has changes
  if echo "$STAGED_FILES" | grep -q "^packages/bloc_suite/"; then
    echo "Fixing bloc_suite files..."
    cd packages/bloc_suite
    dart pub get
    dart format .
    dart fix --apply
    cd ../..
  fi
  
  # Check if dart_suite has changes
  if echo "$STAGED_FILES" | grep -q "^packages/dart_suite/"; then
    echo "Fixing dart_suite files..."
    cd packages/dart_suite
    dart pub get
    dart format .
    dart fix --apply
    cd ../..
  fi
  
  # Add the fixed files back to staging
  git add $STAGED_FILES
fi

exit 0
