require 'rails_helper'

describe 'A user with a cart & items', type: :feature do
  let!(:supplier) { FactoryGirl.create(:supplier, users: [user2]) }
  let(:user2) { FactoryGirl.create(:user, email: 'hi@example.com', addresses: [address1, address2]) }
  let!(:keylime)  { supplier.items.create! title: 'key lime', description: "yum", price: 34, inventory: 100 }
  let(:user) { FactoryGirl.create(:user, addresses: [address1, address2]) }
  let(:address1) { FactoryGirl.create(:address, shipping: true) }
  let(:address2) { FactoryGirl.create(:address, shipping: false) }

  before do
    login_as(username: user.email, password: user.password)
    add_to_cart(keylime)
    find("#cart-button").click
  end

  it 'redirects to checkout page after being forced to log in' do
    logout

    find("#cart-button").click

    expect(page).to_not have_content('Enter Your Billing Info')

    click_on('Sign in')

    expect(current_path).to eq signin_path

    fill_in('Email', with: user.email)
    fill_in('Password', with: user.password)
    click_button('Sign in')

    expect(current_path).to eq cart_path
  end

  it 'can get to checkout' do
    click_on('Enter Your Billing Info')
    expect(page).to have_content('Order Overview')
    expect(page).to have_content(keylime)
  end

  xit 'can get order delivered to saved address' do
    click_on('Enter Your Billing Info')
    choose "order[order_type]", :option  =>"Delivery"
    choose "order[delivery_address_id]", :option => 1
    click_on('Place Order')
    expect(page).to have_content('order was successfully created')
    expect(page).to have_content('123 Main Denver CO')
  end

  xit 'can not place order for more items than are in stock' do
    add_to_cart(keylime)
    find('#cart-button').click

    keylime.size = '1'
    keylime.inventory = 1
    keylime.save

    click_on('Enter Your Billing Info')
    choose "order[order_type]", :option  =>"Delivery"
    choose "order[delivery_address_id]", :option => 1
    click_on('Place Order')
    expect(page).to have_content('There are not enough key lime in stock to fulfill your order.')
  end

end
