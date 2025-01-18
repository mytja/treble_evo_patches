#!/bin/bash
patches="$(readlink -f -- $1)"

./patches/apply-patches.sh $patches lineage-prerequisite
./patches/apply-patches.sh $patches trebledroid
./patches/apply-patches.sh $patches personal

