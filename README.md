#dictionary-rb

Provides meanings, similar words, usage examples from [Urban Dictionary](http://urbandictionary.com) and [Dictionary Reference](http://dictionary.reference.com/) with **CLI** support.

##Installation

`gem install dictionary-rb`


##Documentation
Detailed documentation is [available here](http://rubydoc.info/gems/dictionary-rb).

##Usage
--------

```ruby
require 'dictionary-rb'
include DictionaryRB
word = Word.new('pudding')
word.meaning
#=> "a thick, soft dessert, typically containing flour or some other thickener, milk, eggs, a flavoring, and sweetener"

#I shall haz more meanings
word.meanings
#=> ["a thick, soft dessert, typically containing flour or some other thickener, milk, eggs, a flavoring, and sweetener", "a similar dish unsweetened and served with or as a main dish", "British",.. ]


#Find urban dictionary meaning instead:
word.urban_meaning
#=> "a desert given to kids who eat their meat"


#Do more with them
word.urban.examples
#=> ["eat your meat! how can you have any pudding if you dont eat your meat?!", "  Oh, no! Get the pudding,here comes a gang of Leprechauns and children.", "Adrian says, \"I like pudding.\"", "My cousin is a whore...I think I'll name her Pudding."..]

word.dictionary.examples
#=> ["Turn into an earthen pudding-dish, cover, and cook slowly three and one-half hours.", "Turn in a buttered pudding-dish, and bake thirty-five minutes in a slow oven.", "The proof is in the pudding and if people want to make themselves feel better  for bottle feeding they can go ahead.",..]

word.urban.synonyms
#=>[ "bill cosby", "pie", "fat", "pudd"]
```

##CLI
------
* To list all tasks   
  `dictionary help`

* To list help for a task   
  `dictionary help task_name`   
  **example** : `dictionary help urban`   

### Using `meaning`
  
```bash
> dictionary meaning boast
boast - to speak with exaggeration and excessive pride, especially about oneself
```

####Available options and flags:

```bash
> dictionary help meaning
Usage:
  dictionary meaning WORD

Options:
  [--words=one two three]  # Specify multiple WORDS in succession
  [--file]                 # Pass file(s) as argument(s) instead.
  [--example]              # Generate an example too.
  [--similar]              # Generate a synonym too.
  [--urban]                # Give meaning from Urban Dictionary instead.
  [--write=FILE]           # Also write results to specified FILE

gives dictionary meaning of the WORD
```


```bash
> dictionary meaning --words boast sly --urban --example
boast - To gloat or brag about something - He was boasting about his fly girlfriend.
sly - To do something cunningly, preferably without any one seeing, apart from your best mate to prove you did it - "Hey Jo, see that girl there? Well we danced and she i" Slllly!"ying my child!!!"
```

### Using `similar`

```bash
> dictionary similar answer
answer is similar to - check
```

####Available options and flags

```bash
> dictionary help similar
Usage:
  dictionary similar WORD

Options:
  [--words=one two three]  # Specify multiple WORDS in succession
  [--file]                 # Pass file(s) as arugment(s) instead.
  [--urban]                # Give similar word from Urban Dictionary
  [--count=N]              # Gives N similar words
  [--write=FILE]           # Write results to specified FILE

gives syonyms of word(s)
```

```bash
> dictionary similar --words boast --urban --count 2
boast is similar to - annoying, humble
```

**Similar tasks are present for "urban" and "examples", use `help` to discover**


##Contribution

* Fork the [repository](https://github.com/AnkurGel/dictionary-rb)
* Have a look at the [API Documentation](http://rubydoc.info/gems/dictionary-rb). It is pretty well documented with explanations of all methods and modules.
* Do your changes in your remote branch
* Create a pull request.
* Earn a beer! :)


##Copyright

Copyright (c) 2014 Ankur Goel.
