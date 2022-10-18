what=${1:dev}

watchman watch $HOME/alice/${what}/O2
watchman -j < doxygen.${what}.json
