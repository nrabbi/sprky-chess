require 'rails_helper'

RSpec.describe "errors/not_found.html.erb", type: :view do
  
  it "renders the error page" do
    visit '/404'
    assert_template('errors/not_found')
  end
end
