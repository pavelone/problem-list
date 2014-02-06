class ListsController < ApplicationController

  def new
    @list = List.new
    Rails.logger.info("new")
  end
  
  def create
      Rails.logger.info("create")
      #@search_string = params[:q]
      @list = List.new(secure_params)
      @list.search_problem
      render :action => "show"
  end

  def secure_params
    params.require(:list).permit(:search_string, :xmldoc)
  end

end
