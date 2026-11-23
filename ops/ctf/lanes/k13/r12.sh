set +e
printf '%s' 'c2V0ICtlCmVjaG8gIj09IHBnX3Jlc3RvcmUgbGlzdCA9PSIKcGdfcmVzdG9yZSAtbCAvdG1wL2NoLmR1bXAgMj4mMSB8IGhlYWQgLTYwCmVjaG8gIj09IHBnX3Jlc3RvcmUgcGxhaW4gPT0iCnBnX3Jlc3RvcmUgLWYgLSAvdG1wL2NoLmR1bXAgMj4mMSB8IGhlYWQgLTMwMAo=' | base64 -d > /tmp/k13pay.41561.sh
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'bash -s' < /tmp/k13pay.41561.sh
echo __PAYLOAD_DONE__
