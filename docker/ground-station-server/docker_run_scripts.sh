# In host machine, run the following commands:
# Run server docker
docker run -it --name gs-clusterfuzz-server -p 9000:9000 -p 9004:9004 -p 9008:9008 -v nfs_volume:/mnt/nas gs-clusterfuzz:1.0.0 /bin/bash

# Run client docker
docker run -it --name gs-clusterfuzz-client -v nfs_volume:/mnt/nas gs-clusterfuzz:1.0.0 /bin/bash


# In docker container, run the following commands:
# Run server (gs-clusterfuzz-server)
pipenv shell
# Initialize database
python3.7 butler.py run_server --storage-path=/mnt/nas/clusterfuzz/ --bootstrap
# Run server
python3.7 butler.py run_server --storage-path=/mnt/nas/clusterfuzz/ --skip-install-deps

# Run bot (gs-clusterfuzz-client)
pipenv shell
# Run bot
python3.7 butler.py run_bot --server-storage-path /mnt/nas/clusterfuzz --name my_bot ./my_bot
