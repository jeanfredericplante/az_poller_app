require 'spec_helper'

describe User do
  before { @user = User.new(name: "JF", email: "jfp@hp.com", password: "foobar", password_confirmation: "foobar") }
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  # Those 2 attributes are virtual, they are not persisted in the database
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts)}
  it { should respond_to(:feed) }


  it { should be_valid }
  it { should_not be_admin }

  describe "when the name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when the name is too long" do
    before { @user.name = "a"*51 }
    it { should_not be_valid}
  end

  describe "when the email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when the email is invalid" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]

    it "should be invalid" do
      addresses.each do |valid_email|
        @user.email=valid_email
        expect(@user).to_not be_valid
      end
    end
  end

  describe "when the email is valid" do
    addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]

    it "should be valid" do
      addresses.each do |invalid_email|
        @user.email=invalid_email
        expect(@user).to be_valid
      end

    end
  end

  describe "with the admin attribute set to true" do
    before(:each) do
      @user.save
      @user.toggle!(:admin)
    end
    it { should be_admin }

  end

  describe "when the email address is already taken" do
    it "should not be valid" do
      @user_dup = @user.dup
      @user_dup.email = @user_dup.email.upcase
      @user_dup.save # original @user is not saved yet
      expect(@user).to_not be_valid
    end
  end

  describe "when password is not present" do
    before do
      @user.password, @user.password_confirmation = " ", " "
    end
    it { should_not be_valid }
  end

  describe "when password and password confirmation don't match" do
    before do
      @user.password, @user.password_confirmation = " 1 ", " 2 "
    end
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid_password") }
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end

    describe "with a password that's too short" do
      before { @user.password = @user.password_confirmation = "a" * 5 }
      it { should be_invalid }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) {should_not be_blank}
  end

  describe "microposts associations" do
    before { @user.save }
    let!(:old_post) { FactoryGirl.create(:micropost, user: @user, created_at: 30.days.ago) }
    let!(:new_post) { FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago) }
    it "should have microposts ordered by more recent first" do
      expect(@user.microposts.to_a).to eq [new_post, old_post]
    end
    describe "feed" do
      let(:unfollowed_post) { FactoryGirl.create(:micropost, content: "je ne dois pas apparaitre") }

      its(:feed) { should include(old_post) }
      its(:feed) { should include(new_post) }
      its(:feed) { should_not include(unfollowed_post) }

    end
  end

  describe "when destroying a user" do
    before {
      @user.save
      2.times {FactoryGirl.create(:micropost, user: @user)}
    }
    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      expect{ @user.destroy }.to change(Micropost,:count).by(-2)
      microposts.each do |micropost|
        expect { Micropost.find(micropost.id) }.to raise_error
      end
    end
  end
end
