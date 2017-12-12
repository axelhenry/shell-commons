#!/bin/sh

#   arguments username userid groupname groupid password
emptyProcess () {
    echo "$0 ($1, $2, $3, $4, $5)"
}

#   arguments username userid groupname groupid password optionalFunction
createUser () {
    userExists=$(grep "^$1:" /etc/passwd)
    if [ -z "${userExists}" ]; then
        _gid=$(grep ":$4:" /etc/group | cut -d: -f1)
        echo "Groupname associated with given ($4) : ($_gid)."
        if [ -z "${_gid}" ]; then
            echo "Creating group ($3) with ($_gid) gid."
            addgroup -g "${4}" "${3}" > /dev/null 2&>1
            _gid=$(grep ":$4:" /etc/group | cut -d: -f1)
        fi

        #   creating user
        echo "Creating user ($1) with uid ($2), gid ($_gid)."
        adduser -S -G "${_gid}" -u "${2}" -H -D "${1}"

        #   if an optional function was passed to createUser, execute it with username and password as args
        if [ -n "${6}" ]; then
            "${6}" "${1}" "${2}" "${3}" "${4}" "${5}"
        fi
    fi
}
