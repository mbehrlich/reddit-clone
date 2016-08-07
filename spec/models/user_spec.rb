require 'rails_helper'

RSpec.describe User, type: :model do

  describe "validations" do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_length_of(:password).is_at_least(6) }
  end
  describe "associations" do
    it { should have_many(:subs) }
    it { should have_many(:votes) }
    it { should have_many(:comments) }
  end
  describe "#is_password?" do
    before(:each) do
      @frank = User.new(username: "frank", password: "12345678")
    end
    it "should validate password" do
      expect(@frank.is_password?("12345678")).to be true
    end
    it "should block invalid passwords" do
      expect(@frank.is_password?("asdf")).to be false
    end
  end
  describe "#reset_session_token" do
    before(:each) do
      @frank = User.new(username: "frank", password: "12345678")
    end
    it "should assign a new session token" do
      @token = @frank.session_token
      @frank.reset_session_token
      expect(@frank.session_token).to_not eq(@token)
    end
  end
  describe "::find_by_credentials" do
    before(:each) do
      @frank = User.create(username: "frank", password: "12345678")
    end
    it "should find a user" do
      @user = User.find_by_credentials("frank", "12345678")
      expect(@user).to eq(@frank)
    end
    it "should not find the user with an incorrect password" do
      @user = User.find_by_credentials("frank", "bleh")
      expect(@user).to eq("Error: Incorrect password")
    end
    it "should return nil when there is no user" do
      @user = User.find_by_credentials("bleh", "bleh")
      expect(@user).to eq("Error: Username not found")
    end
  end
end
