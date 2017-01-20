class MovesController < ApplicationController

  def new
    #TODO -- makes a new move
    # these new/create actions support entering move coordinates through forms
    # might not use this if we do it through js...?
  end

  def create
    #TODO -- save a new move
  end

  # the logic which moves the pieces is contined in the /service files
  # in this controller, we will make a place to call those actions
  # e.g. through a 'call' action

end

