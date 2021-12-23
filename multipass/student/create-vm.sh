NAME=${1:-qqbar2mumu}
NCORES=${2:-4}
MEM=${3:-8}
DISK=${4:-64}

multipass launch --name ${NAME} \
 --cpus ${NCORES} \
 --mem ${MEM}G \
 --disk ${DISK}G \
 --cloud-init ./cloud-init.yaml \
 --timeout 1200

# boostrap spack by requesting a spec
multipass exec ${NAME} -- bash -c "spack/bin/spack spec zlib"

# retrieve the public key(s) for the mirror
multipass exec ${NAME} -- bash -c "spack/bin/spack buildcache keys --install --trust"

# launch the installation (from the build cache)
multipass exec ${NAME} -- bash -c ". ~/spack/share/spack/setup-env.sh && spack env activate ~/nantes-m2-rps-exp/qqbar2mumu-2021 && time spack install --fail-fast --cache-only"

multipass transfer profile ${NAME}:.profile
multipass transfer start ${NAME}:start

