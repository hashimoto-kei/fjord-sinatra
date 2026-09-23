# frozen_string_literal: true

require 'pg'

class Memo
  CONN = PG.connect(dbname: 'fjord_sinatra')
  CONN.field_name_type = :symbol

  attr_reader :id, :title, :detail, :errors

  def initialize(title = nil, detail = nil, id = nil)
    @id = id
    @title = title
    @detail = detail
    @errors = []
  end

  def save
    return false if invalid?

    CONN.exec_params('INSERT INTO memos (title, detail) VALUES ($1, $2);', [title, detail])
    true
  end

  def update(title, detail)
    @title = title
    @detail = detail
    return false if invalid?

    CONN.exec_params('UPDATE memos SET title = $1, detail = $2 WHERE id = $3;', [title, detail, id])
    true
  end

  def destroy
    CONN.exec_params('DELETE FROM memos WHERE id = $1;', [id])
  end

  def self.all
    CONN.exec('SELECT * FROM memos ORDER BY id;') do |result|
      result.map do |row|
        Memo.new(*row.values_at(:title, :detail, :id))
      end
    end
  end

  def self.find(id)
    CONN.exec_params('SELECT * FROM memos WHERE id = $1;', [id]) do |result|
      row = result.each.first
      return nil if row.nil?

      return Memo.new(*row.values_at(:title, :detail, :id))
    end
  end

  private

  def invalid?
    if @title.empty?
      @errors << 'タイトルは必須です'
      return true
    end
    false
  end
end
