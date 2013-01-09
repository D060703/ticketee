class Ticket < ActiveRecord::Base
  
  
  searcher do
    label :tag, :from => :tags, :field => :name
    label :state, :from => :state, :field => :name
  end
  
  paginates_per 50
  
  belongs_to :project
  belongs_to :state
  belongs_to :user

  has_and_belongs_to_many :tags
  
  has_and_belongs_to_many :watchers, :join_table => "ticket_watchers", :class_name => "User"
  
  has_many :assets
  accepts_nested_attributes_for :assets
  
  has_many :comments
  
  after_create :creator_watches_me

  
  attr_accessible :description, :title, :assets_attributes, :tag_names
  attr_accessor :tag_names
  
  validates :title, :presence => true
  validates :description, :presence => true, :length => { :minimum => 10 }
  
 
  def tag!(tags)
    tags = tags.split(" ").map do |tag|
      Tag.find_or_create_by_name(tag)
    end
    self.tags << tags
  end

  
  #The project:references part defines an integer column for the tickets table called project_id in the migratio
  #This column represents the project this ticket links to and is called a foreign key.

  private
  def creator_watches_me
    self.watchers << user
  end

end
