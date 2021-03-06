# == Schema Information
#
# Table name: folders
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Folder < ActiveRecord::Base

	attr_accessible :description, :name, :attachments_attributes

	has_many :attachments, :as => :attachable, :order => "updated_at DESC"
	
	accepts_nested_attributes_for :attachments, :allow_destroy => true

end

