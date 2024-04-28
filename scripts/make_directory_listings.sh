#!/bin/bash

# Function: create_gnu_index
# Updated: Wed Apr 10 21:04:12 2013 by webmaster@askapache
# @ http://u.askapache.com/2013/04/gnu-mirror-index-creator.txt
# Copyright (C) 2013 Free Software Foundation, Inc.
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# This method has been slightly modifed

function create_gnu_index ()
{
    # call it right or die
    [[ $# -ne 2 ]] && echo "bad args. do: $FUNCNAME '/DOCUMENT_ROOT/' '/'" && exit 2

    # D is the doc_root containing the site
    local L="" D="$1" SUBDIR="$2" F=

    # The index.html file to create
    F="${D}index.html"

    # if dir doesnt exist, create it
    [[ -d "$D" ]] || mkdir -p "$D"

    # cd into dir or die
    pushd "$D" > /dev/null || exit 2

    # touch index.html and check if writable or die
    touch "$F" && test -w "$F" || exit 2

    # start of total output for saving as index.html
    (

        # print the html header
        echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">';
        echo "<html><head><title>Index of Pages - ${SUBDIR}</title></head>";
        echo "<body><h1>Index of ${SUBDIR}</h1><pre>      Name                                        Last modified      Size";

        # Print back to parent dir listing
        [ "$(basename "$D")" != public ] && echo "      <a href=\"..\">..</a>                                          -                  -"

        # now output a list of all directories in this dir (maxdepth 1) other than '.' outputting in a sorted manner exactly like apache
        find -L . -mount -depth -maxdepth 1 -type d ! -name '.' -printf "      <a href=\"%f\">%-43f@_@%Td-%Tb-%TY %Tk:%TM  -\n" | sort -d | sed 's,\([\ ]\+\)@_@,/</a>\1,g'

        # start of content output
        (
            # change IFS locally within subshell so the for loop saves line correctly to L var
            IFS=$'\n';

            # pretty sweet, will mimick the normal apache output
            for L in $(find -L . -mount -depth -maxdepth 1 -type f ! -name 'index.html' -printf "      <a href=\"%f\">%-44f@_@%Td-%Tb-%TY %Tk:%TM  @%f@\n" | sort | sed 's,\([\ ]\+\)@_@,</a>\1,g')
            do
                # file
                F=$(sed -e 's,^.*@\([^@]\+\)@.*$,\1,g'<<<"$L")

                # file with file size
                F=$(du -bh $F | cut -f1)

                # output with correct format
                sed -e 's,\ @.*$, '"$F"',g'<<<"$L"
            done
        )

        # print the footer html
        echo "</pre></body></html>";

    # finally save the output of the subshell to index.html
    )  > "$F";

    popd > /dev/null || exit
}

# call it right or die
[[ $# -gt 1 ]] && echo "bad args. do: $0 '<path>'" && exit 2

[[ $# -eq 1 ]] && (cd "$1" || exit 2)

path="$(pwd)/"

find public -mount -type d -print0 | while read -d $'\0' file; do
    if [ ! -f "$file/index.html" ] && [ ! -f "$file.html" ]; then
        create_gnu_index "$path$file/" "${file#public/}/"
    fi
done
