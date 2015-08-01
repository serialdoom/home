#!/bin/bash


FILE=~/.fortunes


if [[ ! -f $FILE ]]; then
    which fortune &> /dev/null
    if [[ "$?" -eq 0 ]]; then
        fortune -o
    fi
    exit 0
fi


CNT=$[ $(grep "^%" -c $FILE) / 2 ];
RAND=$(perl -e "print(int(rand($CNT)))");
#echo "CNT is $CNT, rand is $RAND";

perl -n -e "BEGIN {\$cnt = $RAND}; \$cnt -= 1 if (\$_ =~ /^%/); print \$_ if (\$cnt == 0 && \$_ !~ /^%/);" $FILE

