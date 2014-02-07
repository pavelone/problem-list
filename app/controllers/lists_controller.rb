class ListsController < ApplicationController

  def new
    @list = List.new
  end
  
  def create
      @list = List.new(secure_params)
      @list.search_problem
      if @list.successful
        render :action => "show"
      else
        flash[:notice] = "Couldn't connect to IMO Service, please try again"
        redirect_to root_path
      end
  end

  def secure_params
    params.require(:list).permit(:search_string, :xmldoc, :successful)
  end

end
