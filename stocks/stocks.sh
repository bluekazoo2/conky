#!/bin/bash

TOKEN=$1
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CONF=$DIR/stocks.conf
OUT_DIR=/tmp

while IFS= read -r ticker
do
    curl -s -k "https://cloud.iexapis.com/beta/stock/${ticker}/quote?token=${TOKEN}&displayPercent=true" | \
	jq -r '[(.latestPrice | tostring) , (.change | tostring) , (.changePercent | tostring)] | join(",")' > $OUT_DIR/${ticker}.csv
done <"$CONF"
