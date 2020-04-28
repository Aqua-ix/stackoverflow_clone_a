#!/usr/bin/env bash
set -euo pipefail

cwd=$(dirname "${0}")
path=$1
gear_name_snakecase=${path##*/}
gear_name_camelcase=$(echo "$gear_name_snakecase" | perl -pe 's/(^|_)./uc($&)/ge;s/_//g')
app_id=$2
group_id=$3

cp -RP ~/project/stackoverflow_clone_a_2020 "$path"
cd "${path}"

sh script/override_by_training_src.sh

git add .
git commit -m "tmp commit"

rm -r -f ./_build
rm -r -f ./deps
rm -r -f ./training_src

git grep -l stackoverflow_clone_a | xargs sed -i "" -e "s/stackoverflow_clone_a/${gear_name_snakecase}/g"
git grep -l StackoverflowCloneA | xargs sed -i "" -e "s/StackoverflowCloneA/${gear_name_camelcase}/g"

git grep -l a_8G5qYRR7 | xargs sed -i "" -e "s/a_8G5qYRR7/${app_id}/g"
git grep -l g_neNqwGcX | xargs sed -i "" -e "s/g_neNqwGcX/${group_id}/g"

rename_command="mv {} \`echo '{}' | sed \"s/stackoverflow_clone_a/${gear_name_snakecase}/g\"\`"
find . -name "*stackoverflow*" -exec bash -c "${rename_command}" \;

rm -r -f ./.git

echo "${gear_name_camelcase} has been creaed."
