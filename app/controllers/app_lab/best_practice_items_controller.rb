module AppLab
  class BestPracticeItemsController < ApplicationController
    def show
      item = BestPracticeItem.find(params[:id])
      render_inertia "Practices/ItemDetail", props: {
        item: serialize(item),
        check_history: item.best_practice_checks.recent.limit(10).map { |c|
          { status: c.status, checked_at: c.checked_at, checked_by: c.checked_by, notes: c.notes }
        }
      }
    end

    def verify
      item = BestPracticeItem.find(params[:id])
      # TODO: Run automated verification
      check = item.best_practice_checks.create!(
        status: :in_progress,
        checked_at: Time.current,
        verification_method: "manual_trigger"
      )
      redirect_to item, notice: "Verification started."
    end

    def toggle
      item = BestPracticeItem.find(params[:id])
      new_status = item.current_status == "passed" ? :failed : :passed
      item.best_practice_checks.create!(
        status: new_status,
        checked_at: Time.current,
        checked_by: params[:checked_by] || "unknown"
      )
      redirect_to item, notice: "Status updated."
    end

    private

    def serialize(item)
      {
        id: item.id,
        name: item.name,
        description: item.description,
        verification_type: item.verification_type,
        is_critical: item.is_critical,
        weight: item.weight,
        documentation_url: item.documentation_url,
        status: item.current_status,
        category: {
          id: item.category.id,
          name: item.category.name
        }
      }
    end
  end
end
