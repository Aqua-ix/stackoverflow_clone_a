use Croma

defmodule StackoverflowCloneA.ErrorBuilder do
  defmacro deferror(code, mod, desc) do
    quote do
      defmodule unquote(mod) do
        @code unquote(code)
        @name Module.split(unquote(mod)) |> List.last()
        @desc unquote(desc)

        use Croma.Struct, recursive_new?: true, fields: [
          code:        Croma.String,
          name:        Croma.String,
          description: Croma.String,
          source:      Croma.String,
        ]

        defun new() :: t do
          %__MODULE__{
            code:        @code,
            name:        @name,
            description: @desc,
            source:      "gear",
          }
        end
      end
    end
  end
end

defmodule StackoverflowCloneA.Error do
  alias StackoverflowCloneA.ErrorBuilder
  require ErrorBuilder

  ErrorBuilder.deferror("400-06", BadRequest       , "Unable to understand the request.")
  ErrorBuilder.deferror("401-00", InvalidCredential, "The given credential is invalid.")
  ErrorBuilder.deferror("401-01", Unauthorized     , "The given email, user name and/or password are incorrect.")
  ErrorBuilder.deferror("404-04", ResourceNotFound , "The resource does not exist in the database.")
  ErrorBuilder.deferror("409-03", ConflictingUpdate, "The document version your request is based on is outdated. Check 'currentVersion' for the content of the current document.")
end
