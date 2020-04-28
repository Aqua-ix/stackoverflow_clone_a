#!/usr/bin/env bash
set -euo pipefail

cwd=$(dirname "${0}")

## gear

find -E "${cwd}"/../web/controller/* ! -regex ".*(book|user).*" | xargs rm -r -f
rm -r -f "${cwd}"/../web/helper
find -E "${cwd}"/../lib/model/* ! -regex ".*(book|user).*" | xargs rm -r -f
find -E "${cwd}"/../lib/repo/* ! -regex ".*(book|user).*" | xargs rm -r -f
find -E "${cwd}"/../test/web/controller/* ! -regex ".*(book|user).*" | xargs rm -r -f
rm "${cwd}"/../web/router.ex

cp -r -f "${cwd}"/../training_src/gear/web/* "${cwd}"/../web/
cp -r -f "${cwd}"/../training_src/gear/lib "${cwd}"/../
cp -r -f "${cwd}"/../training_src/gear/test "${cwd}"/../

## webfrontend

cp -r -f "${cwd}"/../training_src/webfrontend/static/app/* "${cwd}"/../web/static/app/

echo "Finish overriding"
