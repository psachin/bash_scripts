#!/bin/bash

FROM="fossee.in"
TO="fosseeapps.in"

cd /home
USER_LIST=$(ls -1)


for uuser in ${USER_LIST}
do
    echo "rsync -r -v -l -a -z /home/${uuser}/Maildir/* ${TO}:/home/${uuser}/Maildir/"
done


