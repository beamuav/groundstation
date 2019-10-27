defmodule Console do
  defstruct history: [],
            messages: [],
            vehicle: %Vehicle{},
            vehicle_updated_at: nil,
            mode: nil,
            opacity: 0,
            open: true
end
