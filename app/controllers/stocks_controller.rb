class StocksController < ApplicationController

  def show
    stock = Stock.new(ticker: params[:id])
    begin
      @quote = stock.get_quote
      @news = stock.get_news
      db_lookup = Stock.check_db(params[:id])
      @stock_id = db_lookup.nil? ? nil : db_lookup.id
    # If API call fails, stock was invalid
    rescue
      flash[:alert] = "Invalid stock. Returned to portfolio view."
      redirect_to my_portfolio_path
    end
  end

  def search
    if params[:stock].present?

      begin
        # Check if exists in DB, else create new Stock object
        db_lookup = Stock.check_db(params[:stock])
        stock = db_lookup.nil? ? Stock.new(ticker: params[:stock]) : db_lookup

        @quote = stock.get_quote
        @stock_id = stock.id

        respond_to do |format|
          format.js { render partial: 'users/stock_result' }
        end

      # If API call fails, the stock call was invalid
      rescue
        respond_to do |format|
          flash.now[:alert] = "Please enter a valid symbol to search"
          format.js { render partial: 'users/stock_result' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a symbol to search"
        format.js { render partial: 'users/stock_result' }
      end
    end
  end

  def refresh_tracked_stocks
    @user = User.find(params[:user_id])
    respond_to do |format|
      flash.now[:alert] = "Please enter a symbol to search"
      format.js { render partial: 'users/refresh_tracked_stocks' }
    end
  end

end
