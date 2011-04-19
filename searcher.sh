#!/bin/sh

# Search Google Videos for the search term and times specified below:
# Separate muliple search terms with + i.e.: 'albert+einstein'

SEARCH_LONG='y'
SEARCH_MED='y'
SEARCH_SHORT='n'

while getopts :lms OPT; do
    case $OPT in
	+l)
	    SEARCH_LONG=y
	    ;;
	l)
	    SEARCH_LONG=n
	    ;;
	+m)
	    SEARCH_MED=y
	    ;;
	m)
	    SEARCH_MED=n
	    ;;
	+s)
	    SEARCH_SHORT=y
	    ;;
	s)
	    SEARCH_SHORT=n
	    ;;
	*)
	    echo "usage: `basename $0` [+-lms} [--] ARGS..."
	    exit 2
    esac
done
shift `expr $OPTIND - 1`
OPTIND=1

if [ $# -lt 1 ]; then
    echo "At least one search term is required"
    exit 2
fi


SEARCH=`echo "$@" | tr ' ' '+'`
# Select which lengths of video you want
##
# Subsequently return all the videos in one, sorted, deduped list of ID's
# 
BASENAME='seed_videos_'
OUTNAME='_dedupe'
NAME=$BASENAME$SEARCH
OUT=$NAME$OUTNAME

searching () {
for i in `seq 0 10 990 `
do curl -A "AT, Bitches" "http://www.google.com/search?q=$SEARCH+site:video.google.com&hl=en&safe=off&tbs=dur:$1&tbm=vid&start=$i&sa=N"|grep -o "docid=[0-9-]*"|tee -a "$BASENAME$SEARCH"
done
}

if [ $SEARCH_LONG = 'y' ];
	then
	searching "l"
fi
if [ $SEARCH_MED = 'y' ];
        then
        searching "m"
fi
if [ $SEARCH_SHORT = 'y' ];
        then
        searching "s"
fi

sort $NAME | uniq -u | tee $OUT
SEARCHCOUNT=$(cat $OUT | wc -l) 
echo "Search term '$SEARCH' returned $SEARCHCOUNT deduped results."

