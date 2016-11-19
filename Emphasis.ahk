#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1

; Reference: https://mothereff.in/twitalics
; Default
arr_d := StrSplit("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
; Sans serif bold
hash_ssb := Hash(StrSplit("𝗮,𝗯,𝗰,𝗱,𝗲,𝗳,𝗴,𝗵,𝗶,𝗷,𝗸,𝗹,𝗺,𝗻,𝗼,𝗽,𝗾,𝗿,𝘀,𝘁,𝘂,𝘃,𝘄,𝘅,𝘆,𝘇,𝗔,𝗕,𝗖,𝗗,𝗘,𝗙,𝗚,𝗛,𝗜,𝗝,𝗞,𝗟,𝗠,𝗡,𝗢,𝗣,𝗤,𝗥,𝗦,𝗧,𝗨,𝗩,𝗪,𝗫,𝗬,𝗭", ","), arr_d)
; Sans serif italic
hash_ssi := Hash(StrSplit("𝘢,𝘣,𝘤,𝘥,𝘦,𝘧,𝘨,𝘩,𝘪,𝘫,𝘬,𝘭,𝘮,𝘯,𝘰,𝘱,𝘲,𝘳,𝘴,𝘵,𝘶,𝘷,𝘸,𝘹,𝘺,𝘻,𝘈,𝘉,𝘊,𝘋,𝘌,𝘍,𝘎,𝘏,𝘐,𝘑,𝘒,𝘓,𝘔,𝘕,𝘖,𝘗,𝘘,𝘙,𝘚,𝘛,𝘜,𝘝,𝘞,𝘟,𝘠,𝘡", ","), arr_d)
return

; START OF FUNCTIONS

Hash(emphasis, default) {
	e := emphasis.clone()
	d := default.clone()
	hash := ComObjCreate("Scripting.Dictionary")
	Loop, % d.MaxIndex() {
		hash.item(d[A_Index]) := e[A_Index]
	}
	return hash
}

Convert(hash) {
	backup := ClipboardAll
	Clipboard = ; Clear Clipboard so ClipWait can see change.

	Send, ^{c}
	ClipWait, 0

	parse := StrSplit(Clipboard)
	arr := Object()
	str =
	Loop, % parse.MaxIndex()
	{
		if % RegExMatch(parse[A_Index], "[a-zA-Z]")
		{
			str .= hash.item(parse[A_Index])
		}
		else if % parse[A_Index] == "`r"
		{
			continue
		}
		else if % parse[A_Index] == "`n"
		{
			arr.Insert(str)
			str =
			arr.Insert("+{ENTER}")
		}
		else
		{
			str .= parse[A_Index]
		}
	}

	arr.Insert(str)
	Loop, % arr.MaxIndex()
	{
		Send, % arr[A_Index]
	}

	Clipboard := backup
	backup = ; Free memory.
	return
}
; END OF FUNCTIONS

; START OF HOTKEYS

^b::
	Convert(hash_ssb)
return

^i::
	Convert(hash_ssi)
return

Escape::
	ExitApp
return
; END OF HOTKEYS
