require 'rails_helper'

RSpec.describe Item, type: :model do
  it "validates Name and Type ID" do
  	item = Item.new
  	expect(item).to_not be_valid
  end
end

