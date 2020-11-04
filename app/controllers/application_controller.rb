class ApplicationController < ActionController::API
  def ignore_cache
    ActiveModel::Type::Boolean.new.cast(params[:ignore_cache]) ||
      ActiveModel::Type::Boolean.new.cast(ENV['IGNORE_CACHE'])
  end
end
