#!/bin/bash
# 引数からkohya_ssのパスを取得
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path_to_kohya_ss>"
    exit 1
fi
KOHYA_SS_PATH="$1"

# 元のディレクトリを保存
ORIGINAL_DIR=$(pwd)
# 終了時の元のディレクトリに戻る
trap "cd \"$ORIGINAL_DIR\"" EXIT

cd "$KOHYA_SS_PATH"
git pull
git stash
# KOHYA_REFが設定されていない場合はmainブランチを使用
if [ -z "${KOHYA_REF:-}" ]; then
    KOHYA_REF="master"
fi
# KOHYA_REFが設定されている場合はそのブランチ or タグをチェックアウト
if git show-ref --verify --quiet "refs/heads/$KOHYA_REF"; then
    echo "Checking out branch: $KOHYA_REF"
else
    echo "Checking out tag: $KOHYA_REF"
fi
git checkout $KOHYA_REF
git submodule update
pip install -r requirements.txt
cd ..