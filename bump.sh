#!/usr/bin/env bash

set -e

ROOT="$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)")"

cur=$(ruby -Ilib -rrematch -e 'puts Rematch::VERSION')
current=${cur//./\\.}
log=$(git log --format="- %s%b" "$cur"..HEAD)

echo     "Current Rematch::VERSION: $cur"
read -rp 'Enter the new version> ' ver

[[ -z $ver ]] && echo 'Missing new version!' && exit 1
num=$(echo "$ver" | grep -o '\.' | wc -l)
[[ $num == 2 ]] || (echo 'Incomplete semantic version!' && exit 1)

version=${ver//./\\.}

# Bump version in files
function bump(){
	sed -i "0,/$current/{s/$current/$version/}" "$1"
}

bump "$ROOT/lib/rematch.rb"

# Update CHANGELOG
changelog=$(cat <<-LOG
	# CHANGELOG

	## Version $ver

	$log
LOG
)

CHANGELOG="$ROOT/CHANGELOG.md"
TMPFILE=$(mktemp)
awk -v l="$changelog" '{sub(/# CHANGELOG/, l); print}' "$CHANGELOG" > "$TMPFILE"
mv "$TMPFILE" "$CHANGELOG"

# Run test to check the consistency across files
bundle exec ruby -Itest test/rematch_test.rb --name  "/rematch::Version match(#|::)/"

# Show diff
git diff -U0

# Optional commit
read -rp 'Do you want to commit the changes? (y/n)> ' input
if [[ $input = y ]] || [[ $input = Y ]]; then
  git add lib/rematch.rb CHANGELOG.md
  git commit -m "Version $ver"
fi
