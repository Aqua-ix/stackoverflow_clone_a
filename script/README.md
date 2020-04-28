# override_by_training_src.sh

本リポジトリでは、StackoverflowCloneAの実習完了後のコード以外に、実習開始時のコードを[training_src](../training_src/)で管理している。
このスクリプトはtraining_srcのコードで現在のコードを上書きし、実習開始時のコードを生成するためのものである。

使用方法は下記

```
$ sh override_by_training_src.sh
```

# gen_gear_from_training_src.shについて

gearをAntikythera上にデプロイするためにはgear名がユニークでなければならない。
そのため、複数人で研修を行う場合、gear名は異なるものを用いなければならない。
一方でgear名はmodule名に使われているため、module名も異なるものにしなければならない。

gen_gear_from_training_src.shは指定されたディレクトリに対して内部的にoverride_by_training_src.shを実行した上で、gear名の変更を行なうスクリプトである。

使用方法は下記

* スクリプトの実行
```
$ gen_gear_from_training_src.sh </path/to/new_gear_name> <app_id> <group_id>
```
  * example:
    ```
    $ gen_gear_from_training_src.sh /home/takahashi/src/stackoverflow_team_a a_12345678 g_12345678
    ```
