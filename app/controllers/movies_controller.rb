class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.unique(:rating)
    @checked_bool = @all_ratings.product([true]).to_h
    @movies = Movie.all
    @sort = ""
    if params.key?(:sort_key)
      @movies = Movie.order(params[:sort_key])
      @sort = params[:sort_key]
    elsif params.key?(:ratings)
      @movies = Movie.with_ratings(params[:ratings].keys)
      @checked_bool = @all_ratings.product([false]).to_h
      params[:ratings].keys.each do |rating|
        @checked_bool[rating] = true
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
