## アプリケーションの完成のイメージ
ホーム:

ログイン、サイインイン画面:

## モデル図


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
