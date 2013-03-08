class StoreController < ApplicationController
  def index
		@products = Product.all
		if session[:counter].nil?
			session[:counter]=0;
		end
		session[:counter]=session[:counter]+1;
  end
end
