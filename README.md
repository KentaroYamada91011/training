## 技術構成の前提
- Docker
- Rails( api mode )
- Next.js
を前提とした技術構成でのアプリケーション作成

## アプリケーションの完成のイメージ
ホーム:

https://github.com/KentaroYamada91011/training/blob/feature/add-README-%23step4/docs/images/screen1.jpg?raw=true

ログイン、サインイン画面:

https://github.com/KentaroYamada91011/training/blob/feature/add-README-%23step4/docs/images/screen2.jpg?raw=true

グループ画面画面:

https://github.com/KentaroYamada91011/training/blob/feature/add-README-%23step4/docs/images/group_function.jpg?raw=true


## モデル図
https://github.com/KentaroYamada91011/training/blob/feature/add-README-%23step4/docs/images/model.png?raw=true


## スキーマ定義
### task
|  カラム  |  データ型  |
| ---- | ---- |
|  id  |  INT  |
|  user_id  |  INT  |
|  title  |  VARCHAR(255)  |
|  description  |  TEXT  |
|  deadline  |  DATETIME  |
|  status  |  INT  |
|  parent_id  |  INT  |

user_idはForeign Key

### user
|  カラム  |  データ型  |
| ---- | ---- |
|  id  |  INT  |
|  name  |  VARCHAR(255)  |
|  email  |  VARCHAR(255)  |
|  password  |  VARCHAR(255)  |
|  role  |  INT  |

### group
|  カラム  |  データ型  |
| ---- | ---- |
|  id  |  INT  |
|  name  |  VARCHAR(255)  |
|  description  |  TEXT  |

### group_user
|  カラム  |  データ型  |
| ---- | ---- |
|  id  |  INT  |
|  user_id  |  INT  |
|  group_id  |  INT  |

user_idとgroup_idはForeign Key
