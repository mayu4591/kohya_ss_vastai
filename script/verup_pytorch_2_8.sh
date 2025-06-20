#!/bin/bash
pip uninstall -y torch torchvision torchaudio xformers
pip install -U --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu128

# ファイルのディレクトリを取得
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# xformersのインストール
pip install $SCRIPT_DIR/package/xformers-0.0.31+eb3ea378.d20250619-cp39-abi3-linux_x86_64.whl

# pythonのバージョンを確認
echo "=========================results========================="
mkdir -p /workspace/kohya_ss_vastai/logs
python -c "import torch; print(torch.__version__); print(torch.cuda.is_available()); print(torch.cuda.get_arch_list())" >> /workspace/kohya_ss_vastai/logs/pytorch_version.log