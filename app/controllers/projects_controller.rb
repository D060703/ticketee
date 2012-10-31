class ProjectsController < ApplicationController
  
  def index
   @projects = Project.all # By calling all on the Project model, you retrieve all the records from the database as Project objects,
  end
  
  def new
    @project = Project.new
  end
  
  def create
    @project = Project.new(params[:project])
    if @project.save
    flash[:notice] = "Project has been created."
    redirect_to @project
  else
     flash[:alert] = "Project has not been created."
     render :action => "new"
  end
  end
  
  def show
    @project = Project.find(params[:id])
  end
  
  
end
