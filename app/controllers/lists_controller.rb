class ListsController < ApplicationController

  def new
    @list = List.new
  end
  
  def create
      @list = List.new(secure_params)
      @list.search_problem
      render :action => "show"
  end

  def secure_params
    params.require(:list).permit(:search_string, :xmldoc)
  end

end
