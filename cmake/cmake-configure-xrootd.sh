OPENSSL_ROOT=`brew --prefix openssl`

INSTALLROOT=/Users/laurent/build/XRootD/install

cmake /Users/laurent/alice/sip/XRootD \
                   -DCMAKE_INSTALL_PREFIX=$INSTALLROOT                \
                   -DCMAKE_INSTALL_LIBDIR=$INSTALLROOT/lib            \
                   -DENABLE_CRYPTO=TRUE                               \
                   -DENABLE_PERL=FALSE                                \
                   -DENABLE_KRB5=FALSE                                \
                   -DENABLE_READLINE=FALSE                            \
                   -DCMAKE_BUILD_TYPE=RelWithDebInfo                  \
                   ${OPENSSL_ROOT:+-DOPENSSL_ROOT_DIR=$OPENSSL_ROOT}  \
                   -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="-Wno-error"      \
                   -DCMAKE_MACOSX_RPATH=ON \
                   -DCMAKE_INSTALL_RPATH="@loader_path/../lib" \
                   -G Ninja