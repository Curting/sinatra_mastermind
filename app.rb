require 'sinatra'
require 'sinatra/reloader' if development?

require_relative 'lib/mastermind'

enable :sessions



get '/' do

  session[:game] ||= Codebreaker.new

  if session[:game].game_over?
    session[:game].reset
  else
    unless params["color1"].nil? || params["color2"].nil? || params["color3"].nil? ||
           params["color4"].nil?

      session[:game].guess << [params["color1"].to_i, params["color2"].to_i, params["color3"].to_i,
                params["color4"].to_i]

      session[:game].guess_and_evaluate(session[:game].guess.last)

    end

    if session[:game].game_over?
      message = "You won! 😄" if session[:game].won?
      message = "You lost! 💩" if session[:game].lost?
    end
  end

  erb :index, :locals => { :guess => session[:game].guess, :feedback => session[:game].feedback, :code => session[:game].code, :guess_count => session[:game].guess_count,
                           :message => message, :game_over => session[:game].game_over?, :won => session[:game].won?, :lost => session[:game].lost? }

end

