require 'rails_helper'

# As a visitor
# When I check out from my cart
# On the new order page I see the details of my cart:
# - the name of the item
# - the merchant I'm buying this item from
# - the price of the item
# - my desired quantity of the item
# - a subtotal (price multiplied by quantity)
# - a grand total of what everything in my cart will cost
# I also see a form to where I must enter my shipping information for the order:
# - name
# - address
# - city
# - state
# - zip
# I also see a button to 'Create Order'

RSpec.describe "When a user goes to the order create page" do
  before(:each) do

    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    #bike_shop items
    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @bike = @bike_shop.items.create(name: "Red Bike", description: "Oldie, but goodie", price: 200, image: "https://i.pinimg.com/originals/9d/5f/29/9d5f29749894957753a9edd9e2358d8b.png", inventory: 10)

    #dog_shop items
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @brush = @dog_shop.items.create(name: "Brush", description: "Great for long haired pets", price: 15, image: "https://images-na.ssl-images-amazon.com/images/I/71V8HaHa02L._SL1200_.jpg", inventory: 15)

    5.times do
      visit "/items/#{@brush.id}"
      click_button "Add Item"
    end

    2.times do
      visit "/items/#{@tire.id}"
      click_button "Add Item"
    end

    visit '/cart'

    click_button("Checkout")
  end

  it 'can show the users order details' do

    within "#item-checkout-#{@brush.id}" do
      expect(page).to have_content(@brush.name)
      expect(page).to have_content(@brush.merchant.name)
      expect(page).to have_content("Price: $#{@brush.price}")
      expect(page).to have_content("Quantity: 5")
      expect(page).to have_content("Subtotal: $75")
    end

    within "#item-checkout-#{@tire.id}" do
      expect(page).to have_content(@tire.name)
      expect(page).to have_content(@tire.merchant.name)
      expect(page).to have_content("Price: $#{@tire.price}")
      expect(page).to have_content("Quantity: 2")
      expect(page).to have_content("Subtotal: $200")
    end

    within "#cart-summary-checkout" do
      expect(page).to have_content("Total: $275")
    end
  end

  it 'accept users shipping information' do
    name = "Jane Doe"
    address = '123 Happy Street'
    city = "Denver"
    state = "CO"
    zip = 80204

    fill_in :name, with: name
    fill_in :address, with: address
    fill_in :city, with: city
    fill_in :state, with: state
    fill_in :zip, with: zip
  end

  it 'has a button to create order' do
    expect(page).to have_button("Create Order")
  end
end

# As a visitor
# When I fill out all information on the new order page
# And click on 'Create Order'
# An order is created and saved in the database
# And I am redirected to that order's show page with the following information:
# - My name and address (shipping information)
# - Details of the order:
# - the name of the item
# - the merchant I'm buying this item from
# - the price of the item
# - my desired quantity of the item
# - a subtotal (price multiplied by quantity)
# - a grand total of what everything in my cart will cost
# - the date when the order was created
RSpec.describe 'When I users completes the shipping form' do
  it 'clicks Create Order button and a new order is saved in the db' do
    visit '/orders/new'

    fill_in :name, with: 'Susie Homemaker'
    fill_in :address, with: '789 Beaver Lane'
    fill_in :city, with: 'Stepford'
    fill_in :state, with: 'CT'
    fill_in :zip, with: '06075'

    click_button 'Create Order'

    new_order = Order.last

    expect(current_path).to eq("/orders/#{new_order.id}")
  end
end
