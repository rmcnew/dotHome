#!/bin/env bash
cd $HOME
mkdir -p work/schroot/{build,logs,scratch}
echo "/home/${USER}/work/schroot/scratch /scratch none rw,bind 0 0" | sudo tee -a /etc/schroot/sbuild/fstab > /dev/null
