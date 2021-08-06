# HomFA

## 01tobin.rb

01 のテキストを HomFA が平文として受け付けるバイナリ列に変換する。
入力データは 8 の倍数である必要がある。

### Usage

引数に AP の数を渡す。

```
$ ruby 01tobin.rb NUM-AP
```

### Example

```sh
# APが2つ（p0, p1）のときに、(p0, p1) = (0, 0), (0, 1), (1, 0), (1, 1)なる
# データ列を作る。echoの-nは末尾の改行を取り除くために必要
$ echo -n "00011011" | ruby 01tobin.rb 2
```

## symglucose_csv_to_01.rb

symglucose のシミュレーション結果である CSV ファイルを 01tobin.rb が受け付ける 01
表記に変換する。

### Usage

第一引数に bg か dbg を渡す。bg は血糖値、dbg は血糖値の差分のデータを出力する。
第二引数に CSV ファイルを指定する。

bg の場合、最小値が 0、最大値が 310、間が 10 で離散化される。AP の数は 5。

dbg の場合、最小値が-16、最大値が 15、間が 1 で離散化される。AP の数は 5。

```
$ ruby symglucose_csv_to_01.rb [bg|dbg] FILE
```

### Example

```
$ ruby main.rb bg results/2021-07-28_13-57-35/adult\#001.csv
$ ruby main.rb dbg results/2021-07-28_13-57-35/adult\#001.csv

# データのうち、始め100行のみを使う。出力結果を01tobin.rbに流し込んで、HomFA用のデータを得る。
$ ruby main.rb bg <(cat results/2021-07-28_13-57-35/adult\#001.csv | head -100) | ruby ../01tobin.rb 5
```
