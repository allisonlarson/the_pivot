class Dashboard::AddressesController < UserController
  def update
    @address = current_user.addresses.find(params[:id])

    if @address.update(address_params)
      redirect_to edit_dashboard_user_path
    else
      render :edit
    end
  end

  private

  def address_params
    params.require(:address).permit(:street, :city, :state, :zip, :shipping, :billing)
  end
end
