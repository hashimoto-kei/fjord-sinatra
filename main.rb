require 'sinatra'
require_relative 'models/memo'

get '/' do
  erb :index, :locals => {title: 'Top', memos: Memo.all}
end

get '/memos/new' do
  erb :new, :locals => {title: 'New memo'}
end

post '/memos' do
  Memo.new(params['title'], params['detail'])
  redirect to('/')
end

get '/memos/:id' do |id|
  erb :show, :locals => {title: 'Show memo', memo: Memo.find(id)}
end

get '/memos/:id/edit' do |id|
  erb :edit, :locals => {title: 'Edit memo', memo: Memo.find(id)}
end

put '/memos/:id' do |id|
  memo = Memo.find(id)
  memo.title = params['title']
  memo.detail = params['detail']
  memo.save
  redirect to('/')
end

delete '/memos/:id' do |id|
  memo = Memo.find(id)
  memo.destroy
  redirect to('/')
end
