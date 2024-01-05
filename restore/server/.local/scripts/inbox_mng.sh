#!/bin/bash
src_file="$1"
dst_path="$2"
tmpname="${src_file}.bkp"

declare -A tag_map

tag_map["#aipaper"]="Notes/content/AI/reading_list#Papers"
tag_map["#aiblog"]="Notes/content/AI/reading_list#Blog Posts"
tag_map["#airepo"]="Notes/content/AI/reading_list#Repositories"
tag_map["#aivideo"]="Notes/content/AI/reading_list#YouTube Videos"
tag_map["#ai"]="Notes/content/AI/reading_list#Other"
tag_map["#seo"]="Notes/content/blogging/Blogging#SEO"
tag_map["#graphics"]="Notes/content/graphics/Graphics#Other"
tag_map["#learning"]="Notes/content/learning/reading_list#Other"
tag_map["#maths"]="Notes/content/maths/Maths#Other Maths"
tag_map["#physics"]="Notes/content/maths/Maths#Other Physics"
tag_map["#workout"]="Notes/fitness/workouts/Workouts#Other"
tag_map["#cs"]="Notes/content/cs/reading_list#Other"
tag_map["#model"]="Notes/wellbeing/life_advice/Life_Advice#Role Models"
tag_map["#children"]="Notes/content/parenting/Parenting#Other"


function process_line {
    # Extract the tag from the line using grep
    tag=$(echo "$1" | grep -o '#[[:alnum:]_]*' | head -n1)
    if [ -n "$tag" ] && [ -n "${tag_map[$tag]}" ]; then
        echo "${tag_map[$tag]}"
    else
        echo "notag"
    fi
}

function append_to_file {
    path=`echo "$1" | cut -d '#' -f1`
    anchor=`echo "$1" | cut -d '#' -f2`
    line=$2

    sed -i "/^#\+ *$anchor/a $line\n" "$dst_path/$path"
}

while IFS= read -r line; do
    matching_file=`process_line "$line"`

    if [[ "$matching_file" == "notag" ]]; then
        echo -e "$line" >> "$tmpname"
    else
        line=`echo "$line" | sed 's/#[[:alnum:]_]*//'`
        append_to_file "$matching_file" "$line"
    fi

done < "$src_file"

mv "$tmpname" "$src_file"

