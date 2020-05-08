use Croma

defmodule StackoverflowCloneA.Repo.Question do
  use AntikytheraAcs.Dodai.Repo.Datastore, [
    datastore_models: [StackoverflowCloneA.Model.Question],
  ]
end