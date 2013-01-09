class Permission < ActiveRecord::Base
  attr_accessible :user, :thing, :action
  
  belongs_to :user
  belongs_to :thing, :polymorphic => true

  
  
end
