#!/bin/bash

stringContain() { [ -z "${2##*$1*}" ]; }

for otf in ./otf/*.otf; do
	woff="./woff/$(basename "$otf" .otf).woff"
	svg="./svg/$(basename "$otf" .otf).svg"
	ttf="./ttf/$(basename "$otf" .otf).ttf"
	if ! [ -e "$ttf" ]; then
		ttf="./ttf/$(basename "$otf" .otf)ah.ttf"
	fi
	[ -e "$otf" ] && [ -e "$woff" ] && [ -e "$svg" ] && [ -e "$ttf" ] \
		|| echo "Missing $otf"

	info=$(otfinfo "$otf" -i)
	family=$(echo "$info" | sed -n 's/Family:\s*\(.*\) O/\1/p')
	subfamily=$(echo "$info" | sed -n 's/Subfamily:\s*\(.*\)/\1/p')

	weight="normal"
	if stringContain "Bold" "$subfamily"; then
		weight="bold"
	fi
	if stringContain "Semibold" "$subfamily"; then
		weight="600"
	fi

	style="normal"
	if stringContain "Italic" "$subfamily"; then
		style="italic"
	fi
	if stringContain "Regular" "$subfamily"; then
		style="normal"
	fi

	echo "@font-face {"
	echo "    font-family: '$family'; /* $subfamily */"
	echo "    src: url('$woff') format('woff'),"
	echo "         url('$otf') format('opentype'),"
	echo "         url('$ttf') format('truetype'),"
	echo "         url('$svg') format('svg');"
	echo "    font-display: swap;"
	echo "    font-weight: $weight;"
	echo "    font-style: $style;"
	echo "}"
done
