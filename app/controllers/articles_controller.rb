class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :show, :destroy]
  before_action :require_same_user, only: [:edit, :update]

  def index
    @articles= Article.paginate(page: params[:page], per_page: 5)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user= User.find(session[:user_id])
    respond_to do |format|
      if @article.save
        format.html { redirect_to user_article_path(current_user,@article), notice: "Article was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to user_article_path(current_user,@article), notice: "Article was successfully Updated." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def search
    @query= params[:query]
    @articles= Article.where('articles.title LIKE ?',["%#{@query}%"])
    render 'index'
  end

  def destroy
    @article.destroy
    flash[:notice]="Article was successfully deleted"
    redirect_to user_articles_path
  end

  private
  def set_article
    @article= Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title,:description, :image)
  end

  def require_same_user
    if current_user != @article.user and !current_user.admin?
      flash[:danger] = "You can only edit or delete your own articles"
      redirect_to root_path
    end
  end
end
