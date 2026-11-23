#!/bin/bash
for u in http://workbench.training:8080/ http://workbench.training:8081/ http://workbench.training:8082/ http://workbench.training:8083/ http://developer.training:8080/; do
echo "########## $u"; curl -sS --max-time 10 -i "$u" | head -c 2500; echo; done
