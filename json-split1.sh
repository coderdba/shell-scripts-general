 http://stackoverflow.com/questions/1955505/parsing-json-with-unix-tools
 cat filename.txt| sed -e 's/[{}]/''/g' | awk '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}'
 
 Same code with a filter k="text" to show only fields with name "text" (but this filter is not working)
 cat filename.txt | sed -e 's/[{}]/''/g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}'
 
 Password vault account query output splitter:
 cat res*file | sed -e 's/[{}]/''/g' | sed 's/,"Key/|"Key/g' | awk '{n=split($0,a,"|"); for (i=1; i<=n; i++) print a[i]}'
 
