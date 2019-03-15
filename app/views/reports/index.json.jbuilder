# frozen_string_literal: true

json.array!(@reports) do |report|
  json.extract!(report, :id, :date, :dog, :time, :weather, :recap, :pees,
                :poops, :energy, :vocalization, :overall)
  json.url report_url(report, format: :json)
end
