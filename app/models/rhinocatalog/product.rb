# == Schema Information
#
# Table name: rhinocatalog_products
#
#  id          :integer          not null, primary key
#  category_id :integer
#  name        :string(255)
#  slug        :string(255)      not null
#  description :text
#  position    :integer
#  published   :boolean          default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

module Rhinocatalog
	class Product < ActiveRecord::Base
		before_validation :name_to_slug

		belongs_to :categiry, class_name: self.to_s

		has_many :images, ->{ order(position: :asc) }, as: :imageable, :dependent => :destroy
		accepts_nested_attributes_for :images, allow_destroy: true

		has_many :videos, as: :videoable, autosave: true, :dependent => :destroy
		# has_many :videos, ->{ order(position: :asc) }, as: :videoable, :dependent => :destroy
		# accepts_nested_attributes_for :videos, allow_destroy: true

		has_many :documents, ->{ order(position: :asc) }, as: :documentable, :dependent => :destroy
		accepts_nested_attributes_for :documents, allow_destroy: true

		acts_as_list scope: :category_id

		validates_uniqueness_of :name, :slug, :scope => :category_id

		def hd_video
			videos.find_by(resolution_type: Video::VIDEO_TYPE_HD)
		end
		def hd_video=(new_video)
			videos.where(resolution_type: Video::VIDEO_TYPE_HD).destroy_all
			videos(1) << Video.new(type: Video::VIDEO_TYPE_HD, file: new_video)
		end

		def sd_video
			videos.find_by(resolution_type: Video::VIDEO_TYPE_SD)
		end
		def sd_video=(new_video)
			videos.where(resolution_type: Video::VIDEO_TYPE_SD).destroy_all
			videos(1) << Video.new(type: Video::VIDEO_TYPE_SD, file: new_video)
		end

		def ipad_video
			videos.find_by(resolution_type: Video::VIDEO_TYPE_43)
		end
		def ipad_video=(new_video)
			videos.where(resolution_type: Video::VIDEO_TYPE_43).destroy_all
			videos(1) << Video.new(type: Video::VIDEO_TYPE_43, file: new_video)
		end

		def as_json(options = {})
			options[:only] ||= [:id, :category_id, :name, :description, :position]
			options[:methods] ||= [:images, :video, :documents]

			super(options)
			# super.tap { |hash| hash["videos"] = hash.delete "videos_with_res" }
		end

		def video
			{ hd: hd_video, sd: hd_video, ipad: hd_video } 
		end	

		protected
			def name_to_slug
				if !self.slug.present?
					self.slug = Rhinoart::Utils.to_slug(self.name)
				else
					self.slug = Rhinoart::Utils.to_slug(self.slug)
				end
			end	
	end
end