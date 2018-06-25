#!/usr/bin/env bash

(

jq -S '
  map({ host: .certname, puppet: . }) | .[]
' <( cat puppet.json )

jq -S '
  map({ host: .hostname, ansible: { owner: .owned_by }}) | .[]
' <( cat ansible.json )

) \
| jq -rs '
  group_by(.host)
  | map(reduce .[] as $x ({}; . * $x))
  | map(select(.ansible))
  | map(. | @json | @base64)
  | .[]
' \
| while read base64 ; do 
    json=$(echo "$base64" | base64 --decode | jq -S .)
    host=$(echo "$json" | jq -r .host)
    echo "$host"
done
