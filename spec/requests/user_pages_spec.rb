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
    let(:user_email) { "jd@example.com" }
    
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
        fill_in "Email", with: user_email
        fill_in "Password", with: "12341234"
        fill_in "Confirmation", with: "12341234"
      end
      it "should create a new user" do
        expect {click_button submit}.to change(User, :count).by(1)
      end 
      describe "should have a flash saying the creation is successful" do
        let(:user) { User.find_by(email: user_email)}
        before { click_button submit }
        it { should have_content(user.email) }
        it { should have_content(user.name) }
        
        it { should have_selector("div.alert-success") }     
      end

    end
    
    describe "when signed in" do
      let(:user) { FactoryGirl.create(:user) }
      
      before(:each) do
        visit signin_path
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end
      
      describe "and going to the signup page" do
        before { visit signup_path }
        it "should redirect to the user's path" do
          expect(current_path).to eq user_path(user)
        end
        it { should have_content(user.name) }
      end
    end
  
  end
  
end
