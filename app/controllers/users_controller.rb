class UsersController < ApplicationController

  # things inside params and methods require colons at the front
  # symbols are used for unique identifiers and NOT data
  # if the textual content is important use a string, if the identity of the object is important use a symbol

  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page], per_page: 5 )
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to Ken's Blog #{@user.username}"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Your account was updated successfully"
      redirect_to articles_path
    else
      render 'edit'
    end
  end

  def show
    @paginated_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user
      flash[:danger] = "You can only edit your own account"
      redirect_to root_path
    end
  end
  
end
