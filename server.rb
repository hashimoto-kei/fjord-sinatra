require 'sinatra'

memos = []
id = 0

def generate_html(title, body)
  <<~HTML
    <!DOCTYPE html>
    <html lang="ja">
    <head>
      <meta charset="utf-8">
      <link rel="stylesheet" href="http://localhost:4567/css/style.css" >
      <title>#{title}</title>
    </head>
    #{body}
    </html>
  HTML
end

get '/' do
  items = memos.map { |memo| "<li><a href=\"http://localhost:4567/memos/#{memo[:id]}\">#{memo['title']}</a></li>" }.join
  body = <<~HTML
    <body>
      <div class="l--container">
      <h1>メモアプリ</h1>
      <a href="http://localhost:4567/memos/new" class="l--button">追加</a>
      <ul>
        #{items}
      </ul>
      </div>
    </body>
  HTML
  generate_html('Top', body)
end

get '/memos/new' do
  body = <<~HTML
    <body>
      <h1>メモアプリ</h1>
      <div class="l--table">
        <form action="/memos" method="post">
          <div class="l--table-row">
            <input type="text" name="title" id="title"/>
          </div>
          <div class="l--table-row">
            <textarea name="details" id="details"></textarea>
          </div>
          <div class="l--table-row">
            <input type="submit" value="保存" class="l--button"/>
          </div>
        </form>
      </div>
    </body>
  HTML
  generate_html('New memo', body)
end

post '/memos' do
  id = id + 1
  memos << { id: id.to_s, **request.params }
  redirect to('/')
end

get '/memos/:id' do
  memo = memos.select { |memo| memo[:id] == params['id'] }.first
  body = <<~HTML
    <body>
      <h1>メモアプリ</h1>
      <div class="l--table">
        <div class="l--table-row">
          <input type="text" name="title" id="title" value="#{memo['title']}" disabled />
        </div>
        <div class="l--table-row">
          <textarea name="details" id="details" disabled>#{memo['details']}</textarea>
        </div>
      </div>
      <div class="l--table-row l--button-container">
        <a href="http://localhost:4567/memos/#{memo[:id]}/edit" class="l--button">変更</a>
        <form action="/memos/#{memo[:id]}" method="post">
          <input type="hidden" name="_method" id="_method" value="DELETE"/>
          <input type="submit" value="削除" class="l--button" />
        </form>
      </div>
    </body>
  HTML
  generate_html('Show memo', body)
end

get '/memos/:id/edit' do
  memo = memos.select { |memo| memo[:id] == params['id'] }.first
  body = <<~HTML
    <body>
      <h1>メモアプリ</h1>
      <div class="l--table">
        <form action="/memos/#{memo[:id]}" method="post">
          <div class="l--table-row">
            <input type="hidden" name="_method" id="_method" value="PUT"/>
          </div>
          <div class="l--table-row">
            <input type="text" name="title" id="title" value="#{memo['title']}" />
          </div>
          <div class="l--table-row">
            <textarea name="details" id="details">#{memo['details']}</textarea>
          </div>
          <div class="l--table-row">
            <input type="submit" value="変更" class="l--button"/>
          </div>
        </form>
      </div>
    </body>
  HTML
  generate_html('Edit memo', body)
end

put '/memos/:id' do
  memos.delete_if { |memo| memo[:id] == params['id'] }
  memos << { id: params['id'], **request.params }
  memos.sort_by! { |memo| memo[:id].to_i }
  redirect to('/')
end

delete '/memos/:id' do
  memos.delete_if { |memo| memo[:id] == params['id'] }
  redirect to('/')
end
