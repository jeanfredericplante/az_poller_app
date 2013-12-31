require 'spec_helper'

describe User do
  before { @user = User.new(name: "JF", email: "jfp@hp.com") }
  subject { @user }
  
  it { should respond_to(:name) }
  it { should respond_to(:email) }
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
    
  end
end
