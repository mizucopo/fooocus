FROM nvidia/cuda:12.8.1-devel-ubuntu24.04

ENV CUDA_VERSION=cu128
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
    wget \
    libgl1-mesa-dri \
    libgl1-mesa-dev \
    libglib2.0-0 \
    libglib2.0-dev \
  && rm -rf /var/lib/apt/lists/*

RUN \
  # Fooocsをクローン
  git clone \
    -b ${FOOOCUS_VERSION} \
    https://github.com/lllyasviel/Fooocus.git /app

# 作業ディレクトリの作成
WORKDIR /app

RUN \
  # 最初にPyTorchをCUDA対応版でインストール（バージョン競合を避けるため）
  pip3 install \
    --no-cache-dir \
    --break-system-packages \
    --index-url https://download.pytorch.org/whl/${CUDA_VERSION} \
      torch \
      torchvision \
      torchaudio \
  # その後、他の依存関係をインストール（PyTorchの再インストールを避ける）
  && pip3 install \
    --no-cache-dir \
    --break-system-packages \
    --no-deps \
    --ignore-installed \
    -r requirements_versions.txt \
  # xformersを最後にインストール（PyTorch依存のため）
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
