require 'spec_helper'

describe "AuthenticationPages" do

  subject { page } 

  describe "signin" do
    before { visit signin_path }

    describe 'with invalid information' do
      # we could use stubbing here, call create directly and stub invalid email and usernames, but use their way for now
      it { should have_content('Sign in') }
      it { should have_title('Sign in') }

      it { should have_selector('div.alert.alert-error')}
    end

    describe 'with valid information' do
      # we could use stubbing here, call create directly and stub valid email and usernames, but use their way for now
      let(:user) { FactoryGirl.create :user }

      before do
        fill_in 'Email', with: user.email.upcase
        fill_in 'Password', with: user.password
        click_button 'Sign in'
      end

      it { should have_title user.name }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }

      describe 'followed by signout' do
        before { click_link 'Sign out' }
        it { should have_content('Welcome to the Sample App') }
      end
    end
  end

end
