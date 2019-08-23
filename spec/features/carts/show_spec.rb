require 'rails_helper'

# As a visitor
# When I have added items to my cart
# And I visit my cart ("/cart")
# I see all items I've added to my cart
# Each item in my cart shows the following information:
# - the name of the item
# - the item image
# - the merchant I'm buying this item from
# - the price of the item
# - my desired quantity of the item
# - a subtotal (price multiplied by quantity)
# I also see a grand total of what everything in my cart will cost

RSpec.describe "Cart Index Page" do
  describe "When I visit the cart index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @active_items = [@tire, @pull_toy]
      @inactive_items = [@dog_bone]
    end

    it "See all items in cart when visit cart show page with total" do

      visit "items/#{@pull_toy.id}"
      click_button "Add Item"

      visit "items/#{@tire.id}"
      click_button "Add Item"

      visit "items/#{@tire.id}"
      click_button "Add Item"

      visit '/cart'

      within "cart-item-#{@pull_toy.id}" do
        expect(page).to have_content(@pull_toy.name)
        expect(page).to have_content("img[src*='#{@pull_toy.image}']")
        expect(page).to have_content(@pull_toy.merchant)
        expect(page).to have_content(@pull_toy.price)
        expect(page).to have_content("Quantity: 1")
        expect(page).to have_content("Subtotal: $10.00")
      end

      within "cart-item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content("img[src*='#{@tire.image}']")
        expect(page).to have_content(@tire.merchant)
        expect(page).to have_content(@tire.price)
        expect(page).to have_content("Quantity: 2")
        expect(page).to have_content("Subtotal: $200.00")
      end

      within "cart-summary" do
        expect(page).to have_content("Total: $210.00")
      end
    end
  end
end
