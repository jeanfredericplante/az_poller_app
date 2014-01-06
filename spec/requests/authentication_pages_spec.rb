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
  
  describe "authorization" do
    describe "for non signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      describe "in the users controller" do
        describe "visiting the edit page" do
          before(:each) do
            visit edit_user_path(user)
            it { should have_title("Sign in")}
          end
        end
        describe "submitting the update action" do
          before(:each) do
            patch user_path(user)
            specify { expect (response).to redirect_to (signin_path) }
          end
        end
      end

    end
    describe "as a wrong user" do
      let(:user) { FactoryGirl.create(:user) } 
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") } 
      sign_in(:user, no_capybara: true)
      
      describe "submitting a GET request to the users#edit action" do
        before { get edit_user_path(wrong_user)}
        specify { expect(response.body).to_not have_content(wrong_user.name)}
        specify { expect(response).to redirect_to(root_url)}
      end
      describe "submiting a PATCH request to the users#update action" do
        before { patch user_path(wrong_user)}
        specify { expect(response).to redirect_to(root_url)}
      end
      
    end
    
  end
    
  
  
end
