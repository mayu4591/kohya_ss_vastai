#!/bin/bash
set -euo pipefail

cd /workspace

# kohya用の仮想環境有効化
sudo apt-get -y install python3.10 python3.10-venv python3.10-dev
mkdir -p /opt/environments/python/
python3.10 -m venv /opt/environments/python/kohya/
source /opt/environments/python/kohya/bin/activate

# kohya_ssを本家リポジトリから最新でインストール
git clone --recursive https://github.com/bmaltais/kohya_ss.git /workspace/kohya_ss
cd /workspace/kohya_ss
git fetch --tags && git checkout main
cd /workspace/

# セットアップ
bash script/50xx_init.sh /workspace/kohya_ss

# スクリプトをコピー
cp script/exec.sh /workspace/exec.sh
cp script/execute_sh.py /workspace/execute_sh.py
cp script/add_enque_perm.sh /workspace/add_enque_perm.sh
cp script/stop_exec.sh /workspace/stop_exec.sh