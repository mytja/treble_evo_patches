#!/bin/bash
patches="$(readlink -f -- $1)"

./patches/apply-patches.sh $patches trebledroid
./patches/apply-patches.sh $patches trebledroid-corrections # TODO: Merge this with respective patches in TrebleDroid. IT SHOULD ONLY BE TEMPORARY!!!!!
./patches/apply-patches.sh $patches trebledroid-backports
./patches/apply-patches.sh $patches personal
