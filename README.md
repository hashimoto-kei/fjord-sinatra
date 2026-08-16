# メモアプリ

メモを登録、表示、編集、削除できる Sinatra アプリケーションです。

## 必要なもの

- Ruby 4.0.6
- Bundler 4.0.16

## セットアップ

```sh
bundle install
```

## 起動方法

```sh
bundle exec ruby main.rb
```

起動後、ブラウザで <http://localhost:4567/> を開きます。

## データ保存

メモのデータは `data/memos.csv` に保存します。
