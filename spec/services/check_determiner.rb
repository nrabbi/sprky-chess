require 'rspec'
require 'rails_helper'

describe 'Check Determiner' do
  describe 'check_determiner#can_check?'
    it 'determines if a piece can check opponent king' do
    end

    it 'does not check its own king' do
    end

  end

  describe 'check_determiner#determine_check_after_move' do
    it 'returns true if the move checks a king' do
    end

  end

  describe 'check_determiner#determine_check_before_move' do
    it 'does not allow move that puts self in check' do
    end
  end

end