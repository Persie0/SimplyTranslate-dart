# Releases

# 2.2.2
- due to excessive usage and misuse, the public instance is now removed
- you have to set a custom remote url to get working instances now
- checkout https://github.com/Persie0/Simplytranslate-Endpoint-Tester for more information

# 2.2.1+3
- updated example code

# 2.2.1
- added method to get languages and their codes

# 2.2.0
- updated http dependency
- added parameter to set a custom remote to get working instances
- fixed translation of special characters (e.g. ÄÖÜ) with some instances
- isLingvaInstanceWorking() added
- fixed isSimplyInstanceWorking()
- (dev) added tests

# 2.1.0
- updated fetchInstances(), now only returns working instances
- updated readme
- updated example


# 2.0.2
- improved documentation, removed unnecessary code

# 2.0.1
- add function to update instances with unofficial github repo

# 2.0.0
- added Lingva Translate
- updated instances list
- updated dependencies
- updated example and readme

# 1.2.4
- removed updateSimplyInstances() as it is does not work anymore (Codeberg project looks abandoned)
- updated instances list

# 1.2.3
- updated dependencies

# 1.2.2
- updated instance list

# 1.2.1
- added speedTest() for execution time test of function

# 1.1.4
- fixed null error when no languages passed at tr()

# 1.1.3
- refactored tr() so it is faster and returns no errors which could be thrown with translate()

# 1.1.2
- frequencyTranslations now returns no word twice

# 1.1.1
- default instance is now random
- retry option added - when the server returns an error
- instance list can now be fetched from the website
- Instance "tl.vern.cc" got blacklisted as it is the only instance that throws an error when used (excessively).

# 1.1.0
- added classes for Definitions and Translations to simplify the response
- added different instances and functions for instances
- By default looping now through instances to lower server load

# 1.0.8
- using post method now to support the translation of longer texts
- added example for changing instance 

# 1.0.7
- optics

# 1.0.5
- shorter Method added

# 1.0.4
- Fixed Readme error
- Code formatted

# 1.0.2
- Licence

# 0.0.1
- Initial release.
- Usage and example
