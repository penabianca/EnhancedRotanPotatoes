class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @sort = params[:sort]
    if @sort.nil? == false
      session[:sort] = @sort
    end
    puts "just sort"
    puts session
    if params[:ratings]
      @checked_boxes = params[:ratings].keys
      diff = @checked_boxes - @all_ratings
      if diff.length != 0
        flash.keep
        puts "diff not empty"
        puts diff
      @movies = Movie.where('rating' => session[:ratings]).order(session[:sort]).all
      else
      puts @checked_boxes
      puts "with ratings"
      session[:ratings] = @checked_boxes
      puts session
      @movies = Movie.where('rating' => session[:ratings]).order(session[:sort]).all
      end
    else
      @checked_boxes = session[:ratings]
      @movies = Movie.where('rating' => session[:ratings]).order(session[:sort]).all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
