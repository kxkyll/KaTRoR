require 'spec_helper'

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
    end
end
