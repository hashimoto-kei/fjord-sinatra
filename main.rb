# frozen_string_literal: true

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
  @memo = Memo.new(*params.values_at('title', 'detail'))
  if @memo.save
    redirect to('/memos')
  else
    @errors = @memo.errors
    status 422
    erb :new
  end
end

get '/memos/:id' do |id|
  @title = 'Show memo'
  @memo = Memo.find(id)
  if @memo.nil?
    status 404
    return erb :not_found
  end
  erb :show
end

get '/memos/:id/edit' do |id|
  @title = 'Edit memo'
  @memo = Memo.find(id)
  if @memo.nil?
    status 404
    return erb :not_found
  end
  erb :edit
end

patch '/memos/:id' do |id|
  @memo = Memo.find(id)
  if @memo.nil?
    status 404
    return erb :not_found
  end
  if @memo.update(*params.values_at('title', 'detail'))
    redirect to('/memos')
  else
    @errors = @memo.errors
    status 422
    erb :edit
  end
end

delete '/memos/:id' do |id|
  memo = Memo.find(id)
  if memo.nil?
    status 404
    return erb :not_found
  end
  memo.destroy
  redirect to('/memos')
end

not_found do
  erb :not_found
end

helpers do
  def h(value)
    Rack::Utils.escape_html(value)
  end
end
