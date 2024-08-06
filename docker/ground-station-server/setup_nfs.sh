#!/bin/bash -ex
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

export NFS_CLUSTER_NAME=192.168.0.2
export NFS_VOLUME_NAME=/volume1/space_security
export NFS_DIR=/mnt/nfs
export NFS_ROOT=$NFS_DIR/$NFS_VOLUME_NAME

mkdir -p /run/sendsigs.omit.d
service rpcbind start

echo "Setting up NFS."
mkdir -p $NFS_DIR
sed -i "s/browse_mode = no/browse_mode = yes/" /etc/autofs.conf
echo "$NFS_DIR   /etc/auto.nfs" >> /etc/auto.master
service autofs stop
# echo "$NFS_VOLUME_NAME -intr,hard,rsize=65536,wsize=65536,mountproto=tcp,vers=3,noacl,noatime,nodiratime $NFS_CLUSTER_NAME:/$NFS_VOLUME_NAME" > /etc/auto.nfs
# echo "$NFS_VOLUME_NAME -intr,hard,rsize=65536,wsize=65536,mountproto=tcp,vers=3,noacl,noatime,nodiratime $NFS_CLUSTER_NAME:/$NFS_VOLUME_NAME" > /etc/auto.nfs
echo "$NFS_VOLUME_NAME -intr,hard,noacl,noatime,nodiratime $NFS_CLUSTER_NAME:/$NFS_VOLUME_NAME" > /etc/auto.nfs
service autofs start