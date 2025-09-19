class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :title, :amount, :date, :category_id, :category

  # return numeric amount (not string) and format date nicely
  def amount
    object.amount&.to_f
  end

  def date
    object.date&.iso8601
  end

  # embed the category as a small object: { id:, name: }
  def category
    return nil unless object.category
    {
      id: object.category.id,
      name: object.category.name
    }
  end
end