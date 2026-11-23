import sys, concurrent.futures, ssl, http.client, json
host='10.77.60.20'
ctx=ssl._create_unverified_context()
words=set()
base=['','api','api/v1','api/v2','v1','v2','connector','fieldkest','fieldlink','arwc','water','supply','supplies','replacement','replacement-supply','replacement_supply','procurement','purchase','purchasing','orders','order','quote','quotes','quotation','catalog','catalogue','price','prices','pricing','tariff','district','districts','budget','budgets','vendor','vendors','supplier','suppliers','planning','allocation','allocation-ledger','ledger','customer','customers','tenant','tenants','admin','internal','external','portal','dashboard','service','services','integration','integrations','gateway','health','status','version','info','metadata','routes','docs','openapi.json','swagger.json','.well-known/fieldkest-client','.well-known/fieldkest-connector','.well-known/arwc-client','well-known/fieldkest-client','about','config','settings','workflow','workflows','procurement-reference','reference','references','district-quote','district-quotes']
for b in base:
    words.add('/'+b if b else '/')
    for w in ['supply','quote','quotes','catalog','prices','districts','budgets','orders','tariff','procurement']:
        words.add('/'+b+'/'+w if b else '/'+w)
# explicit likely
words |= {f'/api/{x}' for x in base}
words |= {f'/api/v1/{x}' for x in base}
def req(p):
    try:
        c=http.client.HTTPSConnection(host,443,timeout=4,context=ctx)
        c.request('GET',p,headers={'Host':'connector.arwc.test','Accept':'application/json','User-Agent':'curl/8'})
        r=c.getresponse(); b=r.read(300); c.close()
        if r.status!=404 or b not in (b'{"error":"route_not_found"}',):
            return (p,r.status,b[:200])
    except Exception as e:
        return (p,'ERR',str(e)[:100])
    return None
with concurrent.futures.ThreadPoolExecutor(max_workers=40) as ex:
    for r in ex.map(req,sorted(words)):
        if r: print(r)
