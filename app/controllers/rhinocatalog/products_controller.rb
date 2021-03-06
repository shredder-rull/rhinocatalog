require_dependency "rhinocatalog/application_controller"

module Rhinocatalog
	class ProductsController < BaseController
		before_action :set_product, only: [:edit, :update, :destroy]

		def index
			@category = Category.find(params[:category_id])
			@products = @category.products.paginate(:page => params[:page])
		end

		def new
			@category = Category.find(params[:category_id])
			@product = Product.new
		end

		def create
			@product = Product.new(product_params)
			@category = Category.find(params[:category_id])

			respond_to do |format|
				if @product.save
					if params[:continue].present? 
						@redirect_to = edit_category_product_path(@category, @product)
					else
						@redirect_to = category_products_path(@category)
					end						
					format.html { redirect_to @redirect_to }
					format.js {}
				else
					format.html { render action: 'new' }
					format.js {}
				end
			end	
		end

		def edit
		end

		def update
			respond_to do |format|
				if @product.update(product_params)
					if params[:continue].present? 
						@redirect_to = edit_category_product_path(@category, @product)
					else
						@redirect_to = category_products_path(@category)
					end						
					format.html { redirect_to @redirect_to }
					format.js {}
				else
					format.html { render action: 'edit' }
					format.js {}
				end
			end	
		end

		def destroy
			@product.destroy
			redirect_to [@category, :products]			
		end

		private
			# Use callbacks to share common setup or constraints between actions.
			def set_product
				begin
					@category = Category.find(params[:category_id])
					@product = Product.find(params[:id])
				rescue
					render :template => 'site/not_found', :status => 404
				end
			end

			# Only allow a trusted parameter "white list" through.
			def product_params
				params[:product].permit!
			end
	end
end
