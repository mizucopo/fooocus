# Fooocus 利用・開発ガイド

Fooocus を Docker 上で気軽に試せるよう、本リポジトリでは利用者向けのクイックスタートと開発者向けのビルド手順をまとめています。

## 目次
- [利用者向けクイックスタート](#利用者向けクイックスタート)
- [開発者向けセットアップ](#開発者向けセットアップ)

## 利用者向けクイックスタート
あらかじめチェックポイントと出力用のディレクトリを作成しておきます。

```sh
mkdir -p checkpoints outputs
```

その後、公式イメージを次のコマンドで起動します。

```sh
docker run --rm --gpus all \
  -p 7865:7865 \
  -v $(pwd)/checkpoints:/app/models/checkpoints \
  -v $(pwd)/outputs:/app/outputs \
  mizucopo/fooocus:develop
```

GPU を使わない場合は `--gpus all` を省略してください。

ブラウザで <http://localhost:7865> にアクセスすると Fooocus を利用できます。

## 開発者向けセットアップ

ここではイメージを自分でビルドして開発する場合の手順を示します。

### 必要条件
- Docker 20 以上
- GPU を利用する場合は NVIDIA ドライバと nvidia-docker2

### イメージの準備
まずベースとなる CUDA イメージを取得します。

```sh
docker pull --platform linux/amd64 nvidia/cuda:12.8.1-devel-ubuntu24.04
```

続いてリポジトリ内の Dockerfile から開発用イメージをビルドします。
Dockerfile 内の `FOOOCUS_VERSION` を変更することで取得する Fooocus のバージョンを指定できます。

```sh
docker build --platform linux/amd64 -t mizucopo/fooocus:develop .
```

### イメージの公開（任意）
ビルドしたイメージをレジストリへ公開したい場合は次のコマンドを実行します。

```sh
docker push mizucopo/fooocus:develop
```

main ブランチにマージすると GitHub Actions により自動で Docker Hub にイメージが作成されます。

### コンテナ起動例
モデルと出力ディレクトリをマウントしてコンテナを起動する例です。

```sh
docker run --rm --gpus all \
  -p 7865:7865 \
  -v $(pwd)/checkpoints:/app/models/checkpoints \
  -v $(pwd)/outputs:/app/outputs \
  -it mizucopo/fooocus:develop /bin/bash
```

コンテナ内で `python launch.py` を実行すると Fooocus が起動します。
GPU を使わない場合は `--gpus all` を省略してください。
開発に合わせて追加のライブラリが必要な場合は Dockerfile を編集してください。
