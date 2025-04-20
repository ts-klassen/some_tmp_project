# EC サイト用 Postgres コンテナ（スキーマ & サンプルデータ入り）

FROM postgres:15

# 環境変数（docker-compose でも上書き可）
ENV POSTGRES_USER=postgres \
    POSTGRES_PASSWORD=postgres \
    POSTGRES_DB=ecdb

# 初期化 SQL を配置
COPY init.sql /docker-entrypoint-initdb.d/

# ロケールやタイムゾーンの変更が必要な場合は以下を有効化
# RUN localedef -i ja_JP -f UTF-8 ja_JP.UTF-8 && \
#     update-locale LANG=ja_JP.UTF-8

# Expose default Postgres port
EXPOSE 5432
