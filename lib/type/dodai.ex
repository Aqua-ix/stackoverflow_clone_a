use Croma

defmodule StackoverflowCloneA.DodaiId do
  # See [RFC3986](https://tools.ietf.org/html/rfc3986#section-2.3) for the specifications of URL-safe characters
  @url_safe_chars "0-9A-Za-z\-._~"
  use Croma.SubtypeOfString, pattern: ~r"\A[#{@url_safe_chars}]+\Z"
end
