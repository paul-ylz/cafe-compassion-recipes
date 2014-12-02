%w[ sinatra/base ostruct time yaml ].each { |lib| require lib }
require 'github_hook'

class App < Sinatra::Base
  use GithubHook

  set :root, File.expand_path('../../', __FILE__)
  set :recipes, []

  Dir.glob "#{root}/recipes/*.mdown" do |file|
    meta, content   = File.read(file).split("\n\n", 2)
    recipe          = OpenStruct.new YAML.load(meta)
    recipe.date     = Time.parse recipe.date.to_s
    recipe.content = content
    recipe.slug    = File.basename file, '.mdown'

    get "/#{recipe.slug}" do
      erb :recipe, locals: { recipe: recipe }
    end

    recipes << recipe
  end

  recipes.sort_by { |recipe| recipe.title }

  get '/' do
    erb :index
  end
end

