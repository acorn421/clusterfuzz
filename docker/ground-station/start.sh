#!/bin/bash -ex

# Setup Common
# source /work/setup_nfs.sh
source /work/setup_common.sh

# Setup clusterfuzz
source /work/setup_clusterfuzz.sh

bash -ex /work/start_clusterfuzz.sh
