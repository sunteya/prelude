class DomainSetsController < ApplicationController
  load_and_authorize_resource

  def index
    @q = @domain_sets.search(params[:q])
    @domain_sets = @q.result.page(params[:page])
  end

  def new
  end

  def create
    @domain_set.save
    respond_with @domain_set, location: -> { ok_url_or_default domain_sets_path }
  end

  def edit
  end

  def update
    @domain_set.update(domain_set_params)
    respond_with @domain_set, location: -> { ok_url_or_default domain_sets_path }
  end

  def destroy
    @domain_set.destroy
    respond_with @domain_set, location: -> { ok_url_or_default domain_sets_path }
  end

protected
  def domain_set_params
    params[:domain_set].permit(:title, :content, :family) if params[:domain_set]
  end
end
