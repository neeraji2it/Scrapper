class AddressesController < ApplicationController
  before_action :set_address, only: [:destroy]

  # GET /addresses
  def index
    @addresses = Address.all.page(params[:page])
  end

  def export
    @addresses = Address.all

    respond_to do |format|
      format.html
      format.csv { send_data @addresses.to_csv }
      format.xls
    end
  end

  # GET /addresses/new
  def new
    @address = Address.new
  end

  # POST /addresses
  def create
    @address = Address.new(address_params)

    if @address.valid?
      if @address.scrap_and_update_information_process_1 ||
         @address.scrap_and_update_information_process_2
        p "scrap_and_update_information_process_1"
        gflash success: 'Address was successfully created.'
        redirect_to root_path
      else
        gflash error: 'Unable to scrap data'
        redirect_to root_path
      end
    else
      gflash :now, :error => @address.errors.full_messages.join("<br/>").html_safe
      render :new
    end
  end

  def destroy_all
    Address.destroy_all
    redirect_to root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def address_params
      params.require(:address).permit(:full_name, :full_address)
    end
end
