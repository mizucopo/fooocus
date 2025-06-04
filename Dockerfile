FROM nvidia/cuda:12.8.1-devel-ubuntu24.04

ENV FOOOCUS_VERSION=v2.5.5
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN \
  # システムのアップデートと必要なパッケージのインストール
  apt update \
  && apt install -y \
    git \
    python3 \
    python3-pip \
  && rm -rf /var/lib/apt/lists/*

RUN \
  # Fooocsをクローン
  git clone \
    -b ${FOOOCUS_VERSION} \
    https://github.com/lllyasviel/Fooocus.git /app

# 作業ディレクトリの作成
WORKDIR /app

RUN \
  # 依存ライブラリをインストール
  pip3 install \
    --no-cache-dir \
    --break-system-packages \
    -r requirements_versions.txt \
  # xformersをインストール
  && pip3 install \
    --no-cache-dir \
    --break-system-packages \
      xformers

# ポート公開
EXPOSE 7865

# 実行権限の設定
RUN chmod +x launch.py

# 起動コマンド
CMD ["python3", "launch.py", "--listen", "0.0.0.0", "--port", "7865"]
