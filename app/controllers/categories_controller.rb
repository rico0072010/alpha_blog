class CategoriesController < ApplicationController
  before_action :require_admin, except: %i[index show]
  before_action :set_category, only: %i[show edit update]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = 'You created a new category'
      redirect_to @category
    else
      render 'new'
    end
  end

  def show
    @user_articles = @category.articles.paginate(page: params[:page], per_page: 5)
  end

  def index
    @categories = Category.paginate(page: params[:page], per_page: 5)
  end

  def edit; end

  def update
    if @category.update(category_params)
      flash[:success] = 'Category name updated succesffully'
      redirect_to @category
    else
      render 'edit'
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def require_admin
    unless logged_in? && current_user.admin?
      flash[:danger] = 'Only admins can perfom that action'
      redirect_to categories_path
    end
  end
end
