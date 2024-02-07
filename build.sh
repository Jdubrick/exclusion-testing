#
# Copyright Red Hat
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

buildToolsFolder="$(dirname "$0")"
buildToolsDir="$PWD"

display_usage() { 
  echo "usage: build.sh <path-to-registry-repository-folder> <output-dir>" 
} 

tar_files_and_cleanup() {
  # Find the files to add to the tar archive
  tarFiles=$(find . \( -not -name 'devfile.yaml' \
    -a -not -name "meta.yaml" \
    -a -not -name "*.vsx" \
    -a -not -name "." \
    -a -not -name "logo.svg" \
    -a -not -name "logo.png" \
    -a -not -name "*.zip" \
    -a -not -name "OWNERS" \) -maxdepth 1)

  # There are files that need to be pulled into a tar archive
  if [[ ! -z $tarFiles ]]; then
    tar -czvf archive.tar $tarFiles > /dev/null
    #rm -rf $tarFiles
  fi
}

# build_registry <registry-folder> <output>
# Runs the steps to build the registry. Mainly:
# 1. Copying over registry repository to build folder
# 2. Building the index-generator tool -> ToDo: Download specific release of index-generator rather than building it
# 3. Create the tar archives for any miscellaneous files in each stack
# 4. Generate the index.json
build_registry() {
  # Copy the registry repository over to the destination folder
  cp -rf $registryRepository/. $outputFolder/

  echo $outputFolder
  # Generate the tar archive
  for stackDir in $outputFolder/stacks/*; do
  if [[ -d "$stackDir" ]]; then
    cd "$stackDir"
    if [[ -f "stack.yaml" ]]; then
      for versionDir in "$stackDir"/*; do
        if [[ -d "$versionDir" ]]; then
          cd $versionDir
          tar_files_and_cleanup
        fi
      done
    else
      tar_files_and_cleanup
    fi
    cd "$OLDPWD"
  fi
  done
  cd "$buildToolsDir"
}
registryRepository=$1
outputFolder=$2

# Build the registry
build_registry