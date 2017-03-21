require 'rails_helper'

RSpec.describe "errors/internal_server_error.html.erb", type: :view do
  it "renders the error page" do
    visit '/500'
    assert_template('errors/internal_server_error')
  end
end
