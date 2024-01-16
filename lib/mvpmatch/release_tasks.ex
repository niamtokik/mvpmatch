defmodule Mvpmatch.ReleaseTasks do
  def eval_purge_stale_data() do
    Application.ensure_all_started(:mvpmatch)
  end
end
