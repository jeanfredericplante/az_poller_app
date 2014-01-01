require 'spec_helper'

describe User do
  before { @user = User.new(name: "JF", email: "jfp@hp.com") }
  subject { @user }
  
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should be_valid }
  
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
  
  describe "when the email address is already taken" do
    it "should not be valid" do
      @user_dup = @user.dup
      @user_dup.email = @user_dup.email.upcase
      @user_dup.save # original @user is not saved yet
      expect(@user).to_not be_valid
    end

  end
end
