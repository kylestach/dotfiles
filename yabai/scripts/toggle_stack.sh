#!/bin/bash
space=$(yabai -m query --spaces --space | jq ".id")
layout=$(yabai -m query --spaces --space | jq ".type")

if [[ "$layout" == "\"bsp\"" ]]; then
    yabai -m space --layout stack
else
    yabai -m space --layout bsp
fi
