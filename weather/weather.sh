#!/bin/bash

TOKEN=$1
LAT=$2
LNG=$3

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
OUT_DIR=/tmp

curl -s -k "https://api.darksky.net/forecast/$TOKEN/$LAT,$LNG?exclude=daily,alerts,flags" | sed -e "s/Possible/Poss/g" > $OUT_DIR/weather.json

cat $OUT_DIR/weather.json | \
    jq -r '[(.currently.temperature | tostring), (.currently.icon | tostring), (.currently.summary | tostring), (.minutely.summary | tostring)] | join(",")' | \
    sed -e "s/ and /\//g" | \
    sed -e "s/Humid\\/mostly/Hmd\\/mstly/g" | \
    sed -e "s/hour/hr/g" > $OUT_DIR/weather.csv

cat $OUT_DIR/weather.json | jq -r '.hourly.data[].temperature' | head -12 | sort -n > $OUT_DIR/weather_tmps.csv
