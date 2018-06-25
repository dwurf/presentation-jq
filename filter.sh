#!/usr/bin/env bash

jq -S '
  .realnames as $names
  | .posts[]
  | {title, author: $names[.author]}
  ' <( cat deep.json)
