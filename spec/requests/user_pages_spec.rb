require 'spec_helper'

describe "User Pages" do
  

  
  describe "Creating a user" do
    before(:each) { visit signup_path }
    subject { page }
    
    it { should have_content("Sign up") }
    it { should have_title ("Signup") }
  end
end
