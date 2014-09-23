require 'rails_helper'

describe 'A user with a cart & items', type: :feature do
  let!(:supplier) { FactoryGirl.create(:supplier)}
  let!(:keylime)  { supplier.items.create! title: 'key lime', description: "yum", price: 34 }
  let(:user) {FactoryGirl.create(:user, addresses: [address1, address2])}
  let(:address1) { FactoryGirl.create(:address, shipping: true, billing: false)}
  let(:address2) { FactoryGirl.create(:address, shipping: false, billing: true)}

  before do
    login_as(username: user.email, password: user.password)
    add_to_cart(keylime)
    page.click_on('Cart')
  end

  xit 'can get to checkout' do
    click_on('Continue to Checkout')
    expect(page).to have_content('Order Overview')
    expect(page).to have_content(keylime)
  end

  xit 'can get order delivered to saved address' do
    click_on('Continue to Checkout')
    choose "order_type"
    select "123 Main", :from => "delivery_address"
    select "123 Main", :from => "billing_address"
    click_on('Place Order')
    expect(page).to have_content('Order was successfully created')
    expect(page).to have_content('123 Main Denver CO')
  end

  xit 'can see it made previous orders' do
    click_on('Checkout')
    visit dashboard_root_path
    expect(page).to have_content('Purchased Orders')
  end
end
