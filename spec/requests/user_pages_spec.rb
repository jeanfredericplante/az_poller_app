require 'spec_helper'

describe "User Pages" do
  subject { page }  
  
  describe "Creating a user" do
    before(:each) { visit signup_path }
    it { should have_content("Sign up") }
    it { should have_title ("Signup") }
    
    describe "if signed in as another user" do
      describe "after creating a new user" do
        it "should redirect to the new user's profile" 
      end
      
    end
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
      
      before { sign_in(user) }
      
      
      describe "and going to the signup page" do
        before { visit signup_path }
        it "should redirect to the user's path" do
          expect(current_path).to eq user_path(user)
        end
        it { should have_content(user.name) }
      end
    end
  
  end
  
  describe "Editing" do
    let(:user) { FactoryGirl.create(:user)}
    let(:user_email) { "jd@example.com" }
    let(:user_name) { "jd" }
    
    
    
    before(:each) { 
      sign_in(user)
      visit edit_user_path(user)    
    }
    
    describe "page" do
      # before(:each) do  # debugging with screenshots
      #   save_and_open_page
      # end
      it { should have_selector("input", user.name) }
      it { should have_link('change', href: 'http://gravatar.com/emails')}
      it { should have_content('Edit user') }
    end

    describe "with invalid info" do
      before { click_button "Save changes" }
      it { should have_error_message }
    end
    
    describe "with valid info" do
      before(:each) do
        fill_in "Name", with: user_name
        fill_in "Email", with: user_email
        fill_in "Password", with: user.password
        fill_in "Confirmation", with: user.password_confirmation
        click_button "Save changes"
      end
      
      it "should redirect to the user's path" do
        expect(current_path).to eq user_path(user)
      end
      it { should have_content(user_email) }
      it { should have_content(user_name) }
      specify { expect( user.reload.name).to eq user_name } # this reloads from the db directly¡£
      specify { expect( user.reload.email).to eq user_email }
      
      
    end
  end
  
  describe "Index" do
    before(:each) do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Joe", email: "joe@example.com")
      FactoryGirl.create(:user, name: "Jack", email: "jack@example.com")
      visit users_path
    end
    
    it { should have_content("All users") }
    it { should have_title("All users") }
    
    it "should list all users" do
      User.all.each do |user|
        expect(page).to have_selector('li', user.name)
      end
    end
    
    describe "Pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user)}}
      after(:all) { User.delete_all}
      
      it { should have_selector('div.pagination')}
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', user.name)
          
        end
        
      end
    end
    
    describe "Delete links" do
      it { should_not have_link('delete')} 
      describe "as an admin" do
        let(:admin) { FactoryGirl.create(:admin)}
        before do 
          sign_in admin
          visit users_path
        end
        it { should have_link('delete', href: user_path(User.first)) }
        it { should_not have_link('delete', href: user_path(admin)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
         
        
      end
      
    end
    
  end
  
  describe "Profile page" do
    let(:user) { FactoryGirl.create(:user)}
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "blabloil") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "calmoil") }
    
    before(:each) do
      sign_in(user)
      visit user_path(user)
      # save_and_open_page debugging with screenshots
    end
    
    it { should have_content(m1.content) }
    it { should have_content(m2.content) }
    it { should have_content("(#{user.microposts.count})") }
  end
  
end
