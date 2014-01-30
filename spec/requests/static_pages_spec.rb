require 'spec_helper'

describe "Static pages" do

  let(:base_title)  {"AZP"}

  describe "Home page" do
    subject { page }

    describe "when signed out" do
      before(:each) { visit root_path }
      it { should have_content('Amazon price poller') }
      it { should have_title("#{base_title}") }
      it { should_not have_title("Home") }
      it { should_not have_title("|") }
      it { should have_link("Start tracking", href: signup_path)}
    end
    describe "when signed in" do
      let(:user) { FactoryGirl.create(:user)}
      before(:each) {
        sign_in user
        visit root_path
      }

      describe "i should see my basic info" do
        it { should have_content(user.name)}
        it { should have_link("Profile", href: user_path(user))}
      end

      describe "i should see my feed" do
        before do
          FactoryGirl.create(:micropost, user: user, content: "halo")
          FactoryGirl.create(:micropost, user: user, content: "it's time to go")
          visit root_path
        end
        it "should have a line item with my feed" do
          user.feed.each do |item|
            expect(page).to have_selector("li", text: item.content)
          end
        end
      
      end
    end


  end

  describe "Help page" do
    before(:each) { visit help_path }
    subject { page }

    it { should have_content("Help") }
    it { should have_title("#{base_title} | Help") }
  end

end
