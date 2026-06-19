import urllib.request
import urllib.error
import json

data = json.dumps({'aula_id':1,'aluno_id':1,'presente':1,'data_presenca':'2026-06-17'}).encode('utf-8')
req = urllib.request.Request('http://127.0.0.1:5000/frequencias', data=data, headers={'Content-Type': 'application/json'})

try:
    response = urllib.request.urlopen(req)
    print(response.read().decode('utf-8'))
except urllib.error.HTTPError as e:
    print(f"Error {e.code}: {e.read().decode('utf-8')}")
