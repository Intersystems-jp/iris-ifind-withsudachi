# 形態素解析ツール　sudachipyを利用したSQl Searchの実装サンプル

## iFind.Index.Basic

SQL Searchは、元々InterSystems NLP(iKnow)の技術をベースに開発された機能です。
しかし、iKnowが非推奨機能となり、SQL Searchの機能の内、iKnowの機能依存度が少ないiFind.Index.BasicとiFind.Index.Minimumのみがサポートされています。

### iFind.Index.Basicを利用した全文検索機能の制限

この全文検索機能は、日本語の場合は、単語検索というよりは、文字列検索になっており、形態素解析ツールで分解した語幹による検索に比較してノイズが多いという特性があります。

### 形態素解析ツール（Sudachi）を利用した語幹による検索

日本語に関しては、言語の特性上、iKnowの機能を完全に排除することは難しく、本来iFind.Index.BasicではサポートされていないEntity Searchが一部サポートされています。

その機能とSudachiの様な形態素解析ツールを組み合わせることで、形態素単位での検索を実装できます。

SudachiはPythonによる実装も提供されているためIRISでの実装も比較的容易なので、今回サンプル実装してみました。

## セットアップ方法

### gitクローン

* ```git clone https://github.com/intersystems-jp/iris-ifind-withsudachi.git```

### Docker ビルドプロセス

### ビルド&実行

```docker-compose up -d --build```      

を実行

### ローカルインストール(WindowsやMacOSにインストールしたIRISでセットアップする)

#### Python sudachiパッケージのインストール

--targetは環境により異なる

```
python3 -m pip install --upgrade　--target c:¥Intersystems¥iris¥mgr¥python sudachipy
python3 -m pip install --upgrade　--target c:¥Intersystems¥iris¥mgr¥python sudachidict_core
```

#### Sampleクラスのロード

ターミナルでログイン

```
>zn "USER"
>set file = "c:\git\iris-ifind-withsudachi\src\Samples\IfindWithSudachi.cls"
>Do $system.OBJ.Import(file,"ck")
```

#### サンプルデータの生成

```
>zn "USER"
>do ##class(Samples.IfindWithSudachi).LoadData()
```

#### クエリーの実行

管理ポータル等で以下のようなSQLを呼び出す。

```
select * from Samples.IfindWithSudachi where %ID %FIND search_index(TextDataIndex,'{輸出}',2)
```


