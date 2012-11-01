class Ticket < ActiveRecord::Base
  belongs_to :project
  attr_accessible :description, :title
  validates :title, :presence => true
  validates :description, :presence => true,
              :length => { :minimum => 10 }
  
  #The project:references part defines an integer column for the tickets table called project_id in the migratio
  #This column represents the project this ticket links to and is called a foreign key.
end
