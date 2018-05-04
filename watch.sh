#!/usr/local/bin/pwsh
pks clusters --json |convertfrom-json | foreach {$_ | select name, last_action_state | out-default}