Class Samples.IfindWithSudachi Extends %Persistent
{

Property TextData As %Text(COLLATION = "SQLUPPER", LANGUAGECLASS = "%TextJapanese", MAXLEN = 1000);

Index TextDataIndex On (TextData) As %iFind.Index.Basic(INDEXOPTION = 2, LANGUAGE = "ja", LOWER = 1);

ClassMethod PopulateData() As %Status
{
    do ..%KillExtent()
    kill ^IRIS.IF.WordD
    kill ^IRIS.IF.WordI
    kill ^IRIS.IF.WordCP
    kill ^IRIS.IF.WordRI
    &sql(insert into samples.ifindwithsudachi (Textdata) VALUES ('前月比６４４円高'))
    &sql(insert into samples.ifindwithsudachi (Textdata) VALUES ('さらなる円安が影響'))
    &sql(insert into samples.ifindwithsudachi (Textdata) VALUES ('関東の鉄スクラップ輸出入札'))
    &sql(insert into samples.ifindwithsudachi (Textdata) VALUES ('複数のベンチマークテストを実施した'))
    &sql(insert into samples.ifindwithsudachi (Textdata) VALUES ('2人は公園のベンチに座って、しばらく話をした'))

    quit $$$OK
}

Method %OnBeforeSave(pInsert As %Boolean) As %Status [ Private ]
{
	do ..RegisterWords(..TextData)
  quit $$$OK
}

ClassMethod RegisterWords(textdata As %String) As %Status [ Language = python ]
{
    import iris
    from sudachipy import tokenizer
    from sudachipy import dictionary

    try:

      tokenizer_obj = dictionary.Dictionary().create()
      mode = tokenizer.Tokenizer.SplitMode.A
      
      for m in tokenizer_obj.tokenize(textdata, mode):
        iris._iKnow.Stemming.DecompoundUtils.AddWord('ja',m.surface())
      return 1

    except Exception as e:
        print(e)
        return 1
}

Trigger BeforeSave [ Event = INSERT ]
{
    // get row id of inserted row
    NEW textdata
    SET textdata = {TEXTDATA}
    // Sudachiでテキストを分ち書きし、辞書登録する
    do ..RegisterWords(textdata)
}

Storage Default
{
<Data name="IfindWithSudachiDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TextData</Value>
</Value>
</Data>
<DataLocation>^Samples.IfindWithSudachiD</DataLocation>
<DefaultData>IfindWithSudachiDefaultData</DefaultData>
<IdLocation>^Samples.IfindWithSudachiD</IdLocation>
<IndexLocation>^Samples.IfindWithSudachiI</IndexLocation>
<StreamLocation>^Samples.IfindWithSudachiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
