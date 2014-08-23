require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'


describe 'a user viewing the cart page', type: :feature do

  let(:keylime) { Item.create!(title: 'Key Lime', description: 'Yummy',  price_pie: 30.00) }

  it 'can increase the quantity of an item by one' do
    #User goes to items page
    keylime
    page.visit items_path
    #User adds an item to their cart
    click_on 'ADD TO CART'
    #User views the cart page
    visit cart_path
    #User clicks on add one to increase to quantity
    click_on 'Add One'
    #User expects to see new quantity
    visit cart_path
    expect(page).to have_content(2)
  end
end