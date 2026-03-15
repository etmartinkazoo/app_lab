module AppLab
  module Api
    module V1
      class PracticesController < BaseController
        def checklist
          categories = BestPracticeCategory.ordered.includes(best_practice_items: :best_practice_checks)
          render json: categories.map { |c|
            {
              name: c.name, completion: c.completion_percentage,
              items: c.best_practice_items.map { |i|
                { id: i.id, name: i.name, status: i.current_status, verification_type: i.verification_type }
              }
            }
          }
        end

        def verify
          item = BestPracticeItem.find(params[:item_id])
          BestPracticeVerificationJob.perform_later
          render json: { status: "verification_queued" }
        end

        def check
          item = BestPracticeItem.find(params[:item_id])
          status = params[:status] || (item.current_status == "passed" ? "failed" : "passed")
          item.best_practice_checks.create!(status: status, checked_at: Time.current)
          render json: { status: "updated", new_status: status }
        end

        def score
          snapshot = BestPracticeSnapshot.recent.first
          render json: {
            overall_score: snapshot&.overall_score || 0,
            grade: snapshot&.health_grade || "F",
            categories: BestPracticeCategory.ordered.map { |c| { name: c.name, score: c.completion_percentage } }
          }
        end

        def history
          snapshots = BestPracticeSnapshot.recent.limit(30)
          render json: snapshots.map { |s|
            { date: s.captured_at, score: s.overall_score, grade: s.health_grade }
          }
        end
      end
    end
  end
end
