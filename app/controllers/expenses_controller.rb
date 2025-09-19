class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[show update destroy]

  # GET /expenses or /categories/:category_id/expenses
  def index
    if params[:category_id].present?
      category = Category.find_by(id: params[:category_id])
      return render(json: { error: "Category not found" }, status: :not_found) unless category

      @expenses = category.expenses.page(params[:page]).per(params[:per].to_i.nonzero? || 10)
    else
      @expenses = Expense.page(params[:page]).per(params[:per].to_i.nonzero? || 10)
    end

    render json: @expenses, meta: pagination_meta(@expenses)
  end

  # GET /expenses/:id
  def show
    render json: @expense
  end

  # POST /expenses
  def create
    @expense = Expense.new(expense_params)

    if @expense.save
      render json: @expense, status: :created
    else
      render json: { errors: @expense.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /expenses/:id
  def update
    if @expense.update(expense_params)
      render json: @expense
    else
      render json: { errors: @expense.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /expenses/:id
  def destroy
    @expense.destroy!
    head :no_content
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    # required root key :expense, and allowed attributes
    params.require(:expense).permit(:title, :amount, :category_id, :date)
  end

  def pagination_meta(collection)
    {
      page: collection.current_page,
      per_page: collection.limit_value,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end
end