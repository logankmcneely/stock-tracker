class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

  def self.new_lookup(ticker_symbol)
    get_client
    begin
      new(
        ticker: ticker_symbol,
        name: client.company(ticker_symbol).company_name
      )
    rescue => exception
      return nil
    end
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  def last_price
    client = get_client
    client.price(self.ticker)
  end

  private

  def get_client
    IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:sandbox_tokens][:publishable_token],
      secret_token: Rails.application.credentials.iex_client[:sandbox_tokens][:secret_token],
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
  end
  
end
