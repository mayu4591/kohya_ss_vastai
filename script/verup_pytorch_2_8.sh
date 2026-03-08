#!/bin/bash
pip uninstall -y torch torchvision torchaudio xformers
# 2.12.0に変更
pip install -U --pre torch==2.12.0.dev20260308 torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu128

# ファイルのディレクトリを取得
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# xformersのインストール(環境によって変わるので都度ビルド)
## CUDA 12.8がない場合、インストールする
if [ ! -d "/usr/local/cuda-12.8" ]; then
    echo "CUDA 12.8 is not installed. Installing CUDA 12.8..."
    rm -f /etc/apt/sources.list.d/cuda.list
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
    dpkg -i cuda-keyring_1.1-1_all.deb
    apt-get update
    apt-get -y install cuda-toolkit-12-8
    echo "CUDA 12.8 has been installed."
fi

sudo apt update
sudo apt install python3-dev build-essential cmake
if [ ! -d "./xformers" ]; then
    git clone https://github.com/facebookresearch/xformers.git
fi
cd xformers
git fetch --tags && git checkout main
git submodule update --init --recursive
# 5090で使用できない問題解消のための暫定patch https://github.com/facebookresearch/xformers/issues/1374?utm_source=chatgpt.com
sed -i 's/CUDA_MAXIMUM_COMPUTE_CAPABILITY = (9, 0)/CUDA_MAXIMUM_COMPUTE_CAPABILITY = (12, 1)/g' xformers/ops/fmha/cutlass.py

export CUDA_HOME="/usr/local/cuda-12.8"
export PATH="$CUDA_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$CUDA_HOME/lib64:$LD_LIBRARY_PATH"
export TORCH_CUDA_ARCH_LIST="12.0"

pip install -U pip setuptools wheel ninja packaging numpy
pip install --no-build-isolation -v .
cd ..

# バージョン不一致が発生するのでnumpyとscipyを再インストール
pip uninstall -y numpy scipy
pip install numpy==1.26.4 scipy==1.11.4

# pythonのバージョンを確認
echo "=========================results========================="
mkdir -p /workspace/kohya_ss_vastai/logs
python -c "import torch; print(torch.__version__); print(torch.cuda.is_available()); print(torch.cuda.get_arch_list())" >> /workspace/kohya_ss_vastai/logs/pytorch_version.log
