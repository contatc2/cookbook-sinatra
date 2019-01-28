require_relative 'recipe'
require 'nokogiri'
require 'open-uri'

class ScrapeMarmitonService
  def call(ingredient)
    url = "https://www.marmiton.org/recettes/recherche.aspx?aqt=" + ingredient
    doc = Nokogiri::HTML(open(url), nil, 'utf-8')
    scrape_recipe_details(doc)
  end

  def call_with_difficulty(ingredient, difficulty_level)
    if difficulty_level.zero? then call(ingredient)
    else
      url = "https://www.marmiton.org/recettes/recherche.aspx?aqt=#{ingredient}&dif=#{difficulty_level}"
      doc = Nokogiri::HTML(open(url), nil, 'utf-8')
      scrape_recipe_details(doc)
    end
  end

  def scrape_difficulty(recipe)
    url = 'https://www.marmiton.org' + recipe.url
    doc = Nokogiri::HTML(open(url), nil, 'utf-8')
    doc.search(".recipe-infos__level .recipe-infos__item-title").text
  end

  def scrape_recipe_details(doc)
    doc.search(".recipe-card").take(5).map do |element|
      recipe = Recipe.new
      recipe.name = element.search(".recipe-card__title").text.strip
      recipe.description = element.search(".recipe-card__description").text.strip
      recipe.prep_time = element.search(".recipe-card__duration__value").text.strip
      recipe.url = element.search(".recipe-card-link").attribute("href").value
      recipe.difficulty = scrape_difficulty(recipe)
      recipe
    end
  end
end
