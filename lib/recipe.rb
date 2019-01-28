class Recipe
  attr_accessor :done, :difficulty, :name, :description, :prep_time, :url
  # def initialize(name, description, prep_time, url = "", difficulty = "", done = false)
  def initialize(attributes = {})
    @name = attributes[:name]
    @description = attributes[:description]
    @prep_time = attributes[:prep_time]
    @url = attributes.fetch(:url, "")
    @difficulty = attributes.fetch(:difficulty, "")
    @done = attributes.fetch(:done, false)
  end
end
