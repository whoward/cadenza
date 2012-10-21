This is the changelog, this will contain a summary of important changes for
each release.  For the full list please see "git log".  

Each line will include the most relevant commit for each note with the git commit
ref (ex: 441294c) and a tag (ex: (B) ) to describe it:
   B - Bug
   F - Feature

== 0.7.1
* 8046c3f (B) for loops in extended templates should render blocks in subtree
* 441294c (F) Add a simple command line interface
* 9713e63 (B) introduce multi_json gem dependency for JSON parsing in CLI
* 925806e (F) add Cadenza::ContextObject which must be an ancestor class of any object bound to the context as of 0.8.0

== 0.7.0
* 656c063 (F) first publicly released version