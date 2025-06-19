#!/bin/bash
set -euo pipefail

cd /workspace

# 仮想環境有効化（ベースイメージ依存）
source /venv/main/bin/activate

# kohya_ssを本家リポジトリから最新でインストール
git clone --recursive https://github.com/bmaltais/kohya_ss.git /workspace/kohya_ss
cd /workspace/kohya_ss
git fetch --tags && git checkout main
./setup.sh -v -u

# 動作確認
kohya_ss --help