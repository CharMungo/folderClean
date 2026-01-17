#!/usr/bin/bash

direct="$1"
filetype="$2"
originals="$3"

if [[ "$originals" == "" ]]; then
	originals=n
fi

if [[ "$direct" =~ \/$ ]]; then
    directory="${direct%/}"
else
    directory="$direct"
fi

if [[ "$1" == "" && "$2" == "" ]]; then
	echo "fileClean [directory] [filetype] [y/n do you want remove files that do not have an original?]"
fi


list_files() {
	directory="$1"
	originals="$2"
	filetype="$3"
	total=0
	files=( "$directory"/* )
	if [[ "$originals" == "y" ]]; then
		for file in "${files[@]}"; do
			if [[ $file =~ \([0-9]+\)${filetype}$ ]]; then
				printf '%s\n' "$file"
				((total+=1))
			fi
		done
	else
		for file in "${files[@]}"; do
			if [[ $file =~ \([0-9]+\)${filetype}$ ]]; then
				no_type="${file%$filetype}"
				origin=$(echo "$file" | sed -E 's/\([0-9]+\)//')
				if [ -f "$origin" ]; then
					echo "$file"
					((total+=1))
				fi

			fi
		done
	fi
}

delete_files() {
	directory="$1"
	originals="$2"
	filetype="$3"
	total=0
	files=( "$directory"/* )
	if [[ "$originals" == "y" ]]; then
		for file in "${files[@]}"; do
			if [[ $file =~ \([0-9]+\)${filetype}$ ]]; then
				rm "$file"
				printf '%s\n' "$file deleted"
				((total+=1))
			fi
		done
	else
		for file in "${files[@]}"; do
			if [[ $file =~ \([0-9]+\)${filetype}$ ]]; then
				no_type="${file%$filetype}"
				origin=$(echo "$file" | sed -E 's/\([0-9]+\)//')
				if [ -f "$origin" ]; then
					rm "$file"
					printf '%s\n' "$file deleted"
					((total+=1))
				fi

			fi
		done
	fi
}


list_files "$directory" "$originals" "$filetype"
if [[ "$total" == 0 ]]; then
    echo "No files found"
    exit
else
    echo "$total files found"
fi
echo "Delete these files? (y/n)"
read -r answer

if [[ "$answer" == y ]]; then
	delete_files "$directory" "$originals" "$filetype"
	echo "$total files deleted"
else
    echo "Ended"
    exit
fi

