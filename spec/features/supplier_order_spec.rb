require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'
describe 'a supplier viewing the order page', type: :feature do
  let!(:supplier) { FactoryGirl.create(:supplier, users: [user]) }
  let(:supplier2) { FactoryGirl.create(:supplier, name: 'Different', url: 'Different', users: [user2]) }
  let!(:user) { FactoryGirl.create(:user, role:'supplier', addresses: [address]) }
  let!(:user2) { FactoryGirl.create(:user,email:'example2@example.com', role:'supplier', addresses: [address]) }

  let(:order) { FactoryGirl.create(:order, user: user, items: [item, item2], delivery_address_id: address.id)}
  let(:address) { FactoryGirl.create(:address, shipping: true)}
  let(:item) { FactoryGirl.create(:item, supplier: supplier)}
  let(:item2) { FactoryGirl.create(:item, supplier: supplier2, title: 'Different')}

  before(:each) do
    login_as(username: user.email, password: user.password)
    order.create_sub_orders
  end

  it 'can see the sub-orders associated with them' do
    visit dashboard_supplier_sub_orders_path(supplier)
    first(:link,'Show').click
    expect(page).to have_content(item.title)
    expect(page).to_not have_content(item2.title)
  end

  it 'can edit the sub-order' do
    visit dashboard_supplier_sub_orders_path(supplier)
    first(:link,'Show').click
    click_on('Edit')
    fill_in('sub_order[provider_name]', with: 'Allie')
    fill_in('sub_order[provider_email]', with: 'allie@example.com')
    click_on('Save Changes')
    expect(page).to have_content('allie@example.com')
    expect(page).to have_content('Allie')
    expect(page).to_not have_content('user@example.come')
    expect(page).to_not have_content('Jon')
  end

  it 'can delete items from a sub-order' do
    visit dashboard_supplier_sub_orders_path(supplier)
    first(:link,'Show').click
    click_on('Edit')
    click_on('Delete')
    expect(page).to_not have_content(item.title)
  end

  it 'can edit items on a sub-order' do
    visit dashboard_supplier_sub_orders_path(supplier)
    first(:link,'Show').click
    click_on('Edit')
    click_on('Edit Item')
    fill_in('order_item[price]', with: 30.99)
    fill_in('order_item[quantity]', with: 99)
    click_on('Save Changes')
    click_on('Back to Edit Order')
    expect(page).to have_content(99)
    expect(page).to have_content(29)
    expect(page).to_not have_content(371.88)
  end

  it 'can delete a sub-order' do
    visit dashboard_supplier_sub_orders_path(supplier)
    expect(order.sub_orders.count).to eq(2)
    first(:link, 'Delete').click
    expect(order.sub_orders.count).to eq(1)
    expect(order.order_items.count).to eq(1)
  end

  it 'can change the status of a sub-order' do
    visit dashboard_supplier_sub_orders_path(supplier)
    first(:link,'Show').click
    click_on('Edit')
  end


end
