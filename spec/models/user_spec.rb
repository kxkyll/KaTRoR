require 'spec_helper'

def create_beers_with_ratings(*scores, user, style, brewery)
    scores.each do |score|
      create_beer_with_rating score, user, style, brewery
    end
end

def create_beer_with_rating(score,  user, style, brewery)
    beer = create_beer_with_style style, brewery
    FactoryGirl.create(:rating, :score => score,  :beer => beer, :user => user)
    beer
end

def create_beer_with_style(style, brewery)
    if style and brewery
        return FactoryGirl.create(:beer, :style => style, :brewery => brewery)
    end
    if style.nil? and brewery.nil?
        return FactoryGirl.create(:beer)
    end
    if style.nil? 
        return FactoryGirl.create(:beer, :brewery => brewery)
    end
    if brewery.nil?
        return FactoryGirl.create(:beer, :style => style)
    end
end


describe User do
    it "has the username set correctly" do
        user = User.new :username => "Pekka"

        user.username.should == "Pekka"
    end

    it "without a proper password is not saved" do
        user = User.create :username => "Pekka"

        expect(user.valid?).to be(false)
        expect(User.count).to eq(0)
    end

    it "with too short password is not saved" do
        user = User.create :username => "Maija", :password => "se1", :password_confirmation => "se1"

        expect(user.valid?).to be(false)
        expect(User.count).to eq(0)
    end

    it "with a password containing only letters is not saved" do
        user = User.create :username => "Maija", :password => "secret", :password_confirmation => "secret"

        expect(user.valid?).to be(false)
        expect(User.count).to eq(0)
    end

    describe "with a proper password" do
        let(:user){ FactoryGirl.create(:user) }
        
        it "is saved" do
            expect(user.valid?).to eq(true)
            expect(User.count).to eq(1)
        end

        it "and with two ratings, has the correct average rating" do
            

            user.ratings << FactoryGirl.create(:rating)
            user.ratings << FactoryGirl.create(:rating2)

            expect(user.ratings.count).to eq(2)
            expect(user.average_rating).to eq(15.0)
        end
    end

    describe "favorite beer" do
        let(:user){FactoryGirl.create(:user)}
        it "has method for determining one" do
            user.should respond_to :favorite_beer
        end

        it "without ratings does not have one" do
            expect(user.favorite_beer).to eq(nil)
        end

        it "is the only rated if only one rating" do
            beer = FactoryGirl.create(:beer)
            rating = FactoryGirl.create(:rating, :beer => beer, :user => user)
            expect(user.favorite_beer).to eq(beer)
        end

        it "is the one with highest rating if several rated" do
            create_beers_with_ratings 10, 20, 15, 7, 9, user, "Bock", nil
            best = create_beer_with_rating 25, user, "Lager", nil

            expect(user.favorite_beer).to eq(best)
        end
    end
    describe "favorite style" do
        let(:user){FactoryGirl.create(:user)}
        it "has method of determining one" do
            user.should respond_to :favorite_style
        end

        it "without ratings does not have one" do
           expect(user.favorite_style).to eq(nil) 
        end

        it "is the only style if one rating" do
            best = create_beer_with_rating 23, user, "Pale ALE", nil
            expect(user.favorite_style).to eq(best.style)
        end

        it "is the one rated highest on average" do
            best = create_beer_with_style "Bock", nil
            create_beers_with_ratings 22, 25, 15, 23, user, "Bock", nil
            create_beers_with_ratings 10, 9, 15, 7, 9, user, "Lager", nil

            expect(user.favorite_style).to eq(best.style)
        end
    end
    describe "favorite brewery" do
        let(:user){FactoryGirl.create(:user)}
        it "has method for determinining favorite brewery" do
            user.should respond_to :favorite_brewery
        end

        it "without ratings does not have " do
           expect(user.favorite_brewery).to eq(nil) 
        end

        it "is the only brewery if one rating" do
            brewery = FactoryGirl.create(:brewery, :name => "Home", :year => 2011)
            best = create_beer_with_rating 23, user, "ALE", brewery
            expect(user.favorite_brewery).to eq(brewery)
        end

        it "is the brewery rated highest on average" do
            
            bestBrewery = FactoryGirl.create(:brewery, :name => "Home", :year => 2011)
            notSoGood = FactoryGirl.create(:brewery, :name => "Other", :year => 2010)
            create_beers_with_ratings 22, 25, 15, 23, user, "Bock", bestBrewery
            create_beers_with_ratings 10, 9, 15, 7, 9, user, "Lager", notSoGood

            expect(user.favorite_brewery).to eq(bestBrewery)
        end
    end
end
