require 'spec_helper'

describe "Static pages" do
  describe "Home page" do
    it "should have the content 'Amazon price poller'" do
      visit '/static_pages/home'
      expect(page).to have_content('Amazon price poller')
    end
  end
  
  describe "Help page" do
    it "should have the content 'help'" do
      visit '/static_pages/help'
      expect(page).to have_content("Help")
    end
  end
end
