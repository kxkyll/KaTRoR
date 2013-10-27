require 'spec_helper'

describe Beer do
  it "is not saved without a name" do
    beer = Beer.create :style => "Lager", :brewery_id => 1

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create :name => "Light Lager", :brewery_id => 1

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end
end
