require 'spec_helper'

describe "UserPages" do

	subject { page }

	describe "signup page" do
    describe 'invalid information' do
      it 'should not create a user' do
        visit signup_path
        expect { click_button 'Create my account' }.not_to change(User, :count)
      end
    end

    describe 'valid information' do
      before do
        visit signup_path
        fill_in 'Name', with: 'Example User'
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'foobar'
        fill_in 'Confirmation', with: 'foobar'
      end

      it 'should create a user' do 
        expect { click_button 'Create my account' }.to change(User, :count).by(1)
      end
    end

    it 'should contain Sign Up' do
      visit signup_path

      should have_content('Sign up')
      should have_title(full_title('Sign up'))
    end
	end

  describe 'profile page' do

    it 'should have user as the title' do
      user = FactoryGirl.create(:user)
      visit user_path(user)

      should have_content(user.name)
      should have_title(user.name)
    end
  end

end
