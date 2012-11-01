class Project < ActiveRecord::Base
  attr_accessible :name
  validates :name, :presence => true
  
  has_many :tickets
  #The build method is equivalent to new for the Ticket class (which you create in a moment) but associates the new object instantly with the @project object by setting a foreign key called project_id automatically
  
end
