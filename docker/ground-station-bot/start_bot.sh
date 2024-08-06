#!/bin/bash -ex

# Setup Common
# source /work/setup_common.sh

export DISPLAY=:1
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="$EXTRA_PATH:$PATH"
export TZ='Asia/Seoul'

# Port forwarding
envsubst '$CLUSTERFUZZ_SERVER_HOST' < /etc/nginx/nginx_template.conf > /etc/nginx/nginx.conf
service nginx restart

# If bot_name is not set, use the hostname.
export BOT_NAME="${BOT_NAME:-$(hostname)}"
export RUN_CMD='python3.7 butler.py run_bot --server-storage-path /mnt/nas/clusterfuzz --name $BOT_NAME ./$BOT_NAME'

# PATH, PYTHONPATH and LD_* are removed by sudo even with -E,
# so we pass them explicitly.
# bash -c "PATH='$PATH' PYTHONPATH='$PYTHONPATH' LD_LIBRARY_PATH='$LD_LIBRARY_PATH' $RUN_CMD"

# Run the bot
cd $ROOT_DIR
pipenv run python3.7 butler.py run_bot --server-storage-path /mnt/nas/clusterfuzz --name $BOT_NAME ./$BOT_NAME

