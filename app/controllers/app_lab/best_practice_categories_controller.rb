module AppLab
  class BestPracticeCategoriesController < ApplicationController
    def index
      categories = BestPracticeCategory.ordered.includes(best_practice_items: :best_practice_checks)
      render_inertia "Practices/Index", props: {
        categories: categories.map { |c| serialize_category(c) },
        overall_score: overall_score
      }
    end

    def show
      category = BestPracticeCategory.find(params[:id])
      render_inertia "Practices/Show", props: {
        category: serialize_category(category),
        items: category.best_practice_items.map { |i| serialize_item(i) }
      }
    end

    def score
      render json: {
        overall_score: overall_score,
        categories: BestPracticeCategory.ordered.map { |c|
          { name: c.name, score: c.completion_percentage }
        }
      }
    end

    def history
      snapshots = BestPracticeSnapshot.recent.limit(30)
      render json: snapshots.map { |s|
        {
          date: s.captured_at,
          score: s.overall_score,
          grade: s.health_grade,
          category_scores: s.category_scores
        }
      }
    end

    private

    def serialize_category(category)
      {
        id: category.id,
        name: category.name,
        description: category.description,
        icon: category.icon,
        item_count: category.best_practice_items.size,
        completion: category.completion_percentage
      }
    end

    def serialize_item(item)
      {
        id: item.id,
        name: item.name,
        description: item.description,
        verification_type: item.verification_type,
        is_critical: item.is_critical,
        weight: item.weight,
        documentation_url: item.documentation_url,
        status: item.current_status,
        latest_check: item.latest_check&.then { |c|
          { status: c.status, checked_at: c.checked_at, checked_by: c.checked_by, auto_verified: c.auto_verified }
        }
      }
    end

    def overall_score
      snapshot = BestPracticeSnapshot.recent.first
      snapshot&.overall_score || 0
    end
  end
end
