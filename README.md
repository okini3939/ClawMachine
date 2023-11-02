# Claw Machine

ジャンクのクレーンゲーム（UFOキャッチャー的なもの）マシーンで遊ぶ。

ジャンクのため、ものによってはこのページに記載の情報と違うことがあると思われるため、各自の実物に合わせて工夫してください。

## マシン概要

- X-Y-Z軸：リバーシブルモーター、ギヤード、コンデンサ外付け
  - 横河サーテック RM-C6A2 ? (AC100V 0.15A)
  - 接続する端子により正転／逆転の切り替えができる
- 爪：ステッピングモーター、ギヤード
  - 三龍社 P43EBG ? (12V)
  - http://www.sanryusha.co.jp/business/motor/pdf/P43_EXTERNAL_GEAR.pdf
- リミットセンサー：フォトインタラプタ（たぶんDC5V）
  - フォトインタラプタを遮ることによる各軸のリミット検出。
  - オープンコレクタ出力（通常時ON、リミット検出でOFF）

ジャンクで購入した状態では各所がバラされているためまずは組み立てます。

X-Y-Zの機構部分しかないため、アルミや木材等、適当な材料で外枠となるフレームを作りましょう。

<img src="https://github.com/okini3939/ClawMachine/raw/main/images/frame01.jpg" alt="フレーム全景" />

## ピンアサイン

フレーム上部へ出ている配線コネクタの接続。

配線が切断されている個所が異なるので、必要に応じて配線の接続先を確認してください。

<img src="https://github.com/okini3939/ClawMachine/raw/main/images/wire01.jpg" alt="配線" width="250" height="250" />

[カッコ]内は、コネクタの手前側（マシン側）の配線の色です。（たぶんこれは統一されているはず）

### X軸

```
+--+--+--+--+
| 1| 2| 3| 4|
+--+--+--+--+
| 5| 6| 7| 8|
+--+--+--+--+
```

1. [黄] X軸 センサー 電源＋
2. [青] X軸 センサー Right
3. [緑] X軸 センサー Left
4. [白] X軸 センサー 電源－
5. [青] X軸 モーター BLK (CCW)
6. [橙] X軸 モーター YEL (CW)
7. [うす緑] X軸 モーター GRE (Com)
8. 未接続

### Y-Z軸

```
+--+--+--+--+
| 1| 2| 3| 4|
+--+--+--+--+
| 5| 6| 7| 8|
+--+--+--+--+
| 9|10|11|12|
+--+--+--+--+
```

1. [黄] YZ軸 センサー 電源＋
2. [橙/白] Y軸 センサー Rear
3. [黒/白] Y軸 センサー Front
4. [灰/白] Z軸 センサー Bottom ※Z軸が底についてテンションがかからなくなるとON
5. [茶/白] Z軸 センサー Top
6. [白] YZ軸 センサー 電源－
7. [黒] Y軸 モーター BLK (CCW)
8. [灰] Y軸 モーター YEL (CW)
9. [うす緑] Y軸 モーター GRE (Com)
10. [茶] Z軸 モーター BLK (CCW)
11. [紫] Z軸 モーター YEL (CW)
12. [うす緑] Z軸 モーター GRE (Com)

### 爪（アーム）

```
+--+--+--+
| 1| 2| 3|
+--+--+--+
| 4| 5| 6|
+--+--+--+
| 7| 8| 9|
+--+--+--+
```

1. [黄] 爪 センサー 電源＋
2. [うす緑] 爪 センサー Open
3. [白] 爪 センサー 電源－
4. [赤/黒] 爪 モーター Yellow
5. [緑/黒] 爪 モーター Black
6. [橙/黒] 爪 モーター Blue
7. [うす緑/黒] 爪 モーター White
8. [緑/白] 未接続 （筐体アース）
9. 未接続

## 制御回路

### X-Y-Z コントローラー

