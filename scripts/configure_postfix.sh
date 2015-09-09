#!/bin/bash
source $( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"/scripts/settings.sh"

echo "***********************************************"
echo "***   Configure postfix   *********************"
echo "***********************************************"

if [ -z "$POSTFIX_REDIRECT_ALL_EMAIL_TO" ] ; then
    echo "Nothing to do. POSTFIX_REDIRECT_ALL_EMAIL_TO is empty"
else
    echo ""
    echo "/./ $POSTFIX_REDIRECT_ALL_EMAIL_TO" > /etc/postfix/recipient_canonical
    echo -n "put to /etc/postfix/recipient_canonical: "
    cat /etc/postfix/recipient_canonical
    postconf -e "recipient_canonical_maps=regexp:/etc/postfix/recipient_canonical"
    echo "put to /etc/postfix/main.cf: recipient_canonical_maps=regexp:/etc/postfix/recipient_canonical"

    #restart apache
    echo ""
    echo "restart postfix"
    systemctl restart postfix
fi
