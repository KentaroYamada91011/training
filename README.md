## アプリケーションの完成のイメージ
ホーム:

https://github.com/KentaroYamada91011/training/blob/feature/add-README-%23step4/docs/images/screen1.jpg?raw=true

ログイン、サインイン画面:

https://github.com/KentaroYamada91011/training/blob/feature/add-README-%23step4/docs/images/screen2.jpg?raw=true

グループ画面画面:

https://github.com/KentaroYamada91011/training/blob/feature/add-README-%23step4/docs/images/group_function.jpg?raw=true


## モデル図
https://github.com/KentaroYamada91011/training/blob/feature/add-README-%23step4/docs/images/model.jpg?raw=true


## スキーマ定義
tasks
|  カラム  |  データ型  |
| ---- | ---- |
|  id  |  varchar  |
|  user_id  |  integer  |
|  title  |  varchar  |
|  description  |  text  |
|  deadline  |  datetime  |
|  status  |  integer  |
|  parent_id  |  integer  |

users
|  カラム  |  データ型  |
| ---- | ---- |
|  id  |  integer  |
|  name  |  varchar  |
|  email  |  varchar  |
|  password  |  varchar  |
|  role  |  integer  |

groups
|  カラム  |  データ型  |
| ---- | ---- |
|  id  |  integer  |
|  name  |  varchar  |
|  description  |  text  |

group_users
|  カラム  |  データ型  |
| ---- | ---- |
|  id  |  integer  |
|  user_id  |  integer  |
|  group_id  |  integer  |
