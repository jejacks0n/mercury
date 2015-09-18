class MercurySnippet < ActiveRecord::Base

  # self.inheritance_column = nil # to use :data as column_name

  attr_accessible :name, :snippet

  serialize :snippet, Array

end