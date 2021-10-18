#!/bin/bash

stringContain() { [ -z "${2##*$1*}" ]; }

for otf in ./otf/*.otf; do
	woff="./woff/$(basename "$otf" .otf).woff"
	woff2="./woff2/$(basename "$otf" .otf).woff2"
	svg="./svg/$(basename "$otf" .otf).svg"
	ttf="./ttf/$(basename "$otf" .otf).ttf"
	if ! [ -e "$ttf" ]; then
		ttf="./ttf/$(basename "$otf" .otf)ah.ttf"
	fi
	if ! [ -e "$ttf" ]; then
		ttf=""
	fi

	info=$(otfinfo "$otf" -i)
	family=$(echo "$info" | sed -n 's/Family:\s*\(.*\)\( O\)\?/\1/p')
	subfamily=$(echo "$info" | sed -n 's/Subfamily:\s*\(.*\)/\1/p')

	weight="normal"
	if stringContain "Bold" "$family"; then
		weight="bold"
	fi
	if stringContain "Semibold" "$family"; then
		weight="600"
	fi

	style="normal"
	if stringContain "Italic" "$family $subfamily"; then
		style="italic"
	fi
	if stringContain "Regular" "$family $subfamily"; then
		style="normal"
	fi

	echo "@font-face {"
	echo "    font-family: '$family'; /* $subfamily */"
	echo "    src: "
	[ -e "$svg" ]   && echo "         url('$svg')   format('svg'),"
	[ -e "$ttf" ]   && echo "         url('$ttf')   format('truetype'),"
	[ -e "$woff" ]  && echo "         url('$woff')  format('woff'),"
	[ -e "$woff2" ] && echo "         url('$woff2') format('woff2'),"
	echo "         url('$otf') format('opentype');"
	echo "    font-display: swap;"
	echo "    font-weight: $weight;"
	echo "    font-style: $style;"
	echo "}"
done
