#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -p 2222 rowan@rowan-dev"
$SSH 'python3 - <<"EOF"
import sqlite3,shutil,os
for name,q in [("Cookies","select host_key,name,value,hex(encrypted_value) from cookies"),("History","select url,title,visit_count from urls order by last_visit_time desc limit 40")]:
    p=os.path.expanduser("~/.config/chromium/Default/"+name)
    d="/tmp/"+name+".db"; shutil.copy(p,d)
    print("==",name)
    try:
        c=sqlite3.connect(d)
        for r in c.execute(q):
            print(r)
    except Exception as e: print("ERR",e)
EOF' 2>&1 | grep -v Warning | head -80
