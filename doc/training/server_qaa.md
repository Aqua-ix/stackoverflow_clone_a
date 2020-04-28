# Q&A

## Dodaiなどのdocumentはどこを参照すればいいですか？

下記を参照ください。
* [Dodai](https://github.com/access-company/Dodai-doc)
* [MongoDB](https://docs.mongodb.com/v3.2/core/document/)
* [Antikythera](https://hexdocs.pm/antikythera/gear_developers.html#content)

## app_idやroot_keyはどのように取得すればいいですか？

下記のようにして取得できます。(`StackoverflowCloneA`部分は各自のgearの名前に応じて変更ください。)
* root key: `StackoverflowCloneA.Dodai.root_key()`
* app key: `StackoverflowCloneA.Dodai.app_key()`
* app_id: `StackoverflowCloneA.Dodai.app_id()`
* group_id: `StackoverflowCloneA.Dodai.default_group_id()`

※上記のように取得できるのは[ここ](../../lib/dodai.ex)で各値を設定しているためです。

## Error Responseを簡単に返す方法はないですか？

APIは様々な理由によりエラーレスポンスを返す場合があります。
例えば、`createQuestion API`において、`title`の長さが101文字以上だった場合などは下記のようなエラーを返すように実装することになります。
* response status: `400`
* response body:
  ```
  {
    "error":       "BadRequest",
    "description": "Unable to understand the request.",
    "code":        "400-06"
  }
  ```

このresponseを返すには下記のようにすればよいです。※1

```
body = %{
  "error"       => "BadRequest",
  "description" => "Unable to understand the request.",
  "code"        => "400-06"
}
json(conn, 400, body)
```

しかし、毎回これを書くのは冗長なので簡潔に記述する方法として下記を用意しています。
* [各errorの定義](../../lib/error.ex)
  * 例えば`BadRequestError`は[ここ](../../lib/error.ex#L35)で定義しています。
* [上記のerrorをもとにerror responseを返すmodule](../../web/helper/error_json.ex)

これらを使えば、※1と同じresponseを返すのは下記のように書くだけですみます。
```
StackoverflowCloneA.Helper.ErrorJson.json_by_error(conn, StackoverflowCloneA.Error.BadRequestError.new())
```

これは`StackoverflowCloneA.Error.BadRequestError.new()`は下記のstructを生成しますが、
```
%StackoverflowCloneA.Error.BadRequestError{
  code:        "400-06",
  description: "Unable to understand the request.",
  name:        "BadRequest",
  source:      "gear"
}
```
`StackoverflowCloneA.Helper.ErrorJson.json_by_error/2`はこの`code`や`description`の値を元に`conn`を組み立ててくれるためです。

## SampleのBook APIなどで使われている`defun`とはなんですか？

[ここ](./croma.md#defunの仕様例)を参照ください。
