require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"

require_relative 'lib/cookbook'
require_relative 'lib/recipe'
require_relative 'lib/service'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  csv_file = File.join(__dir__, 'lib/recipes.csv')
  cookbook = Cookbook.new(csv_file)
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

post '/recipes' do
  csv_file = File.join(__dir__, 'lib/recipes.csv')
  cookbook = Cookbook.new(csv_file)
  recipe = Recipe.new(name: params[:name], description: params[:description], prep_time: params[:prep_time])
  cookbook.add_recipe(recipe)
  redirect('/')
end

get '/delete' do
  csv_file = File.join(__dir__, 'lib/recipes.csv')
  cookbook = Cookbook.new(csv_file)
  cookbook.remove_recipe(params[:index].to_i)
  redirect('/')
end

get '/import' do
  erb :import
end

get '/recipes_import' do
  @ingredient = params[:ingredient]
  @ingredient_recipes = ScrapeMarmitonService.new.call(params[:ingredient])
  erb :results
end

get '/select' do
  csv_file = File.join(__dir__, 'lib/recipes.csv')
  cookbook = Cookbook.new(csv_file)
  ingredient_recipes = ScrapeMarmitonService.new.call(params[:ingredient])
  recipe = ingredient_recipes[params[:index].to_i]
  cookbook.add_recipe(recipe)
  redirect('/')
end

get '/mark' do
  csv_file = File.join(__dir__, 'lib/recipes.csv')
  cookbook = Cookbook.new(csv_file)
  cookbook.mark_as_done!(params[:index].to_i)
  redirect('/')
end
