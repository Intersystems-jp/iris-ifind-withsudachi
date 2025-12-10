Class Text.JapaneseSudachi Extends %Text.Japanese
{

Parameter NOISEWORDS100 = "これ それ あれ この その あの ここ そこ あそこ こちら どこ だれ なに なん 何 私 貴方 貴方方 我々 私達 あの人 あのかた 彼女 彼 です あります おります います から まで より どの それで しかし";

Parameter FILTERNOISEWORDS = 1;

Parameter NGRAMLEN = 1;

Parameter MINWORDLEN = 1;

ClassMethod DivideWords(textdata As %String) As %String [ Language = python ]
{
    import iris
    from sudachipy import tokenizer
    from sudachipy import dictionary

    try:

      tokenizer_obj = dictionary.Dictionary().create()
      mode = tokenizer.Tokenizer.SplitMode.C

      returnWords = [m.surface() for m in tokenizer_obj.tokenize(textdata, mode)]
      return ' '.join(returnWords)

    except Exception as e:
        print(e)
        return ""
}

ClassMethod SeparateWords(rawText As %String) As %String [ SqlProc ]
{
  	
  Quit ..DivideWords(rawText)
}

ClassMethod ExcludeCommonTerms(nTerms) As %Status
{
	k ^%SYSDict(-..#DICTIONARY)
	//Full width Hiragana
	f ascii=12353:1:12435 set ^%SYSDict(..#DICTIONARY,$$$noiseword,$C(ascii))=""
	//Full width Katakana
	f ascii=12449:1:12531 set ^%SYSDict(..#DICTIONARY,$$$noiseword,$C(ascii))=""
	//Half width Katanaka
	f ascii=65393:1:65439 set ^%SYSDict(..#DICTIONARY,$$$noiseword,$C(ascii))=""

	//Half width English
	//f ascii=65:1:90 set ^%SYSDict(..#DICTIONARY,$$$noiseword,$C(ascii))=""
	//f ascii=97:1:122 set ^%SYSDict(..#DICTIONARY,$$$noiseword,$C(ascii))=""

	//Numbers
	//f ascii=48:1:57 set ^%SYSDict(..#DICTIONARY,$$$noiseword,$C(ascii))=""

	//Full width English and so on..
	f ascii=65281:1:65392 set ^%SYSDict(..#DICTIONARY,$$$noiseword,$C(ascii))=""

	// Japanese punctuation marks
	set splitchars = $listbuild(12289,12290,12300,12301,8220,8221)
		
	for ascii=1:1:$listlength(splitchars) {
	    set ^%SYSDict(..#DICTIONARY,$$$noiseword,$C($list(splitchars,ascii)))=""
	}

	s maxW=$s(nTerms>100:100,1:nTerms)     for w=1:1:maxW { do ..AddToDictionary($p(..#NOISEWORDS100," ",w),0,0,"") }
	s maxW=$s(nTerms>200:100,1:nTerms-100) for w=1:1:maxW { do ..AddToDictionary($p(..#NOISEWORDS200," ",w),0,0,"") }
	s maxW=$s(nTerms>300:100,1:nTerms-200) for w=1:1:maxW { do ..AddToDictionary($p(..#NOISEWORDS300," ",w),0,0,"") }
	s maxW=$s(nTerms>100:100,1:nTerms)     for w=1:1:maxW { do ..AddToDictionary($p(..#NOISEBIGRAMS100,",",w),0,0,"") }
	s maxW=$s(nTerms>200:100,1:nTerms-100) for w=1:1:maxW { do ..AddToDictionary($p(..#NOISEBIGRAMS200,",",w),0,0,"") }
	s maxW=$s(nTerms>300:100,1:nTerms-200) for w=1:1:maxW { do ..AddToDictionary($p(..#NOISEBIGRAMS300,",",w),0,0,"") }	

	QUIT $$$OK
}

}
