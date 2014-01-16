require 'spec_helper'

describe "Static pages" do
  
  let(:base_title)  {"AZP"}
  
  describe "Home page" do
    before(:each) { visit root_path }
    subject { page }
   
    it { should have_content('Amazon price poller') }
    it { should have_title("#{base_title}") }
    it { should_not have_title("Home") }
    it { should_not have_title("|") }
    it { should have_link("Start tracking", href: signup_path)}
    
  end
  
  describe "Help page" do
    before(:each) { visit help_path }
    subject { page }
    
    it { should have_content("Help") }
    it { should have_title("#{base_title} | Help") }   
  end
  
end
