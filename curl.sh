# CALLING CURL FROM SHELL WITH JSON HEADER

# Do a post
result=`curl -s -H "Accept: application/json" -H "Content-type: application/json" -H "Authorization:$token" -X POST -d '{ "account" : { "safe":"PWV-SAFE1", "platformID":"ORACLE", "address":"DBNAME_TNS_ENTRY", "accountName":"DBNAMEAPPUSER1", "password":"'"$password"'", "username":"APPUSER1", "properties": [ {"Key":"Port", "Value":"1522"} ] } }'  $url`

# Do a get
result=`curl -s -H "Accept: application/json" -H "Content-type: application/json" -H "Authorization:$token" -X GET  $url`
