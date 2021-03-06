require('sinatra')
require('sinatra/reloader')
require('./lib/definition')
require('./lib/word')
require('pry')
also_reload('lib/**/*.rb')


get('/') do
  erb(:index)
end

post('/') do
  @new_word = Word.new({:word => params.fetch('new_word')})
  @new_word.save
  erb(:word_success)
end

get('/clear_words') do
  Word.clear
  erb(:index)
end

get('/word_info/:id') do
  @word = Word.find(params.fetch('id').to_i)
  erb(:word_info)
end

post('/word_info') do
  @word = Word.find(params.fetch('word_id').to_i)
  @new_definition = Definition.new({:definition => params.fetch('new_definition'), :type => params.fetch('word_type')})
  @new_definition.save
  @word.add_definition(@new_definition)
  erb(:word_info)
end


# post('/clear_definitions') do
#    @word = Word.find(params.fetch('word_id').to_i)
#    (@word.definitions).each() do |definition|
#     @word = Word.find(params.fetch('clear').to_i)
#     (@word.definitions).each() do |definition|
#       definition.save
#     end
#     Definition.clear
#
#
#   # end
#   erb(:word_info)
# end

post ('/clear_definitions') do
  id = params.fetch('clear')
  @word = Word.find(id.to_i())
  @word.clear_definitions()

  #@word = Word.find(params.fetch('clear').to_i)
  #(@word.definitions).each() do |definition|
  #  definition.delete
  #  end
  #Definition.clear
  redirect('/word_info/' + @word.id().to_s())
end
