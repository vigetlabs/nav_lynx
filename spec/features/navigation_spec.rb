require 'spec_helper'

describe "Rendering navigation links" do
  it "renders the link correctly" do
    visit '/'

    page.should have_link("My Title", :href => "/projects")
  end
end
