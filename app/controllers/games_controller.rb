require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = []
    10.times { @letters << ("A".."Z").to_a.sample }
  end

  def included_word
    @answer.upcase.chars.all? { |letter| @answer.count(letter) <= @grid.count(letter)}
  end

  def score
    @grid = params[:grid]
    @answer = params[:word]
    if !included_word
      @result = "Sorry, but #{@answer.upcase} can’t be built out of #{@grid}."
    elsif included_word && !english_word
      @result = "Sorry but #{@answer.upcase} does not seem to be an English word."
    else
      @result = "Congratulation! #{@answer.upcase} is a valid English word."
    end
  end

  def english_word
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{@answer}")
    word = JSON.parse(response.read)
    word['found']
  end
end
