import time
import subprocess
import portalocker
import os

def read_first_line(file_path):
    command = None

    with open(file_path, 'r') as file:
        portalocker.lock(file, portalocker.LOCK_EX)
        lines = file.readlines()
        portalocker.unlock(file)
        if lines:
            command = lines[0].strip()  # 最初の行を取得

    if len(lines) > 0:
        lines.pop(0)  # 最初の行を削除

        # 残りの行をファイルに書き戻す
        with open(file_path, 'w') as file:
            portalocker.lock(file, portalocker.LOCK_EX)
            for line in lines:
                file.write(line + '\n')
            portalocker.unlock(file)

    return command

def append_line(file_path, line):
    with open(file_path, 'a') as file:
        portalocker.lock(file, portalocker.LOCK_EX)
        file.write(line + '\n')
        portalocker.unlock(file)

def execute_command(command):
    _, ext = os.path.splitext(command)
    if ext.lower() == '.sh':
        # .shファイルの場合
        result = subprocess.call(['/bin/bash', command])
    else:
        # .shファイル以外の場合、コマンドをそのまま実行
        result = subprocess.call(command.split())
    return result

def main():
    file_path = '/tmp/q.txt'
    try:
        while True:
            command = read_first_line(file_path)
            if command:
                result = execute_command(command)
                if result != 0:
                    # errorメッセージを表示
                    print(f'Failed to execute command: {command}')
                    append_line(file_path, command.strip())
            else:
                time.sleep(1)  # q.txtが空の場合は1秒待つ
    except KeyboardInterrupt:
        print("プログラムが終了しました。")

if __name__ == "__main__":
    main()