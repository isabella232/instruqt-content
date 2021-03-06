#!/bin/bash
# Copyright 2019 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

export TRACK=$(pwd)/$1
export LANGUAGE=$2
node ./track-localizer/index.js
cd ${TRACK}
read -r languages < track-translations.csv
if [ -e $LANGUAGE ]; then
    languages=${languages[@]:4} # Remove word "key," from the list of langauges
    languages=${languages//[$'\t\r\n']} # Trim the newline
else
    languages=$LANGUAGE
fi
for i in ${languages//,/ }
do
    echo "Pushing $i"
    sed -e "s~{{languagecode}}~$i~g" config.yml.template > config.yml
    cp track_$i.yml track.yml
    instruqt track push --force
done
