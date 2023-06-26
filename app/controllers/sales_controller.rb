require 'csv'

class SalesController < ApplicationController
  before_action :set_sale, only: %i[show edit update destroy]

  def index
    @sales = Sale.all
    @gross_income = @sales.sum { |sale| sale.item_price * sale.purchase_count }
  end

  def show
  end

  def new
    @sale = Sale.new
  end

  def edit
  end

  def create
    @sale = Sale.new(sale_params)

    respond_to do |format|
      if @sale.save
        update_revenue(@sale.item_price * @sale.purchase_count)
        format.html { redirect_to sales_path, notice: "Sale was successfully created." }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sale&.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @sale.update(sale_params)
        format.html { redirect_to sale_url(@sale), notice: "Sale was successfully updated." }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sale.destroy

    respond_to do |format|
      format.html { redirect_to sales_url, notice: "Sale was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def import
    file = params[:file]
    return redirect_to new_sale_path, notice: 'Only CSV please' unless file.content_type == "text/csv"


    # Abre o arquivo CSV e converte para UTF-8
    csv_data = File.read(file.path, encoding: 'iso-8859-1:utf-8')
    csv = CSV.parse(csv_data, headers: true, col_sep: ';')

    csv.each do |row|
      sale_hash = {}
      sale_hash[:purchaser_name] = row['purchaser_name'].to_s
      sale_hash[:item_description] = row['item_description'].to_s
      sale_hash[:item_price] = row['item_price'].to_d
      sale_hash[:purchase_count] = row['purchase_count'].to_i
      sale_hash[:merchant_address] = row['merchant_address'].to_s
      sale_hash[:merchant_name] = row['merchant_name'].to_s

      @sale = Sale.new(sale_hash)
      if @sale.valid? && @sale.save
        update_revenue(@sale.item_price * @sale.purchase_count)
      else
        puts @sale.errors.full_messages
      end
    end
    redirect_to sales_path, notice: 'Sales imported'
  end

  private

  def set_sale
    @sale = Sale.find(params[:id])
  end

  def sale_params
    params.require(:sale).permit(:purchaser_name, :item_description, :item_price, :purchase_count, :merchant_address, :merchant_name)
  end

  def update_revenue(amount)
    revenue = Revenue.first_or_create
    revenue.total = 0 if revenue.total.nil?
    revenue.total += amount
    revenue.save
  end
end
