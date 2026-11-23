#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO '
echo "##### registry/README.md"; cat ~/work/registry/README.md
echo "##### inspection-normal.json"; cat ~/work/registry/inspection-normal.json
echo "##### consumer-request.json"; cat ~/work/registry/consumer-request.json
echo "##### indexer-client.json"; cat ~/work/reproducers/indexer-client.json
echo "##### fki file"; file ~/work/registry/inspection-compat.fki; ls -l ~/work/registry/inspection-compat.fki; xxd ~/work/registry/inspection-compat.fki | head -30
echo "##### fki contents attempt"; python3 - <<PY
import zipfile,tarfile
p="/home/rowan/work/registry/inspection-compat.fki"
for mod in (zipfile,tarfile):
    try:
        if mod is zipfile:
            z=zipfile.ZipFile(p); print("ZIP",z.namelist())
            for n in z.namelist():
                print("---",n); print(z.read(n)[:2000])
        else:
            t=tarfile.open(p); print("TAR",t.getnames())
    except Exception as e: print(mod.__name__,"ERR",e)
PY
echo "##### all fki"; find / -name "*.fki" 2>/dev/null | head; echo "##### .fki under home"; find ~ -iname "*.fki" -o -iname "*.fkdiag" 2>/dev/null | head
echo "##### staging-decoder"; cat ~/work/analysis/staging-decoder.ps1
echo "##### odt text"; python3 - <<PY
import zipfile,re
try:
    z=zipfile.ZipFile("/home/rowan/work/analysis/field-notes-2026-08.odt")
    x=z.read("content.xml").decode("utf-8","replace")
    print(re.sub(r"<[^>]+>"," ",x)[:4000])
except Exception as e: print("ERR",e)
PY
echo "##### indexer binary strings"; strings -n 6 ~/work/reproducers/fieldkest-bundle-indexer | grep -iE "fki|register|tag|historian|cairn|arwc|manifest|digest|revision" | head -40
' 2>&1
