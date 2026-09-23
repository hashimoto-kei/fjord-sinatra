# メモアプリ

メモを登録、表示、編集、削除できる Sinatra アプリケーションです。

## 必要なもの

- Ruby 4.0.6
- Bundler 4.0.16
- PostgreSQL 15.17

## セットアップ

```sh
bundle install
```

PostgreSQL を起動してから、リポジトリのルートディレクトリで以下のコマンドを実行します。

```sh
psql -h localhost -U <username> -d postgres -f ./db/init.sql
```

## 起動方法

```sh
bundle exec ruby main.rb
```

起動後、ブラウザで <http://localhost:4567/> を開きます。

## データ保存

メモのデータは PostgreSQL の `fjord_sinatra` データベースにある `memos` テーブルへ保存されます。
