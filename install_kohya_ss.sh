#!/bin/bash
set -euo pipefail

cd /workspace

# kohya用の仮想環境有効化
sudo apt update
sudo apt upgrade -y
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update

sudo apt-get -y install python3.10 python3.10-venv python3.10-dev
mkdir -p /opt/environments/python/
python3.10 -m venv /opt/environments/python/kohya/
source /opt/environments/python/kohya/bin/activate

# kohya_ssを本家リポジトリから最新でインストール
git clone --recursive https://github.com/bmaltais/kohya_ss.git /workspace/kohya_ss
cd /workspace/kohya_ss
git fetch --tags && git checkout master
cd /workspace/

# セットアップ
git clone https://github.com/mayu4591/kohya_ss_vastai.git
bash kohya_ss_vastai/script/50xx_init.sh /workspace/kohya_ss

# スクリプトをコピー
cp kohya_ss_vastai/script/exec.sh /workspace/exec.sh
cp kohya_ss_vastai/script/execute_sh.py /workspace/execute_sh.py
cp kohya_ss_vastai/script/add_enque_perm.sh /workspace/add_enque_perm.sh
cp kohya_ss_vastai/script/stop_exec.sh /workspace/stop_exec.sh

# exec.shを実行
./exec.sh
if [ $? -ne 0 ]; then
    echo "Error: exec.sh failed"
    exit 1
fi