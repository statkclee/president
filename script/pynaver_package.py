import requests
import json

client_id = 'mdoqRNQJ2yFdket16CMb'
client_secret = "aK6X1cAVWa"

start = '2021-11-01' 
end = '2022-02-22'
url = 'https://openapi.naver.com/v1/datalab/search' 

headers = {'X-Naver-Client-Id':client_id, 
           'X-Naver-Client-Secret':client_secret, 
           'Content-Type':'application/json'} 
           
json = {'startDate':start, 
        'endDate':end, 
        'timeUnit':'date', 
        'keywordGroups':[{'groupName':"이재명", 'keywords':["이재명"]},
                         {'groupName':"윤석열", 'keywords':["윤석열"]},
                         {'groupName':"안철수", 'keywords':["안철수"]},
                         {'groupName':"심상정", 'keywords':["심상정"]}], 
        'device':''} 

r = requests.post(url, json = json, headers = headers) 

if r.status_code == 200: 
  print(r.text) 
else: 
  print("Error Code:" + r.status_code)

with open("./data/naver_20220222.json", 'w', encoding='utf8') as f:
    f.write(r.text)

