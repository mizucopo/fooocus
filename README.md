# Fooocus 開発者向けガイド

このリポジトリは Fooocus を Docker コンテナで実行するための設定を提供します。
開発者がローカル環境を準備する際の基本的な手順を以下にまとめます。

## 必要条件
- Docker 20 以上
- GPU を利用する場合は NVIDIA ドライバと nvidia-docker2

## イメージの準備
まずベースとなる CUDA イメージを取得します。

```sh
docker pull --platform linux/amd64 nvidia/cuda:12.8.1-devel-ubuntu24.04
```

続いてリポジトリ内の Dockerfile から開発用イメージをビルドします。

```sh
docker build --platform linux/amd64 -t mizucopo/fooocus:develop .
```

## イメージの公開（任意）
ビルドしたイメージをレジストリへ公開したい場合は次のコマンドを実行します。

```sh
docker push mizucopo/fooocus:develop
```

## コンテナ起動例
モデルと出力ディレクトリをマウントしてコンテナを起動する例です。

```sh
docker run --rm --gpus all \
  -p 7865:7865 \
  -v $(pwd)/checkpoints:/app/models/checkpoints \
  -v $(pwd)/outputs:/app/outputs \
  -it mizucopo/fooocus:develop /bin/bash
```

コンテナ内で `python launch.py` を実行すると Fooocus が起動します。
開発に合わせて追加のライブラリが必要な場合は Dockerfile を編集してください。
