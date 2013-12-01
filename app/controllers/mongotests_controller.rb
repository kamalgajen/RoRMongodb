class MongotestsController < ApplicationController
  # GET /mongotests
  # GET /mongotests.json
  def index
    @mongotests = Mongotest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mongotests }
    end
  end

  # GET /mongotests/1
  # GET /mongotests/1.json
  def show
    @mongotest = Mongotest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mongotest }
    end
  end

  # GET /mongotests/new
  # GET /mongotests/new.json
  def new
    @mongotest = Mongotest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mongotest }
    end
  end

  # GET /mongotests/1/edit
  def edit
    @mongotest = Mongotest.find(params[:id])
  end

  # POST /mongotests
  # POST /mongotests.json
  def create
    @mongotest = Mongotest.new(params[:mongotest])

    respond_to do |format|
      if @mongotest.save
        format.html { redirect_to @mongotest, notice: 'Mongotest was successfully created.' }
        format.json { render json: @mongotest, status: :created, location: @mongotest }
      else
        format.html { render action: "new" }
        format.json { render json: @mongotest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mongotests/1
  # PUT /mongotests/1.json
  def update
    @mongotest = Mongotest.find(params[:id])

    respond_to do |format|
      if @mongotest.update_attributes(params[:mongotest])
        format.html { redirect_to @mongotest, notice: 'Mongotest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mongotest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mongotests/1
  # DELETE /mongotests/1.json
  def destroy
    @mongotest = Mongotest.find(params[:id])
    @mongotest.destroy

    respond_to do |format|
      format.html { redirect_to mongotests_url }
      format.json { head :no_content }
    end
  end
end
