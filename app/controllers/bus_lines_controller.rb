class BusLinesController < ApplicationController
  before_action :set_line, only: [:show, :edit, :update, :destroy]
  before_action :user_must_be_logged_in!, except: [:index, :show]

  # GET /lines
  # GET /lines.json
  def index
    @bus_lines = BusLine.all.order(:name)
  end

  # GET /lines/1
  # GET /lines/1.json
  def show
  end

  # GET /lines/new
  def new
    @bus_line = BusLine.new
  end

  # GET /lines/1/edit
  def edit
  end

  # POST /lines
  # POST /lines.json
  def create
    @bus_line = BusLine.new(line_params)

    respond_to do |format|
      if @bus_line.save
        format.html { redirect_to @bus_line, notice: 'BusLine was successfully created.' }
        format.json { render :show, status: :created, location: @bus_line }
      else
        format.html { render :new }
        format.json { render json: @bus_line.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lines/1
  # PATCH/PUT /lines/1.json
  def update
    respond_to do |format|
      if @bus_line.update(line_params)
        format.html { redirect_to @bus_line, notice: 'BusLine was successfully updated.' }
        format.json { render :show, status: :ok, location: @bus_line }
      else
        format.html { render :edit }
        format.json { render json: @bus_line.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lines/1
  # DELETE /lines/1.json
  def destroy
    @bus_line.destroy
    respond_to do |format|
      format.html { redirect_to lines_url, notice: 'BusLine was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line
      @bus_line = BusLine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_params
      params.require(:bus_line).permit(:name)
    end
end
