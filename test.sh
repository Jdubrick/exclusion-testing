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
main(){
# Define the directory to search
buildToolsDir="$PWD"
# Iterate over stack directories
for stackDir in $buildToolsDir/stacks/*; do
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
cd $buildToolsDir
# Define the directory to search
# buildToolsDir="$PWD"
# # Iterate over stack directories
# for stackDir in $buildToolsDir/stacks/*; do
#     cd "$stackDir"
#     if [[ -f "stack.yaml" ]]; then
#       for versionDir in "$stackDir"/*; do
#         if [[ -d "$versionDir" ]]; then
#           cd $versionDir
#           tar_files_and_cleanup
#         fi
#       done
#     else
#       tar_files_and_cleanup
#     fi
#     cd "$OLDPWD"
# done
# cd $buildToolsDir



# Generate the tar archive
  # for stackDir in stacks/*
  # do
  #   cd $stackDir
  #   if [[ -f "stack.yaml" ]]; then
  #     for versionDir in "${stackDir}"/*
  #     do
  #       echo "version directory : ${versionDir}"
  #       if [[ -d "${versionDir}" ]]; then
  #         echo "version dir is ${versionDir}"
  #         cd $versionDir
  #         tar_files_and_cleanup
  #       fi
  #     done
  #   else
  #     tar_files_and_cleanup
  #   fi
  #   cd "$OLDPWD"
  # done


# Generate the tar archive
  # for stackDir in stacks/*; do
  # if [[ -d "${stackDir}" ]]; then
  #   cd $stackDir
  #   if [[ -f "stack.yaml" ]]; then
  #     for versionDir in * ; do
  #       echo $versionDir
  #       if [[ -d "${versionDir}" ]]; then
  #         cd $versionDir
  #         tar_files_and_cleanup
  #       fi
  #     done
  #   else
  #     tar_files_and_cleanup
  #   fi
  #   cd "$OLDPWD"
  # fi
  # done
  # echo $OLDPWD
  # for stackDir in stacks/*; do
  # if [[ -d "${stackDir}" ]]; then
  #   cd $stackDir
  #   pwd
  #   # Do something within the directory
  #   cd - >/dev/null  # Return to previous directory
  # fi
  # done
}
main


