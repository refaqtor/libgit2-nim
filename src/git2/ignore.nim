## 
##  Copyright (C) the libgit2 contributors. All rights reserved.
## 
##  This file is part of libgit2, distributed under the GNU GPL v2 with
##  a Linking Exception. For full terms see the included COPYING file.
## 

{.push dynlib: "libgit2".}
{.push callconv: cdecl.}
import
  common, types

## *
##  Add ignore rules for a repository.
## 
##  Excludesfile rules (i.e. .gitignore rules) are generally read from
##  .gitignore files in the repository tree or from a shared system file
##  only if a "core.excludesfile" config value is set.  The library also
##  keeps a set of per-repository internal ignores that can be configured
##  in-memory and will not persist.  This function allows you to add to
##  that internal rules list.
## 
##  Example usage:
## 
##      error = git_ignore_add_rule(myrepo, "*.c\ndir/\nFile with space\n");
## 
##  This would add three rules to the ignores.
## 
##  @param repo The repository to add ignore rules to.
##  @param rules Text of rules, a la the contents of a .gitignore file.
##               It is okay to have multiple rules in the text; if so,
##               each rule should be terminated with a newline.
##  @return 0 on success
## 

proc git_ignore_add_rule*(repo: ptr git_repository; rules: cstring): cint  {.importc.}
## *
##  Clear ignore rules that were explicitly added.
## 
##  Resets to the default internal ignore rules.  This will not turn off
##  rules in .gitignore files that actually exist in the filesystem.
## 
##  The default internal ignores ignore ".", ".." and ".git" entries.
## 
##  @param repo The repository to remove ignore rules from.
##  @return 0 on success
## 

proc git_ignore_clear_internal_rules*(repo: ptr git_repository): cint  {.importc.}
## *
##  Test if the ignore rules apply to a given path.
## 
##  This function checks the ignore rules to see if they would apply to the
##  given file.  This indicates if the file would be ignored regardless of
##  whether the file is already in the index or committed to the repository.
## 
##  One way to think of this is if you were to do "git add ." on the
##  directory containing the file, would it be added or not?
## 
##  @param ignored boolean returning 0 if the file is not ignored, 1 if it is
##  @param repo a repository object
##  @param path the file to check ignores for, relative to the repo's workdir.
##  @return 0 if ignore rules could be processed for the file (regardless
##          of whether it exists or not), or an error < 0 if they could not.
## 

proc git_ignore_path_is_ignored*(ignored: ptr cint; repo: ptr git_repository; 
                                path: cstring): cint {.importc.}