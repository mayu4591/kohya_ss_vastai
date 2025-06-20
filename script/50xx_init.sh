#!/bin/bash
# 元のディレクトリを保存
ORIGINAL_DIR=$(pwd)
# ファイルのディレクトリを取得
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
# スクリプトのディレクトリに移動
cd "$SCRIPT_DIR"
# 終了時の元のディレクトリに戻る
trap "cd \"$ORIGINAL_DIR\"" EXIT

# 引数からkohya_ssのパスを取得
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path_to_kohya_ss>"
    exit 1
fi
KOHYA_SS_PATH="$1"

source /opt/environments/python/kohya/bin/acrivate
chmod +x ./verup_kohya_ss.sh
chmod +x ./exec.sh
chmod +x ./verup_pytorch_2_8.sh
chmod +x ./add_enque_perm.sh

./verup_kohya_ss.sh "$KOHYA_SS_PATH"
if [ $? -ne 0 ]; then
    echo "Error: init.sh failed"
    exit 1
fi
echo "init.sh completed successfully"

./verup_pytorch_2_8.sh
if [ $? -ne 0 ]; then
    echo "Error: verup_pytorch_2_8.sh failed"
    exit 1
fi
echo "verup_pytorch_2_8.sh completed successfully"

./exec.sh
if [ $? -ne 0 ]; then
    echo "Error: exec.sh failed"
    exit 1
fi