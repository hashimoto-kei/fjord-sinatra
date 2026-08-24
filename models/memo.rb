# frozen_string_literal: true

require 'csv'

class Memo
  FILE_NAME = 'data/memos.csv'

  attr_reader :id, :errors
  attr_accessor :title, :detail

  def initialize(title = nil, detail = nil, id = nil)
    @id = id
    @title = title
    @detail = detail
    @errors = []
  end

  def save
    return false if invalid?

    @id = self.class.generate_id
    CSV.open(FILE_NAME, 'a') do |csv|
      csv << to_row
    end
    true
  end

  def update(title, detail)
    @title = title
    @detail = detail
    return false if invalid?

    table = self.class.load_table
    CSV.open(FILE_NAME, 'w') do |csv|
      csv << table.headers
      table.each do |row|
        row = to_row if row['id'] == @id
        csv << row
      end
    end
    true
  end

  def destroy
    table = self.class.load_table
    CSV.open(FILE_NAME, 'w') do |csv|
      csv << table.headers
      table.each do |row|
        csv << row unless row['id'] == @id
      end
    end
  end

  def self.all
    table = load_table
    table.map do |row|
      Memo.new(*row.values_at('title', 'detail', 'id'))
    end
  end

  def self.find(id)
    all.find { |memo| memo.id == id }
  end

  def self.load_table
    CSV.read(FILE_NAME, headers: true)
  end

  def self.generate_id
    table = load_table
    return 1 if table.empty?

    max_id = table.map { |row| row['id'].to_i }.max
    max_id + 1
  end

  private

  def to_row
    [@id, @title, @detail]
  end

  def invalid?
    if @title.empty?
      @errors << 'タイトルは必須です'
      return true
    end
    false
  end
end
