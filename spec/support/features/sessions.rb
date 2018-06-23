module Features
  module Sessions
    def sign_in(user)
      visit new_session_path

      within 'form' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_on 'Login'
      end
    end
  end
end

RSpec.configure do |config|
  config.include Features::Sessions, type: :feature
end
