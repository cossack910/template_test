# ベースイメージとしてPython 3.11のスリム版を使用
FROM python:3.11-slim

# 作業ディレクトリの設定
WORKDIR /app

# システムパッケージのインストール（MySQLクライアントに必要なライブラリも含む）
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libmariadb-dev-compat \
    libmariadb-dev \
    build-essential \
    gcc \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# 必要なPythonパッケージのインストール
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# プロジェクトファイルのコピー
COPY ./src /app

# GunicornでDjangoアプリケーションを起動
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "myproject.wsgi:application"]
