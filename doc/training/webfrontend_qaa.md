# Q&A

## 画像を利用したい場合どうすればいいですか？

- [imagesフォルダ](../../web/static/assets/images)の中に画像を置くとcssからurl()を利用して読み込めます。[Header/style.scss](../../web/static/app/components/Header/style.scss)で利用しているので参考にしてください。
- デプロイ時にreactファイルはwebpackでのビルドでまとめられてURL上の位置が変わるので、[url-loader](https://github.com/webpack-contrib/url-loader)を利用して画像をbase64 Urlとしてビルド時に埋め込んでいます。
  - 本来は大きな画像をbase64 Urlとして埋め込むのは良くないですが、演習の構造をシンプルにするためこの方法のみを提供しています。
