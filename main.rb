require 'sinatra'
require_relative 'models/memo'

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @title = 'Top'
  @memos = Memo.all
  erb :index
end

get '/memos/new' do
  @title = 'New memo'
  @memo = Memo.new
  erb :new
end

post '/memos' do
  @memo = Memo.new(params['title'], params['detail'])
  if @memo.save
    redirect to('/memos')
  else
    status 422
    erb :new
  end
end

get '/memos/:id' do |id|
  @title = 'Show memo'
  @memo = Memo.find(id)
  erb :show
end

get '/memos/:id/edit' do |id|
  @title = 'Edit memo'
  @memo = Memo.find(id)
  erb :edit
end

put '/memos/:id' do |id|
  @memo = Memo.find(id)
  @memo.title = params['title']
  @memo.detail = params['detail']
  if @memo.save
    redirect to('/memos')
  else
    status 422
    erb :edit
  end
end

delete '/memos/:id' do |id|
  memo = Memo.find(id)
  memo.destroy
  redirect to('/memos')
end
