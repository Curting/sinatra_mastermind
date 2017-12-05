require 'sinatra'
require 'sinatra/reloader' if development?

require_relative 'lib/mastermind'

# enable :sessions

game = Codebreaker.new

get '/' do

  if game.game_over?
    game.reset
  else
    unless params["color1"].nil? || params["color2"].nil? || params["color3"].nil? ||
           params["color4"].nil?

      game.guess << [params["color1"].to_i, params["color2"].to_i, params["color3"].to_i,
                params["color4"].to_i]

      game.guess_and_evaluate(game.guess.last)

    end

    if game.game_over?
      message = "You won! 😄" if game.won?
      message = "You lost! 💩" if game.lost?
    end
  end

  erb :index, :locals => { :guess => game.guess, :feedback => game.feedback, :code => game.code, :guess_count => game.guess_count,
                           :message => message, :game_over => game.game_over?, :won => game.won?, :lost => game.lost? }

end

