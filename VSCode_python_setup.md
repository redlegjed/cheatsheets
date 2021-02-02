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

Setting up paths 
-----------------
This is basically a confusing mess of settings that I just don't understand very well.

The best 'documenation' I have come across is in a [Stack overflow](https://stackoverflow.com/questions/53653083/how-to-correctly-set-pythonpath-for-visual-studio-code)

My understanding so far:

* Creating a .env file and putting a PYTHONPATH variable in it seems to work with the Jupyter interactive interpreter. The paths must be absolute though. You can't use the ${WorkspaceFolder} variable. Example shown here

```
PYTHONPATH="/home/user/project_folder/source:/home/user/project_folder/common:/home/user/project_folder/unit_tests" 
```

* Use the _launch.json_ file to add paths for running programs using F5. The contents on _.env_ file can be added like this:

```
"env": {"PYTHONPATH": "${workspaceFolder}:${workspaceFolder}/in_launch:${env:PYTHONPATH}"}
```


_launch.json_
--------------

```
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        
        {
            "name": "Python: Current File",
            "type": "python",
            "request": "launch",
            "program": "${file}",
            "console": "integratedTerminal",
            "cwd": "${fileDirname}",
            "env": {"PYTHONPATH": "${workspaceFolder}:${workspaceFolder}/other_path:${env:PYTHONPATH}"}
        }
    ],
    
}

```

The line "${env:PYTHONPATH}" includes the .env file