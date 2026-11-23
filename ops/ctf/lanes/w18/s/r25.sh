#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO '
echo "===== analysis files"; ls -la ~/work/analysis; echo "--- odt strings"; (command -v unzip >/dev/null && cd /tmp && rm -rf odt && mkdir odt && cd odt && unzip -o ~/work/analysis/field-notes-2026-08.odt >/dev/null 2>&1 && cat content.xml | sed "s/<[^>]*>/ /g" | tr -s " " | head -80) 2>&1
echo "--- ps1"; cat ~/work/analysis/staging-decoder.ps1
echo "===== service-notes"; cat ~/work/service-notes.md
echo "===== grep arwc.test hostnames all home"; grep -rhoE "[a-z0-9-]+\.arwc\.test" ~ 2>/dev/null | sort | uniq -c | sort -rn | head
echo "===== grep process/service endpoints in repos"; grep -rinE "process-data|process_data|observation|read-only|readonly|/api/[a-z-]+" ~/work ~/repos ~/repos_k05 ~/k05arch 2>/dev/null | grep -v node_modules | grep -viE "source.keplerops|delivery.keplerops|packages.keplerops|review.keplerops|support.keplerops|cloud-api|data.keplerops" | head -40
' 2>&1
