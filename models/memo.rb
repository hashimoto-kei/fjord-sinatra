class Memo
  @@counts = 0
  @@all = []

  attr_reader :id
  attr_accessor :title, :detail

  def initialize(title, detail)
    @@counts += 1
    @id = @@counts
    @title = title
    @detail = detail
    @@all << self
  end

  def save
    memo = self.class.find(self.id)
    memo.title = self.title
    memo.detail = self.detail
  end

  def destroy
    @@all.delete_if{ it.id == self.id }
  end

  def self.all = @@all
  def self.find(id) = @@all.select{ it.id == id.to_i }[0]
end
