require 'spec_helper'

describe "Authentication" do
  
  subject { page }
  
  
  
  describe "Signin page" do
    before { visit signin_path }
    it { should have_content "Sign in"}
    it { should have_title "Sign in"}
    
    
    
    describe "when the signin fails" do
      before(:each) do
        fill_in "Email", with: "invalid"
        fill_in "Password", with: "invalid"
        click_button "Sign in"
      end
      it { should have_selector("div.alert-error")}  
      
      describe "after visiting another page" do
        before { visit root_path }
        it { should_not have_error_message }  # uses custom matcher in /spec/support/utilities
      end
    end

    
    describe "after the user signs in" do
      let(:user) { FactoryGirl.create(:user) }
      let(:signin) { "Sign in" }
      let(:signout) { "Sign out"}
           
      before { sign_in(user) }
      
      it { should have_title(user.name) }
      it { should have_link("Sign out", href: signout_path) }
      it { should have_link("Profile", href: user_path(user)) }
      it { should have_link("Edit Profile", href: edit_user_path(user))}
      it { should_not have_css "a[href~='/signin']" }
      
      
      describe "if the user signs out" do
        before { click_link signout }
        
        it { should have_link("Sign in", href: signin_path) }
        it { should_not have_link("Sign out", href: signout_path) }
        it { should_not have_link("Profile", href: user_path(user)) }
        it { should_not have_link("Edit Profile", href: edit_user_path(user))}
        
        
      end
      
    end
  end
    
  
  
end
