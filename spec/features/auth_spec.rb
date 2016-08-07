feature "the signup process" do

  scenario "has a new user page" do
    visit new_user_url
    expect(page).to have_content "new user"
  end

  feature "signing up a user" do
    before(:each) do
      visit new_user_url
      fill_in 'Username', :with => "testing_username"
      fill_in 'Password', :with => "biscuits"
      click_on "Submit"
    end

    scenario "redirects to subs index page after signup" do
      expect(page).to have_content "subs"
    end

    scenario "shows username on the homepage after signup" do
      expect(page).to have_content "testing_username"
    end
  end

  feature "with an invalid user" do
    before(:each) do
      visit new_user_url
      fill_in 'Username', :with => "testing_username"
      click_on "Submit"
    end

    scenario "re-renders the signup page if an invalid user is given" do
      expect(page).to have_content "new user"
      expect(page).to have_content "Password is too short"
    end
  end

end
