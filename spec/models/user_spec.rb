require 'spec_helper'

describe User do

  before do
    @user = FactoryGirl.create(:user)
    @user.save
  end

  describe "email" do
    it { @user.should respond_to(:email) }

    it 'should have a valid email address' do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end

    it 'should not allow invalid email address' do
      addresses = %w[user@foo,com user_at_food.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end

    it 'should not allow blank email address' do
      @user.email = ""
      @user.should have(2).error_on(:email)
      @user.errors[:email].should include "can't be blank"
      @user.should_not be_valid
    end
  end

  describe "name" do
    it { @user.should respond_to(:name) }

    it 'should not allow blank name' do
      @user.name = ""
      @user.should have(1).error_on(:name)
      @user.errors[:name].should include "can't be blank"
    end

    it 'should not be too long' do
      @user.name =  'a' * 51
      @user.should have(1).error_on(:name)
      @user.errors[:name].should include "is too long (maximum is 50 characters)"
    end
  end

  describe 'password' do
    it { @user.should respond_to(:password_digest) }
    it { @user.should respond_to(:password) }
    it { @user.should respond_to(:password_confirmation) }

    it 'should not allow blank password' do
      @user.password = " "
      @user.password_confirmation = " "

      @user.should_not be_valid
    end

    it 'should not allow mismatch password and password_confirmation' do
      @user.password_confirmation = "mismatch"

      @user.should_not be_valid
    end

    it 'should not allow less than 6 characters' do
      @user.password = '12345'
      @user.password_confirmation = '12345'

      @user.should_not be_valid
    end
  end

  describe 'authenticate' do
    it { @user.should respond_to(:authenticate) }

    let(:found_user)  { User.find_by(email: @user.email) }

    describe 'with valid password' do
      it 'authenticate user' do
        authenticated_user = found_user.authenticate(@user.password)
        @user.should eq authenticated_user
      end
    end

    describe 'with invalid password' do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it 'authenticate user should fail' do
        @user.should_not eq user_for_invalid_password
        user_for_invalid_password.should be_false
      end
    end
  end

  describe "unique user" do
    it 'should not allow duplicate emails' do
      user_duplicate = @user.dup
      user_duplicate.email = @user.email.upcase
      user_duplicate.save
      user_duplicate.should_not be_valid
    end
  end

end