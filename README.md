## アプリケーションの完成のイメージ
ホーム:

https://github.com/KentaroYamada91011/training/blob/feature/add-README-%23step4/docs/images/screen1.jpg?raw=true

ログイン、サイインイン画面:

https://github.com/KentaroYamada91011/training/blob/feature/add-README-%23step4/docs/images/screen2.jpg?raw=true

## モデル図
https://github.com/KentaroYamada91011/training/blob/feature/add-README-%23step4/docs/images/model.png?raw=true

## スキーマ定義
tasks
|  カラム  |  データ型  |
| ---- | ---- |
|  id  |  integer  |
|  user_id  |  integer  |
|  title  |  string  |
|  description  |  text  |
|  deadline  |  datetime  |
|  status  |  integer  |
|  parent_id  |  integer  |

users
|  カラム  |  データ型  |
| ---- | ---- |
|  id  |  integer  |
|  name  |  string  |
|  email  |  string  |
|  password  |  string  |
|  role  |  integer  |

groups
|  カラム  |  データ型  |
| ---- | ---- |
|  name  |  string  |
|  description  |  text  |

group_users
|  カラム  |  データ型  |
| ---- | ---- |
|  user_id  |  integer  |
|  group_id  |  integer  |
