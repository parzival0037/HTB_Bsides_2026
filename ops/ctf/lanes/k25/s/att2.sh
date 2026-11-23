CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"; B=https://support.keplerops.test; CK=/tmp/k25-ck.txt
curl -sS $P --cacert $CA -m 60 -b $CK -o /tmp/t1.zip -w 'zip:%{http_code} type:%{content_type} size:%{size_download}\n' "$B/scp/tickets.php?id=1&a=zip&notes=1&tasks=1"
file /tmp/t1.zip; unzip -l /tmp/t1.zip 2>&1 | head -40
mkdir -p /tmp/t1z && cd /tmp/t1z && unzip -o -q /tmp/t1.zip 2>&1 | head
echo "=== files"; find /tmp/t1z -type f | head -40
echo "=== text contents"
for f in $(find /tmp/t1z -type f); do echo "##### $f"; file -b "$f"; case "$(file -b "$f")" in *text*|*JSON*|*XML*|*CSV*) cat "$f";; *) xxd "$f" | head -20;; esac; echo; done
