#!/bin/bash


FILE=~/.fortunes


if [[ ! -f $FILE ]]; then
    echo "Error, fortune file [$FILE] not found";
    exit 1;
fi


CNT=$[ $(grep "^%" -c $FILE) / 2 ];
RAND=$(perl -e "print(int(rand($CNT)))");
#echo "CNT is $CNT, rand is $RAND";

perl -n -e "BEGIN {\$cnt = $RAND}; \$cnt -= 1 if (\$_ =~ /^%/); print \$_ if (\$cnt == 0 && \$_ !~ /^%/);" $FILE

