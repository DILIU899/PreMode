#! /bin/bash

# add mamba activation
__conda_setup="$('conda' 'shell.bash' 'hook' 2> /dev/null)"
eval "$__conda_setup"
unset __conda_setup

# mamba install
mamba create -c pytorch -c conda-forge -c bioconda -n PreMode python=3.9 captum=0.6.0 pytorch=2.0.0 ray-default=2.2.0 ray-tune=2.2.0 ray-core=2.2.0 pyro-ppl=1.8.6 pyro-api=0.1.2 python-lmdb=1.4.0 pytorch-lightning=2.1.0 gpytorch=1.11 pytorch_cluster=1.6.1 pytorch_scatter=2.1.1 pytorch_sparse=0.6.17 pytorch_geometric=2.4.0 tensorboard=2.11.0 biotite=0.35.0 biopandas=0.4.1 biopython=1.81 pandas=1.5.2 h5py=3.7.0 loralib=0.1.2 salilab::dssp=3.0.0 anaconda::libboost=1.73.0 ipykernel seaborn -y

# change environment
conda activate PreMode

# pip installation
pip install fair-esm==2.0.0
