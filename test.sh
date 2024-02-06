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
    rm -rf $tarFiles
  fi
} 
main(){
# Generate the tar archive
  for stackDir in stacks/*; do
  if [[ -d "${stackDir}" ]]; then
    cd $stackDir
    if [[ -f "stack.yaml" ]]; then
      for versionDir in * ; do
        echo $versionDir
        if [[ -d "${versionDir}" ]]; then
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
  echo $OLDPWD
}
main


