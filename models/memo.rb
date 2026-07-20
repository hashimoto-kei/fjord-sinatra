require 'pg'

class Memo
  @@conn = PG.connect( dbname: 'fjord_sinatra' )

  attr_reader :id
  attr_accessor :title, :detail

  def initialize(title, detail, id=nil)
    @id = id
    @title = title
    @detail = detail
  end

  def save
    params = []
    params << {:value => self.title}
    params << {:value => self.detail}
    if self.id.nil?
      @@conn.exec_params( "INSERT INTO memos (title, detail) VALUES ($1, $2)", params )
    else
      params << {:value => self.id} unless self.id.nil?
      @@conn.exec_params( "UPDATE memos SET title=$1, detail=$2 WHERE id=$3", params )
    end
  end

  def destroy
    params = []
    params << {:value => self.id}
    @@conn.exec_params( "DELETE FROM memos WHERE id=$1", params )
  end

  def self.all
    all = []
    @@conn.exec( "SELECT * FROM memos" ) do |result|
      result.each do |row|
        id, title, detail = row.values_at('id', 'title', 'detail')
        all << Memo.new(title, detail, id)
      end
    end
    all
  end

  def self.find(id)
    params = []
    params << {:value => id}
    @@conn.exec_params( "SELECT * FROM memos WHERE id=$1", params ) do |result|
      result.each do |row|
        id, title, detail = row.values_at('id', 'title', 'detail')
        return Memo.new(title, detail, id)
      end
    end
  end
end
