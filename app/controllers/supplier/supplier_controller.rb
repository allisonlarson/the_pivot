class Supplier::SupplierController < ApplicationController
  before_action :authorize?

  def show
  end

  private

    def authorize?
      redirect_to "https://www.youtube.com/watch?v=Jvk7faxsxkQ" unless current_user.role == "supplier"
    end
end
