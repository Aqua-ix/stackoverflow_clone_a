# `Croma`の使用例

## `Croma.Struct`の使用例

`Croma.Struct`を用いることでStructの各fieldの制約などを宣言的に定義し、その制約に応じて値をvalidationすることができる関数(`new/1`)を自動生成することができる。
具体的な使用例は下記である。
```
defmodule Hoge do
  use Croma.Struct, fields: [
    foo: Croma.String,  # foo fieldがbinary型として宣言
    bar: Croma.Integer, # bar fieldがinteger型として宣言
  ]
end

# 上記で宣言した制約を満たすmap
valid_map = %{
 "foo" => "string",
 "bar" => 5
}

> Hoge.new(valid_map)
{:ok, %Hoge{bar: 5, foo: "string"}}

# 上記で宣言した制約を満たさないmap
invalid_map = %{
 "foo" => "string",
 "bar" => "not integer"
}

> Hoge.new(invalid_map)
{:error, {:invalid_value, [Hoge, {Croma.Integer, :bar}]}}
```
fieldの型として宣言できるもの(`Croma.String`など)は[ここ](https://github.com/skirino/croma/blob/master/lib/croma/builtin_type.ex)を参照。

fieldの型として独自の制約を作ることもできる。
例えば、field `foo`は数字3桁で文字列でなければならないといった制約は[これ](https://github.com/skirino/croma/blob/master/lib/croma/subtype.ex)を利用して下記のようにかける。
```
defmodule Hoge do
  defmodule ThreeNumberStr do
    use Croma.SubtypeOfString, pattern: ~r/^[1-9]{3}$/ # binary型かつ正規表現で数字3桁のフォーマットであると宣言
  end
  use Croma.Struct, fields: [
    foo: ThreeNumberStr, # foo fieldとしてThreeNumberStrであることを宣言
    bar: Croma.Integer,  # bar fieldがinteger型として宣言
  ]
end

# 上記で宣言した制約を満たすmap
valid_map = %{
 "foo" => "123",
 "bar" => 5
}

> Hoge.new(valid_map)
{:ok, %Hoge{bar: 5, foo: "123"}}

# 上記で宣言した制約を満たさないmap
valid_map = %{
 "foo" => "1234",
 "bar" => "string"
}

> Hoge.new(invalid_map)
{:error, {:invalid_value, [Hoge, {Hoge.ThreeNumberStr, :foo}]}}
```

fieldとして値が必須であるかどうかは[`Croma.TypeGen`](https://github.com/skirino/croma/blob/master/lib/croma/type_gen.ex)によって制御できる。
例えば、`foo`が必須で`bar`はオプションであるstructは下記のように書けば良い。
```
use Croma
defmodule Hoge do
  use Croma.Struct, fields: [
    foo: Croma.String,                        # 必須
    bar: Croma.TypeGen.nilable(Croma.String), # オプショナル
  ]
end

# 上記で宣言した制約を満たすmap
valid_map = %{
 "foo" => "string"
}

> Hoge.new(valid_map)
{:ok, %Hoge{bar: nil, foo: "string"}}

# 上記で宣言した制約を満たさないmap
invalid_map = %{}

> Hoge.new(invalid_map)
{:error, {:value_missing, [Hoge, {Croma.String, :foo}]}}
```

## `defun`の仕様例

[`defun`](https://github.com/skirino/croma/blob/master/lib/croma/defun.ex)を使うことで、関数の定義とそのtypespec定義を同時に行なうことができます。
通常、関数とそのtypespecの定義は下記のように行います。
```
@spec f(integer, String.t) :: String.t
def f(a, b) do
  "\#{a} \#{b}"
end
```
上記では、最初の行で関数`f/2`のtypespecを定義し、続く2~4行目で関数の本体を定義しています。
`defun`を利用することで、この1行目と2行目をまとめて宣言できることで、簡潔に記述できます。
```
defun f(a :: integer, b :: String.t) :: String.t do
  "\#{a} \#{b}"
end
```

なお、`defp`に関しても同様のことが`defunp`を用いて実現できます。
