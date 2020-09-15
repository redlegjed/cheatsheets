Setting up VS code for Python
===============================

Setting up VS code to behave in a similar manner to the Spyder IDE


Installation of extra extensions
----------------------------------

* Install standard Microsoft Python extension
* Install Codemap by Oleg Shilo for decent outline
* Install autoDocstring by Nils Werner - automatically inserts a docstring template after """


Codemap customisation
-----------------------

To get Codemap to work in a similar manner to Spyder's outline add the following to the settings:


```javascript
    // Codemap customisation
    "codemap.py": [
        {
          "pattern": "#%% .*",
          "clear": "#%% ", 
          "prefix":" *** ",         
          "icon": "level1"
        },
        {
            "pattern": "(?<![^\\r\\n\\t\\f\\v .])class (.*?)[(|:]",
            "clear": ":|",
            "prefix": "",
            "role": "class",
            "icon": "class"
        },
        {
            "pattern": "def (.*?)[(|:]",
            "clear": ":|",
            "suffix": "()",
            "role": "function",
            "icon": "function"
        }
      ],

```

This makes Codemap recognise "#%%" blocks as well as classes and functions.


Run Python Interactive Console
-------------------------------

CTRL+Shift+P -> Python Show Interactive window


Running startup code in Python Interactive Console
----------------------------------------------------

In user or workspace settings either add this:


```javascript
"python.dataScience.runMagicCommands": "print('Runs at startup')",

```

Replacing the print statement with any Python code you want, e.g. "import set_paths".

Or find the "python.dataScience.runMagicCommands" in the settings GUI and put the code in there.


Snippets
----------

```javascript

"Long double line":{
		"scope": "python,matlab",
		"prefix": "dline",
		"body": "======================================================"
	},
	"Long single line":{
		"scope": "python,matlab",
		"prefix": "sline",
		"body": "-------------------------------------------------------"
	}
	
	
```

