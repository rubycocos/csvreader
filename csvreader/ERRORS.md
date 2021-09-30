# Errors / Error Recovery / Auto-Fixes



###  Quoted Value with Trailing Data   (Auto-Fixed)

```
Farrokh,"Freddy" Mercury,Bulsara
```

See `"Freddy" Mercury` for example. 

How to handle?

Add new rule! 
If quoted value is followed by more data auto-add all the data 
until hitting the separator (that is, comma) 
and turn the quotes into "literal" quotes as part of the value.











