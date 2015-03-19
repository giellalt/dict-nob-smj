#!/bin/bash

pct_bad () {
    for f in *_*; do
        grep -q ^@ "$f" || continue
        bad=$(grep -c ^@ "$f")
        tot=$(sed 's/^[@+?-]//' "$f" |sort -u|wc -l)
        diff=$(echo | awk "{printf \"%.2f %\", 100*${bad}/${tot}}")
        echo  "$f	${bad}	${tot}	${diff}"
    done |
        sort -nrt$'\t' -k4,4 |
        awk 'BEGIN{OFS=FS="\t"} {b+=$2;t+=$3;print} END{printf " \nSUM\t%d\t%d\t%.2f %", b, t, 100*b/t}'
}
cat <(echo -e "FILENAME\tMARKED BAD\tTOTAL PAIRS\tPCT BAD") <(pct_bad) |
    column -ts$'\t'
