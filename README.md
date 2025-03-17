# static_analysis_for_dev
This script accepts a path the linux kernel and a maintainers name.


It will then build and run a container image to run static analysis over modules owned by that maintainer using the kernels analysis tool [Coccinelle](https://www.kernel.org/doc/html/latest/dev-tools/coccinelle.html).

## Ex:
```
$ ./static_analysis_for_dev.sh ../net-next/ Nick Child
STEP 1/2: FROM fedora:38
STEP 2/2: RUN dnf install -y coccinelle which git
--> Using cache fe97bcda21aa22a946b3eeff60247076ad07cebd0d0605ecbae20a9ebf352aef
COMMIT cocchicheck
--> fe97bcda21aa
Successfully tagged localhost/cocchicheck:latest
fe97bcda21aa22a946b3eeff60247076ad07cebd0d0605ecbae20a9ebf352aef
drivers/net/ethernet/ibm/ibmvnic.
Running cocchicheck of Nick Child files: drivers/net/ethernet/ibm
make[1]: Entering directory '/linux/drivers/net/ethernet/ibm'

Please check for false positives in the output before submitting a patch.
When using "patch" mode, carefully review the patch before submitting it.

warning: line 140: should noop_llseek be a metavariable?
warning: line 222: should nonseekable_open be a metavariable?
warning: line 289: should nonseekable_open be a metavariable?
warning: line 337: should nonseekable_open be a metavariable?
make[1]: Leaving directory '/linux/drivers/net/ethernet/ibm'
```
