require 'spec_helper'

describe "Static pages" do
  
  let(:base_title)  {"APP"}
  
  describe "Home page" do
    it "should have the content 'Amazon price poller'" do
      visit '/static_pages/home'
      expect(page).to have_content('Amazon price poller')
    end
    it "should have the title 'APP | Home'" do
      visit '/static_pages/home'
      expect(page).to have_title("#{base_title} | Home")
    end
  end
  
  describe "Help page" do
    it "should have the content 'help'" do
      visit '/static_pages/help'
      expect(page).to have_content("Help")
    end
    it "should have the title 'APP | Help'" do
      visit '/static_pages/help'
      expect(page).to have_title("#{base_title} | Help")
    end
  end
end
