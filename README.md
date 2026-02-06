🛠 人員配置支援サービス『配神（はいしん）』<br>
▼アプリの概要
建設現場の複雑な人員・車両配置を、直感的な操作で最適化し、ワンタップで見やすいPDF資料としてLINE送信できる、「現場管理者のための配置革命」サービスです。<br>

画面キャプチャ
<img width="1901" height="991" alt="Image" src="https://github.com/user-attachments/assets/bf65212e-1897-4f29-9aec-eb622ba9325c" /><br>

▼アプリの使い方/基本的な操作方法
1. 配置を完成させる：その日の現場ごとに、メンバーと車両をぽちぽちと直感的に配置します。
2. PDF保存ボタンをタップ：ボタン1つで、プロ品質のレイアウトが整った配置図が自動生成されます。
3. LINEで一括送信：生成されたPDFをそのままLINEグループに送信。これだけで1週間の配置連絡が完了します。<br>

▼なぜ作ったか（開発の動機・背景）
* 「超長文LINE」からの解放：代表が20名近くの従業員と多数の現場がある場合、毎日の配置連絡をテキストで打つだけで数時間を要し、精神的な負担になっていました。
* アナログ作業の限界：現場名、名前、車両のコピー＆ペーストを繰り返す終わりのない作業を効率化したいという切実な声から生まれました。
* 休息時間の確保：事務作業に削られていた父の休息時間を取り戻し、より重要な業務に集中できる環境を作るためです。
  
▫︎既存の人員配置イメージ動画<br>
https://github.com/user-attachments/assets/a306693c-ff40-4ed0-b456-233325f2dc3c<br>

▼工夫した所（技術的なこだわりポイント）
* 現場の「生の声」に応える備考機能：「現場の鍵は〇〇さんから」「工具は必ず持ち帰り」など、忘れがちな重要事項を現場ごとに柔軟にメモできる機能を搭載しました。
* 受信側の視認性向上：受け取る従業員にとっても、「見やすく、わかりやすい」と感じるプロ品質のPDFレイアウトにこだわっております。
* LINE連携の簡略化：長文テキストを打つ手間を一切排除し、PDFを送信するだけの簡単3ステップに集約しました。
⭐︎簡単3ステップ
1. 配置を完成させる
2. PDF保存ボタンをタップ
3. LINEで一括送信<br>

▼ER図<br>
erDiagram
    USER ||--o{ SITE : "creates"
    USER ||--o{ MEMBER : "manages"
    USER ||--o{ VEHICLE : "manages"

    SITE ||--o{ PLACEMENT : "has"
    MEMBER ||--o{ PLACEMENT : "is assigned to"
    
    SITE ||--o{ VEHICLE_ASSIGNMENT : "has"
    VEHICLE ||--o{ VEHICLE_ASSIGNMENT : "is assigned to"

    USER {
        bigint id PK
        string name
        string email
        string password_digest
    }

    SITE {
        bigint id PK
        string name
        string address
        integer position "For reordering"
        bigint user_id FK
    }

    MEMBER {
        bigint id PK
        string name
        string role
        bigint user_id FK
    }

    VEHICLE {
        bigint id PK
        string name
        string car_number
        bigint user_id FK
    }

    PLACEMENT {
        bigint id PK
        date date
        bigint site_id FK
        bigint member_id FK
    }

    VEHICLE_ASSIGNMENT {
        bigint id PK
        date date
        bigint site_id FK
        bigint vehicle_id FK
    }
