require 'spec_helper'
describe "Beers page" do
    include OwnTestHelper
    let!(:brewery3) { FactoryGirl.create :brewery, :name => "Franz Inselkammer" }
    let!(:user3) { FactoryGirl.create :user, :username => "Mai",  :password => 'maimai3',  :password_confirmation => 'maimai3' } 

    before :each do
       sign_in 'Mai', 'maimai3'
    end

    it "should not have any before been created" do
        visit beers_path
        expect(page).to have_content 'Listing beers'
    end

    it "created beer should be saved" do
        visit new_beer_path
        fill_in('beer[name]', :with => 'Celebrator')
        select 'Doppelbock', :from => 'beer[style]'
        select 'Franz Inselkammer', :from => 'beer[brewery_id]'

        expect{
            click_button 'Create Beer'
        }.to change{Beer.count}.by(1)
    end
    
end