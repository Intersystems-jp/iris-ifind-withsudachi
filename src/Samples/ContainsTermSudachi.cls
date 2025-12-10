Class Samples.ContainsTermSudachi Extends %Persistent
{

// 以下のようなクエリーを発行できる

// select * from Samples.ContainsTermSudachi where TextData %Containsterm('輸出')

/// データ
Property TextData As %Text(COLLATION = "SQLUPPER", LANGUAGECLASS = "Text.JapaneseSudachi", MAXLEN = 1000);

Index TextIndex On TextData(KEYS) [ Type = bitmap ];

ClassMethod PopulateData() As %Status
{
    do ..%KillExtent()
    &sql(insert into samples.containstermsudachi (Textdata) VALUES ('前月比６４４円高'))
    &sql(insert into samples.containstermsudachi (Textdata) VALUES ('さらなる円安が影響'))
    &sql(insert into samples.containstermsudachi (Textdata) VALUES ('関東の鉄スクラップ輸出入札'))
    &sql(insert into samples.containstermsudachi (Textdata) VALUES ('複数のベンチマークテストを実施した'))
    &sql(insert into samples.containstermsudachi (Textdata) VALUES ('2人は公園のベンチに座って、しばらく話をした'))

    quit $$$OK
}

Storage Default
{
<Data name="ContainsTermSudachiDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TextData</Value>
</Value>
</Data>
<DataLocation>^Samples.ContainsTermSudachiD</DataLocation>
<DefaultData>ContainsTermSudachiDefaultData</DefaultData>
<IdLocation>^Samples.ContainsTermSudachiD</IdLocation>
<IndexLocation>^Samples.ContainsTermSudachiI</IndexLocation>
<StreamLocation>^Samples.ContainsTermSudachiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
