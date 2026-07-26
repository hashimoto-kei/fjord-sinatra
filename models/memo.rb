require "csv"

class Memo
  @@file_name = 'data/memos.csv'

  attr_reader :id
  attr_accessor :title, :detail

  def initialize(title, detail, id=nil)
    @id = id
    @title = title
    @detail = detail
  end

  def save
    if @id.nil?
      @id = self.class.generate_id
      create
    else
      update
    end
  end

  def destroy
    table = self.class.load_table
    CSV.open(@@file_name, "w") do |csv|
      csv << table.headers
      table.each do |row|
        csv << row unless row["id"] == @id
      end
    end
  end

  def self.all
    table = self.load_table
    table.map do |row|
      Memo.new(row["title"], row["detail"], row["id"])
    end
  end

  def self.find(id)
    self.all.find { |memo| memo.id == id }
  end

  def self.load_table
    CSV.read(@@file_name, headers: true)
  end

  def self.generate_id
    table = load_table
    return 1 if table.empty?
    max_id = table.map{|row| row["id"].to_i}.max
    max_id + 1
  end

  private

  def to_row
    [@id, @title, @detail]
  end

  def create
    CSV.open(@@file_name, "a") do |csv|
      csv << to_row
    end
  end

  def update
    table = self.class.load_table
    CSV.open(@@file_name, "w") do |csv|
      csv << table.headers
      table.each do |row|
        row = to_row if row["id"] == @id
        csv << row
      end
    end
  end
end
