# frozen_string_literal: true

json.extract!(@report, :id, :date, :dog, :time, :weather, :recap, :pees,
              :poops, :energy, :vocalization, :overall, :created_at,
              :updated_at)
