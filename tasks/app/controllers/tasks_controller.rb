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
        event = {
          event_name: 'TaskCreated',
          id: SecureRandom.uuid,
          version: '2',
          created_at: Time.now.to_s,
          producer: 'tasks',
          data: {
            public_id: @task.public_id,
            assignee_id: @task.assignee.public_id,
            created_by_id: current_account.public_id,
            status: @task.status,
            jira_id: @task.jira_id
          }
        }
        result = SchemaRegistry.validate_event(event, 'tasks.created', version: 2)
        if result.success?
          WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-stream')
        else
          raise result.failure
        end

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

        updated_event = {
          event_name: 'TaskUpdated',
          id: SecureRandom.uuid,
          version: '2',
          created_at: Time.now.to_s,
          producer: 'tasks',
          data: {
            public_id: @task.public_id,
            assignee_id: @task.assignee.public_id,
            status: @task.status,
            jira_id: @task.jira_id
          }
        }
        result = SchemaRegistry.validate_event(event, 'tasks.updated', version: 2)
        if result.success?
          WaterDrop::SyncProducer.call(updated_event.to_json, topic: 'tasks-stream')
        else
          raise result.failure
        end

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
    Task.transaction do
      assignable_ids = Account.employee.pluck(:public_id)
      Task.created.each { |t| random_assign(assignable_ids, t) }
    end
  end

  def done
    @task.update(status: :done)

    event = {
      event_name: 'TaskCompleted',
      id: SecureRandom.uuid,
      version: '1',
      created_at: Time.now.to_s,
      producer: 'tasks',
      data: {
        public_id: @task.public_id,
      }
    }
    result = SchemaRegistry.validate_event(event, 'tasks.completed', version: 1)
    if result.success?
      WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks')
    else
      raise result.failure
    end

    updated_event = {
      event_name: 'TaskUpdated',
      id: SecureRandom.uuid,
      version: '1',
      created_at: Time.now.to_s,
      producer: 'tasks',
      data: {
        public_id: @task.public_id,
        status: @task.status,
      }
    }
    result = SchemaRegistry.validate_event(event, 'tasks.updated', version: 1)
    if result.success?
      WaterDrop::SyncProducer.call(updated_event.to_json, topic: 'tasks-stream')
    else
      raise result.failure
    end

  end

  private

  def random_assign(assignable_ids, task)
    assignee_id = assignable_ids.sample
    task.update(assignee: assignee_id)

    assign_data = { public_id: @task.public_id, assignee_id: assignee_id }

    assigned_event = {
      event_name: 'TaskAssigned',
      id: SecureRandom.uuid,
      version: '1',
      created_at: Time.now.to_s,
      producer: 'tasks',
      data: assign_data }
    result = SchemaRegistry.validate_event(event, 'tasks.assigned', version: 1)
    if result.success?
      WaterDrop::SyncProducer.call(assigned_event.to_json, topic: 'tasks')
    else
      raise result.failure
    end

    updated_event = {
      event_name: 'TaskUpdated',
      id: SecureRandom.uuid,
      version: '1',
      created_at: Time.now.to_s,
      producer: 'tasks',
      data: assign_data }
    result = SchemaRegistry.validate_event(event, 'tasks.updated', version: 1)
    if result.success?
      WaterDrop::SyncProducer.call(updated_event.to_json, topic: 'tasks-stream')
    else
      raise result.failure
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:name, :created_by_id, :assignee_id, :status, :assign_amount, :complete_amount, :jira_id)
  end
end
