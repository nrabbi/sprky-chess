class MovesController < ApplicationController
  attr_accessor :to
  attr_reader :from

  def initialize
    @from = [x, y]
    @to = []
  end

  def new
    #TODO
    # new/create support entering move coordinates through forms
    # might not use this if we do it through js...?
  end

  def create
    #TOTO
  end

end
