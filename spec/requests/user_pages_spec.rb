require 'spec_helper'

describe "User Pages" do
  subject { page }  
  
  describe "Creating a user" do
    before(:each) { visit signup_path }
    it { should have_content("Sign up") }
    it { should have_title ("Signup") }
  end
  
  describe "Showing the user details page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    it { should have_content(user.name) }
    it { should have_content(user.email) }    
    it { should have_title(user.name) }  
  end
  
  describe "Signup page" do
    before { visit signup_path }
    let(:submit) { "Create new account"}
    
    describe "with no information" do
      it "should not let you create a user" do
        expect {click_button submit}.to_not change(User, :count)
      end
      describe "it should display an error" do
        before { click_button submit }
        it { should have_content("error") }
        
      end
    end
    
    describe "with valid information" do
      before(:each) do
        fill_in "Name", with: "John Doe"
        fill_in "Email", with: "jd@example.com"
        fill_in "Password", with: "12341234"
        fill_in "Confirmation", with: "12341234"
      end
      it "should create a new user" do
        expect {click_button submit}.to change(User, :count).by(1)
      end 
      describe "should have a flash saying the creation is successful" do
        before { click_button submit }
         it { should have_selector("div.alert-success") }     
      end

    end
  
  end
  
end
