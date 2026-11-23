#!/bin/bash
set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev"
$S 'set +e
echo "########## WORK TREE"
find ~/work -maxdepth 4 -type f -printf "%10s %p\n" 2>/dev/null | sort -k2
echo "########## results dir"
ls -laR ~/results 2>/dev/null | head -40
echo "########## bash_history"
cat ~/.bash_history 2>/dev/null
echo "########## README"
cat ~/README.md 2>/dev/null
echo "########## local-helper.md"
cat ~/work/local-helper.md 2>/dev/null
echo "########## field notes odt"
python3 - <<PY
import zipfile,re,html
try:
    z=zipfile.ZipFile("/home/rowan/work/analysis/field-notes-2026-08.odt")
    x=z.read("content.xml").decode()
    x=re.sub(r"</text:p>","\n",x); x=re.sub(r"<[^>]+>","",x)
    print(html.unescape(x)[:6000])
except Exception as e: print("ERR",e)
PY
echo "########## staging-decoder"
cat ~/work/analysis/staging-decoder.ps1 2>/dev/null
echo "########## sample"
cat ~/work/samples/FK-SAMPLE-017.json 2>/dev/null
echo "########## previews"
ls -la ~/work/previews 2>/dev/null; for f in ~/work/previews/*; do [ -f "$f" ] && { echo "### $f"; head -c 3000 "$f"; echo; }; done
echo "########## registry"
ls -la ~/work/registry 2>/dev/null; for f in ~/work/registry/*; do [ -f "$f" ] && { echo "### $f"; head -c 3000 "$f"; echo; }; done
echo "########## config dir"
find ~/.config -maxdepth 3 -type f -printf "%10s %p\n" 2>/dev/null
for f in ~/.config/fieldlink/*; do [ -f "$f" ] && { echo "### $f"; cat "$f"; echo; }; done
echo "########## build-operations"
for f in ~/work/build-operations/*; do [ -f "$f" ] && { echo "### $f"; cat "$f"; echo; }; done
echo DONE_A2
' 2>&1
