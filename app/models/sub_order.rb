class SubOrder < ActiveRecord::Base
  belongs_to :supplier
  belongs_to :order
  has_many :order_items, dependent: :destroy
  has_many :items, through: :order_items

  class Status
    PAID      = "paid"
    CANCELLED = "cancelled"
    COMPLETED = "completed"
    ORDERED   = "ordered"

    ALL       = [PAID, CANCELLED, COMPLETED, ORDERED]
  end

  def self.status_counts
    result = self.group(:status).count
    Status::ALL.each {|key| result[key] ||= 0}
    result
  end

  def find_address
    if !self.delivery_address_id.nil?
      user_address = self.order.user.addresses.find(delivery_address_id)
      print_address(user_address)
    end
  end

  def print_address(address)
    "#{address.street}, #{address.city}, #{address.state} #{address.zip}"
  end

  def self.all_count
    self.count
  end

  def delivery?
    order_type == "delivery"
  end

  def cancelled?
    order_status == "cancelled"
  end

  def ordered?
    order_status == "ordered"
  end

  def paid?
    order_status == "paid"
  end

  def complete?
    order_status == 'completed'
  end

  scope :ordered, -> {where(status: "ordered")}
  scope :cancelled, -> {where(status: "cancelled")}
  scope :paid, -> {where(status: "paid")}
  scope :completed, -> {where(status: "completed")}


  def total
    self.order_items.reduce(0) do |sum, order_item|
      sum += (order_item.quantity * order_item.item.price)
    end
  end

  def get_total
    '$' + sprintf("%.2f", total / 100.00)
  end
end
