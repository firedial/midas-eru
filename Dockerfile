FROM node:lts-alpine

# 静的コンテンツを配信するシンプルな http サーバをインストールする
RUN npm install -g http-server

# カレントワーキングディレクトリとして 'app' フォルダを指定する
WORKDIR /app

# `package.json` と `package-lock.json` （あれば）を両方コピーする
COPY package*.json ./

# プロジェクトの依存ライブラリをインストールする
RUN npm install

ENV HOST "0.0.0.0"
