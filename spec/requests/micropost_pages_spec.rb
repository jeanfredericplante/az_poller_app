require 'spec_helper'

describe "Micropost pages" do
  subject {page}
  let(:user) { FactoryGirl.create(:user) }
  
  describe "micropost create" do
    before(:each) do
      sign_in user
      visit root_path    
    end
    describe "with invalid information" do
      specify { expect {click_button("Post")}.to_not change(user.microposts, :count) }
      before { click_button "Post" }
      it { should have_content("error")}
      it "should maintain the / route(specify { expect(current_path).to eq root_path})" 
      
    end
    
    describe "with valid information" do
      let(:post) { "Lorem ipsum"}
      before { fill_in "micropost_content", with: post }
      describe "it should increment your microposts counts by 1" do
        specify { expect {click_button("Post")}.to change(user.microposts, :count).by(1) }
      end
      
      describe "when going to your profile, it should display the new post" do
        before do
          click_button "Post"
          visit user_path(user) 
        end
        it { should have_content(post) }
        it { should have_content("(#{user.microposts.count})") }  
        
        describe "when deleting a micropost" do
          it { should have_link("delete", href: micropost_path(user.microposts.first)) }
          describe "it should decrement your microposts count by 1" do
            specify { expect {click_link("delete")}.to change(user.microposts, :count).by(-1) }
          end
        end
      end
      
      describe "when going to your home page, it should allow destroying a post" do
        before { 
          FactoryGirl.create(:micropost, user: user)
          visit root_path 
        }
        
      end
    end
  end
  

end
