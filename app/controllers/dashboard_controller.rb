class DashboardController < ApplicationController
  def index
    if current_user
      if current_user.memetales_iphone_token
        begin
          response = current_user.memetales_iphone_token.client.get("http://localhost:3000/featured_books.json")

          @items = JSON.parse(response.body)
        rescue JSON::ParserError => e
          @items = ["No JSON returned"]
        end
      elsif current_user.strings_token
      else
        @items = []
      end
    end
  end
  


end


