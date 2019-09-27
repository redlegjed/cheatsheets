Setting up VS code for Python
===============================

Installation of extra extensions
----------------------------------

* Install standard Microsoft Python extension
* Install Codemap for decent outline


Codemap customisation
-----------------------

To get Codemap to work in a similar manner to Spyder add the following to the settings:

``
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

``

This makes Codemap recognise "#%%" blocks as well as classes and functions.



Running startup code in Python Interactive Console
----------------------------------------------------

In user or workspace settings either add this:

``
"python.dataScience.runMagicCommands": "print('Runs at startup')",

``

Replacing the print statement with any Python code you want, e.g. "import set_paths".

Or find the "python.dataScience.runMagicCommands" in the settings GUI and put the code in there.




