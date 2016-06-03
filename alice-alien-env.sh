
# you'll want to change this obviously to reflect your name and location
#export alien_API_USER=laphecet 
#export alien_CLOSE_SE=Alice::Subatech::SE
#export alien_CLOSE_SE=Alice::CCIN2P3::SE
# the one below is for alien login (not aliensh as above)
#export ALIEN_USER=laphecet

#export GSHELL_ROOT=${HOME}/Alice/xgapi
#export 
GSHELL_ROOT=${HOME}/alien/api

export X509_CERT_DIR=${GSHELL_ROOT}/share/certificates/

#export XrdSecSSLCADIR=${X509_CERT_DIR}

    if [ "${LD_LIBRARY_PATH+set}" = set ]; then
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${GSHELL_ROOT}/lib
    else
	export LD_LIBRARY_PATH=${GSHELL_ROOT}/lib
    fi

export PATH=${PATH}:${HOME}/alien/api/bin
export DYLD_LIBRARY_PATH=${LD_LIBRARY_PATH}