X-Y軸はベルト駆動のリニアアクチュエータ、Z軸はワイヤーで吊られていて重力で降りてきます。

リバーシブルモーターは3つの線が出ており、コンデンサとAC100Vを接続する配線を変えることにより回転方向を変えることができます。

<img src="https://github.com/okini3939/ClawMachine/raw/main/images/motor01.jpg" alt="リバーシブルモーター" width="250" height="250" />

<img src="https://github.com/okini3939/ClawMachine/raw/main/images/motor02.jpg" alt="モーター用コンデンサ" width="250" height="250"
/> <img src="https://github.com/okini3939/ClawMachine/raw/main/images/sensor01.jpg" alt="リミットセンサー" />

スイッチで簡単にコントロールしてもよいけども、リミット検出もしたいのでリレーとトランジスタを使い、マイコンなしで作れる回路を考えてみました。

<img src="https://github.com/okini3939/ClawMachine/raw/main/images/clawmachine_xyz.png" alt="回路図 X-Y-Z" />

- PNPトランジスタは 2SA1015 など
- リレーは1回路2接点、電圧12Vのものを使ったが各自適当に
- モーターの電源にAC100Vを扱うので製作は慎重に **＜感電やショートに注意＞**

<img src="https://github.com/okini3939/ClawMachine/raw/main/images/pcb01.jpg" alt="基板 X-Y-Z" width="250" height="250"
/> <img src="https://github.com/okini3939/ClawMachine/raw/main/images/pcb02.jpg" alt="基板 X-Y-Z" />

ジョイスティック（アーケードコントローラー）などでコントロールするとよさそう。

### 爪 コントローラー

ジャンクで爪はついていないので、自分で何かを作ってつける必要があります。

爪はステッピングモーターとラックアンドピニオンで動いています。

<img src="https://github.com/okini3939/ClawMachine/raw/main/images/motor03.jpg" alt="ステッピングモーター" width="250" height="250"
/> <img src="https://github.com/okini3939/ClawMachine/raw/main/images/motor05.jpg" alt="爪の機構" width="250" height="250" />

開ききったところでリミットセンサーが働き、閉じる方向へはモーターのステップ数でどれだけ戻すかを制御しています。

戻す量によりバネの伸び率が変わり、爪がつかむ強さをコントロールしているようです。

ステッピングモーターを使う都合上、マイコンを使用します。

<img src="https://github.com/okini3939/ClawMachine/raw/main/images/clawmachine_claw.png" alt="回路図 Claw" />

- ステッピングモータードライバは Sparkfun EasyDriver (A3967)
  - https://www.sparkfun.com/products/12779
  - DIR（回転方向）と STEP（回転指示）でコントロールできる便利なIC
  - 似たようなドライバICはいろいろあるので何でもよい
- マイコンは Raspberry Pi Pico
  - https://www.raspberrypi.com/products/raspberry-pi-pico/
  - もちろん各自の使いやすいマイコンでよい
- MachiKania type P というBASICシステムを入れてプログラムした
  - http://www.ze.em-net.ne.jp/~kenken/machikania/typep.html
  - 最小構成でプログラム埋め込み済みのuf2イメージファイル： <a href="https://github.com/okini3939/ClawMachine/raw/main/machikap/result.uf2">result.uf2</a>
  - Raspberry Pi Pico のBOOTSELを押しながら起動し、ドライブへ result.uf2 を書き込むだけでOK

<img src="https://github.com/okini3939/ClawMachine/raw/main/images/pcb03.jpg" alt="基板 Claw" width="250" height="250"
/> <img src="https://github.com/okini3939/ClawMachine/raw/main/images/pcb04.jpg" alt="基板 Claw" width="250" height="250" />

### 備考

Z軸のワイヤーがプーリーから外れていることがあるのであらかじめ確認しておきましょう。

<img src="https://github.com/okini3939/ClawMachine/raw/main/images/motor04.jpg" alt="Z軸のワイヤー" width="250" height="250" />

