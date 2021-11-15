class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy done ]

  # GET /tasks or /tasks.json
  def index
    @tasks = []

    if current_account.employee?
      @tasks = Task.where(assignee_id: current_account.id)
    elsif current_account.admin? || current_account.manager?
      @tasks = Task.all
    end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)
    @task.created_by_id = current_account.id
    @task.status = :created

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def assign_all
    assignable_ids = Account.employee.pluck(:public_id)
    Task.transaction do
      Task.created.each { |t| random_assign(assignable_ids, t) }
    end
  end

  def done
    @task.update(status: :done)
  end

  private

  def random_assign(assignable_ids, task)
    assignee_id = assignable_ids.sample
    task.update(assignee: assignee_id)

    assign_data = { public_id: task.public_id, assignee_id: assignee_id }

    WaterDrop::SyncProducer.call({ event_name: 'TaskAssigned', data: assign_data }.to_json, topic: 'tasks')
    WaterDrop::SyncProducer.call({ event_name: 'TaskUpdated', data: assign_data }.to_json, topic: 'tasks-stream')
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:name, :created_by_id, :assignee_id, :status, :assign_amount, :complete_amount)
  end
end
