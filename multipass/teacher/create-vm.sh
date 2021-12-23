NAME=${1:-m2exp}
NCORES=${2:-8}
MEM=${3:-16}
DISK=${4:-64}

multipass launch --name ${NAME} \
 --cpus ${NCORES} \
 --mem ${MEM}G \
 --disk ${DISK}G \
 --cloud-init ./cloud-init.yaml \
 --timeout 600

multipass transfer profile ${NAME}:.profile
