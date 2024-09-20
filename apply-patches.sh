#!/bin/bash

# TrebleDroid patches are TrebleDroid's patches_for_developers.zip
# TrebleDroid personal patches are TrebleDroid's patches, except that they apply on top of other patches on EvolutionX's source
# Personal patches are my own patches, mostly to ensure EvolutionX compatibility

set -e

source="$(readlink -f -- $1)"
patches_directory="$source/patches"

apply_directory=$2
if [[ -z "$apply_directory" ]]; then
	apply_directory=$(cd $patches_directory; echo *)
elif [[ "$apply_directory" == trebledroid ]]; then
	apply_directory="trebledroid"
elif [[ "$apply_directory" == personal ]]; then
	apply_directory="personal"
elif [[ ! -d "$apply_directory" ]]; then
	echo "The directory $apply_directory doesn't exist!"
	exit 1
fi

for patch_source in $apply_directory; do
	if [[ "$patch_source" == apply-patches.sh ]]; then
		continue
	fi
	if [[ "$patch_source" == README.md ]]; then
		continue
	fi
	if [[ "$apply_directory" == trebledroid ]]; then
		patch_source="0001-TrebleDroid"
	elif [[ "$apply_directory" == personal ]]; then
		patch_source="0002-personal"
	fi

	printf "\n ### APPLYING $patch_source PATCHES ###\n";
	sleep 1.0;
	for path in $(cd $patches_directory/$patch_source; echo *); do
		tree="$(tr _ / <<<$path | sed -e 's;platform/;;g')"
		printf "\n| $path ###\n";
		[ "$tree" == build ] && tree=build/make
		[ "$tree" == vendor/hardware/overlay ] && tree=vendor/hardware_overlay
		[ "$tree" == treble/app ] && tree=treble_app
		pushd $source/$tree

		for patch in $patches_directory/$patch_source/$path/*.patch; do
			# Check if patch is already applied
			if patch -f -p1 --dry-run -R < $patch > /dev/null; then
				printf "### ALREDY APPLIED: $patch \n";
				continue
			fi

			if git apply --check $patch; then
				git am $patch
			elif patch -f -p1 --dry-run < $patch > /dev/null; then
				#This will fail
				git am $patch || true
				patch -f -p1 < $patch
				git add -u
				git am --continue
			else
				printf "### FAILED APPLYING: $patch \n"
			fi
		done

		popd
	done
done
