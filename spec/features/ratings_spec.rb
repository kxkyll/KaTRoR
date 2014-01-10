require 'spec_helper'

describe "Rating" do
    include OwnTestHelper
    let!(:brewery) { FactoryGirl.create :brewery, :name => "Koff" }
    let!(:brewery2) { FactoryGirl.create :brewery, :name => "Karhula" }
    let!(:beer1) { FactoryGirl.create :beer, :name => "iso 3", :brewery => brewery }
    let!(:beer2) { FactoryGirl.create :beer, :name => "Karhu", :brewery => brewery2, :style =>'Ale' }
    let!(:user) { FactoryGirl.create :user }
    let!(:user2) { FactoryGirl.create :user, :username => "Pia",  :password => 'piapia2',  :password_confirmation => 'piapia2' }

    before :each do
      sign_in 'Pekka', 'foobar1'
    end

    it "when given, is registered to the beer and user who is signed in" do
      visit new_rating_path
      
      select(beer1.name, :from => 'rating[beer_id]')
      
      fill_in('rating[score]', :with => '15')
      
      expect{
        click_button "Create Rating"
      }.to change{Rating.count}.from(0).to(1)

      expect(user.ratings.count).to eq(1)
      expect(beer1.ratings.count).to eq(1)
      expect(beer1.average_rating).to eq(15.0)
    end

    it "when two ratings, ratings are listed correctly in user page" do
        visit new_rating_path
        make_rate(beer1.name, 20)
        
        visit new_rating_path
        make_rate(beer2.name, 22)

        #save_and_open_page

        expect(user.ratings.count).to eq(2)
        expect(beer1.ratings.count).to eq(1)
        expect(beer1.average_rating).to eq(20.0) 
        expect(beer2.ratings.count).to eq(1)
        expect(beer2.average_rating).to eq(22.0) 
        expect(page).to have_content 'has given 2 ratings, average 21'
        expect(page).to have_content 'favorite style Ale'
        expect(page).to have_content 'favorite brewery Karhula'
    end

    it "when two ratings from two users, ratings are listed correctly in ratings page" do
        visit new_rating_path
        make_rate(beer1.name, 20)
        
        visit new_rating_path
        make_rate(beer2.name, 22)

        visit signout_path
        sign_in 'Pia', 'piapia2' 

        visit new_rating_path
        make_rate(beer1.name, 12)
       
        visit new_rating_path
        make_rate(beer2.name, 18)
        
        visit ratings_path
        expect(page).to have_content 'Number of ratings: 4'
    end

    it "when user deletes one, rating is removed" do
        visit new_rating_path
        make_rate(beer1.name, 20)
        
        visit new_rating_path
        make_rate(beer2.name, 22)

        
        expect(user.ratings.count).to eq(2)
        expect(beer1.ratings.count).to eq(1)
        expect(page).to have_content 'has given 2 ratings, average 21'
        

        find(:xpath, '//a[@href="/ratings/1"]').click
        expect(user.ratings.count).to eq(1)
        expect(beer1.ratings.count).to eq(0)
        
    end
end