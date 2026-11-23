#!/bin/bash
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev"
$S 'base64 -w0 ~/w09/company-history.dump'
