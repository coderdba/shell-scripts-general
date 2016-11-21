 http://stackoverflow.com/questions/1955505/parsing-json-with-unix-tools
 cat filename.txt| sed -e 's/[{}]/''/g' | awk '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}'
 
 Same code with a filter k="text" to show only fields with name "text" (but this filter is not working)
 cat filename.txt | sed -e 's/[{}]/''/g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}'
 
 Password vault account query output splitter:
 cat res*file | sed -e 's/[{}]/''/g' | sed 's/,"Key/|"Key/g' | awk '{n=split($0,a,"|"); for (i=1; i<=n; i++) print a[i]}'
 cat res*file | sed -e 's/[{}]/''/g' | sed 's/,"Key/|"Key/g' | sed 's/,"accounts"/\|"accounts"/g' | awk '{n=split($0,a,"|"); for (i=1; i<=n; i++) print a[i]}' | sed 's/"//g'| sed 's/\[//g' | sed 's/\]//g'
 cat res*file | sed -e 's/[{}]/''/g' | sed 's/,"Key/|"Key/g' |  sed 's/"//g' | sed 's/\,accounts/\|/g' | sed 's/:\[AccountID/AccountID/g' | sed 's/\,Internal/\|Internal/g' | sed 's/\,Properties:\[/\|/g' | awk '{n=split($0,a,"|"); for (i=1; i<=n; i++) print a[i]}'
 cat res*file | sed -e 's/[{}]/''/g' | sed 's/,"Key/|"Key/g' |  sed 's/"//g' | sed 's/\,accounts/\|/g' | sed 's/:\[AccountID/AccountID/g' | sed 's/\,InternalProperties:\[/\|/g' | sed 's/\,Properties:\[/\|/g' | awk '{n=split($0,a,"|"); for (i=1; i<=n; i++) print a[i]}' | sed 's/\]//g'

 
