
Regular expression for excluding websites
--------------------------------------------

(?!http(s)?://(www\.)?(example\.com|192.168.1.100|hushmail\.com|weather\.gc\.ca|duckduckgo\.com|outlook\.office365\.com|office\.com|office365\.com).*).* 


Midnight surfing regex
------------------------
(?!http(s)?://(www\.)?(example\.com|192.168.1.100|weather\.gc\.ca|duckduckgo\.com|outlook\.office365\.com|office\.com|office365\.com|outlook\.office\.com|localhost:8888|0\.0\.0\.0).*).*

Old stylish Midnight surfing regex 
------------------------------------

@-moz-document regexp("(?!http(s)?://(www\\.)?(example\\.com|192\\.168\\.1\\.100|weather\\.gc\\.ca|duckduckgo\\.com|outlook\\.office365\\.com|office\\.com|office365\\.com|outlook\\.office\\.com|localhost:8888|0\\.0\\.0\\.0|confluence|bitbucket).*).*")
{

/* Rest of style goes in here */

}


Link to stylish creator's site
----------------------------------
https://github.com/stylish-userstyles/stylish/wiki/Applying-styles-to-specific-sites