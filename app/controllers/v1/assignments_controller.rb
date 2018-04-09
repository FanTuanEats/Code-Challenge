class V1::AssignmentsController < ApiController
    def index
        super
    end

    private
    def order_param
        "created_at asc"
    end

    def filter_params
        conditions = []

        conditions << "assignments.delivery_zone_id = ?" if params[:zone_id]
        conditions << "assignments.date = ?" if params[:day]

        fp = []
        fp << conditions.join(" AND ") if conditions.length > 0

        fp << params[:zone_id].to_s if params[:zone_id]
        fp << params[:day] if params[:day]

        fp
    end
end