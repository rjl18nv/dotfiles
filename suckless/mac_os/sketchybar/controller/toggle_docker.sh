#!/usr/bin/env fish

set -l grey "0xff7F7F7F"
set -l green "0xff99cc99"

if pgrep -x "OrbStack" >/dev/null
   /usr/local/bin/orb stop -a
   killall OrbStack
   sketchybar --set docker icon.color=$grey label="VM/Off"
else
   /usr/local/bin/orb start -a
   open -a 'OrbStack'
   sketchybar --set docker icon.color=$green label="VM/On"
end
