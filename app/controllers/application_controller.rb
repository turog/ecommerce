class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_filter :categories, :brands

  # before anything happens, allows us to use the role attribute
  before_action :configure_permitted_parameters, if: :devise_controller?

  def categories
    @categories = Category.all
  end

  def brands
  	@brands = Product.pluck(:brand).sort.uniq!
  	#brands will equal nil if there are duplicates
  	if @brands == nil
  		@brands = Product.pluck(:brand).sort
  	end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[:role])
  end

end

