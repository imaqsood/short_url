class ShortUrlsController < ApplicationController
  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token
  before_action :find_shor_url, only: :show

  def index
    render json: { urls: ShortUrl.all.limit(100) }
  end

  def create
    url = ShortUrl.new(url_params)
    url = { errors: url.errors.full_messages } unless url.save
    render json: url
  end

  def show
    return head :not_found unless @url

    @url.increment!(:click_count, 1)
    redirect_to @url.full_url
  end

  private

  def url_params
    params.permit(:full_url)
  end

  def find_shor_url
    @url = ShortUrl.find_by_short_code(params[:id])
  end
end
