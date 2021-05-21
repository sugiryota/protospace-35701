class PrototypesController < ApplicationController
  before_action :authenticate_user! ,only: [:new,:edit,:destroy]
  before_action :move_to_index, only: [:edit]


  def index
    @prototypes=Prototype.all
  end
  
  def new
    @prototype=Prototype.new
  end

  def create
    if Prototype.create(prototype_params)
       redirect_to root_path
    else
      render :index
    end
  end

  def show
    @prototype=Prototype.find(params[:id])
    @comment=Comment.new
    @comments = @prototype.comments.includes(:user)
  end
  def edit
    @prototype=Prototype.find(params[:id])
  end
  def update
    if Prototype.find(params[:id]).update(prototype_params)
      redirect_to prototype_path
    else
      render :show
    end  
  end
  def destroy
    prototype=Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title,:catch_copy,:concept,:image).merge(user_id: current_user.id)
  end
  def move_to_index
    @prototype=Prototype.find(params[:id])
    unless user_signed_in? && @prototype.user_id == current_user.id
      redirect_to action: :index
    end
  end
  
end
