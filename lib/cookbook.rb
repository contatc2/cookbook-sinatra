require 'csv'
require_relative 'recipe'

class Cookbook
  attr_reader :recipes
  def initialize(csv_file_path)
    @recipes = []
    @csv = csv_file_path
    CSV.foreach(@csv) do |row|
      @recipes << Recipe.new(name: row[0], description: row[1], prep_time: row[2], url: row[3],
                             difficulty: row[4], done: row[5])
    end
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    CSV.open(@csv, 'a') do |csv|
      csv << [recipe.name, recipe.description, recipe.prep_time, recipe.url, recipe.difficulty, recipe.done]
    end
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    CSV.open(@csv, 'wb') do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.prep_time, recipe.url, recipe.difficulty, recipe.done]
      end
    end
  end

  def mark_as_done!(recipe_index)
    @recipes[recipe_index].done = true
    CSV.open(@csv, 'wb') do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.prep_time, recipe.url, recipe.difficulty, recipe.done]
      end
    end
  end
end
