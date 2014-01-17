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

  describe "edit" do
    let(:user) { FactoryGirl.create :user }
    before do 
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@email.com" }

      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it 'redirects to the user page' do
        should have_title(new_name)
        should have_link('Sign out', href: signout_path)
        user.reload.name.should eq new_name
        user.reload.email.should eq new_email
      end

    end
  end

  describe "index" do
    before do
      sign_in FactoryGirl.create :user
      FactoryGirl.create :user, name: "Bob", email: "bob@example.com"
      FactoryGirl.create :user, name: "John", email: "john@example.com"
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    it "should list each user" do
      User.all.each do |user| 
        expect(page).to have_selector('li', text: user.name)
      end
    end 

    describe 'pagination' do
      before(:all) { 30.times { FactoryGirl.create :user } }
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') }
      it 'lists each user' do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe 'delete links' do
      let(:admin) { FactoryGirl.create :user, :as_admin }
      before do
        sign_in admin
        visit users_path
      end

      it { should have_link('delete', href: user_path(User.first)) }
      it "should be able to delete another user" do
        expect do
          click_link('delete', match: :first)
        end.to change(User, :count).by(-1)
      end
      it { should_not have_link('delete', href: user_path(admin)) }
    end
  end

end
