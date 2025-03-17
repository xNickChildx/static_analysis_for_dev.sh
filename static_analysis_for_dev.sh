#!/bin/bash

# should probably be using a compose file for this

IMAGE_NAME=cocchicheck
CNTR_CMD=podman

if [ $# -lt 2 ]; then
	echo "USAGE: $0 <path to linux> <maintainer name>"
	exit 1
fi

LINUX=$1
shift 1
USER="$@"

$CNTR_CMD build -t $IMAGE_NAME .

# What we are doing below:
# 1. run this all in a container to avoid my Fedora 41 having unsupported ocaml
# 2. moving a coccicheck file to avoid bug
#            https://lore.kernel.org/all/CANiDSCvLCaMdJVSMahNgg1UQMh3naoTrWGh=9+4p8pePWyLStg@mail.gmail.com/T/
# 3. read the Maintainers file to get a list of all files that a dev maintains
# 4. convert files to module paths, some people (me) maintain drivers/net/ethernet/ibm/ibmvnic.*
#	so change that to convert that to moudule path drivers/net/ethernet/ibm/
# 4. run coccicheck for all those files
# 5. move file back

$CNTR_CMD run --rm -it -v $LINUX:/linux:z -w /linux $IMAGE_NAME bash -c "\
	[ -f scripts/coccinelle/misc/secs_to_jiffies.cocci ] && mv scripts/coccinelle/misc/secs_to_jiffies.cocci ./;
	for i in \`grep -P \"^[RM]:\s+$USER|^F:\" MAINTAINERS | awk '/[RM]:/{getline;print}'| sed 's|\*||' | sed 's|F:\s*\(\S*\)|\1 |'\`; do 
		[ ! -d "\$i" ] && i=\`dirname \"\$i\"\` 
		echo \"Running cocchicheck of $USER files: \$i\";
		make coccicheck MODE=report M=\$i | grep -v /usr/bin/spatch;
	done
	[ -f secs_to_jiffies.cocci ] &&  mv secs_to_jiffies.cocci scripts/coccinelle/
"

