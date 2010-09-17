class BooksILovesController < ApplicationController
  
  def index
     if current_user
        if current_user.memetales_iphone_token
        #  test = current_user.memetales_iphone_token.client.post("http://localhost:3000/books_i_loves.json",{ :token => current_user.memetales_iphone_token.token.to_s})
          current_user.memetales_iphone_token.client.head("/books_i_loves")
        end
     end
  end

end
