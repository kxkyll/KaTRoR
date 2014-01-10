module OwnTestHelper
    def sign_in (username, password)
        visit signin_path
        fill_in('username', :with => username)
        fill_in('password', :with => password)
        
        click_button('Log in')
    end

    def make_rate(beername, score)
        select(beername, :from => 'rating[beer_id]')
        fill_in('rating[score]', :with => score)
        click_button "Create Rating"
    end
end