## 
##  Copyright (C) the libgit2 contributors. All rights reserved.
## 
##  This file is part of libgit2, distributed under the GNU GPL v2 with
##  a Linking Exception. For full terms see the included COPYING file.
## 

{.push dynlib: "libgit2".}
{.push callconv: cdecl.}
import
  common, types, oid, buffer

## *
##  @file git2/filter.h
##  @brief Git filter APIs
## 
##  @ingroup Git
##  @{
## 
## *
##  Filters are applied in one of two directions: smudging - which is
##  exporting a file from the Git object database to the working directory,
##  and cleaning - which is importing a file from the working directory to
##  the Git object database.  These values control which direction of
##  change is being applied.
## 

type
  git_filter_mode_t* = enum
    GIT_FILTER_TO_WORKTREE = 0, GIT_FILTER_TO_ODB = 1

const
  GIT_FILTER_SMUDGE = GIT_FILTER_TO_WORKTREE
  GIT_FILTER_CLEAN = GIT_FILTER_TO_ODB

## *
##  Filter option flags.
## 

type
  git_filter_flag_t* = enum
    GIT_FILTER_DEFAULT = 0, GIT_FILTER_ALLOW_UNSAFE = (1 shl 0)


## *
##  A filter that can transform file data
## 
##  This represents a filter that can be used to transform or even replace
##  file data.  Libgit2 includes one built in filter and it is possible to
##  write your own (see git2/sys/filter.h for information on that).
## 
##  The two builtin filters are:
## 
##  * "crlf" which uses the complex rules with the "text", "eol", and
##    "crlf" file attributes to decide how to convert between LF and CRLF
##    line endings
##  * "ident" which replaces "$Id$" in a blob with "$Id: <blob OID>$" upon
##    checkout and replaced "$Id: <anything>$" with "$Id$" on checkin.
## 


## *
##  List of filters to be applied
## 
##  This represents a list of filters to be applied to a file / blob.  You
##  can build the list with one call, apply it with another, and dispose it
##  with a third.  In typical usage, there are not many occasions where a
##  git_filter_list is needed directly since the library will generally
##  handle conversions for you, but it can be convenient to be able to
##  build and apply the list sometimes.
## 


## *
##  Load the filter list for a given path.
## 
##  This will return 0 (success) but set the output git_filter_list to NULL
##  if no filters are requested for the given file.
## 
##  @param filters Output newly created git_filter_list (or NULL)
##  @param repo Repository object that contains `path`
##  @param blob The blob to which the filter will be applied (if known)
##  @param path Relative path of the file to be filtered
##  @param mode Filtering direction (WT->ODB or ODB->WT)
##  @param flags Combination of `git_filter_flag_t` flags
##  @return 0 on success (which could still return NULL if no filters are
##          needed for the requested file), <0 on error
## 

proc git_filter_list_load*(filters: ptr ptr git_filter_list; 
                          repo: ptr git_repository; blob: ptr git_blob; path: cstring;
                          mode: git_filter_mode_t; flags: uint32): cint {.importc.}
  ##  can be NULL
## *
##  Query the filter list to see if a given filter (by name) will run.
##  The built-in filters "crlf" and "ident" can be queried, otherwise this
##  is the name of the filter specified by the filter attribute.
## 
##  This will return 0 if the given filter is not in the list, or 1 if
##  the filter will be applied.
## 
##  @param filters A loaded git_filter_list (or NULL)
##  @param name The name of the filter to query
##  @return 1 if the filter is in the list, 0 otherwise
## 

proc git_filter_list_contains*(filters: ptr git_filter_list; name: cstring): cint  {.importc.}
## *
##  Apply filter list to a data buffer.
## 
##  See `git2/buffer.h` for background on `git_buf` objects.
## 
##  If the `in` buffer holds data allocated by libgit2 (i.e. `in->asize` is
##  not zero), then it will be overwritten when applying the filters.  If
##  not, then it will be left untouched.
## 
##  If there are no filters to apply (or `filters` is NULL), then the `out`
##  buffer will reference the `in` buffer data (with `asize` set to zero)
##  instead of allocating data.  This keeps allocations to a minimum, but
##  it means you have to be careful about freeing the `in` data since `out`
##  may be pointing to it!
## 
##  @param out Buffer to store the result of the filtering
##  @param filters A loaded git_filter_list (or NULL)
##  @param in Buffer containing the data to filter
##  @return 0 on success, an error code otherwise
## 

proc git_filter_list_apply_to_data*(`out`: ptr git_buf; 
                                   filters: ptr git_filter_list; `in`: ptr git_buf): cint {.importc.}
## *
##  Apply a filter list to the contents of a file on disk
## 
##  @param out buffer into which to store the filtered file
##  @param filters the list of filters to apply
##  @param repo the repository in which to perform the filtering
##  @param path the path of the file to filter, a relative path will be
##  taken as relative to the workdir
## 

proc git_filter_list_apply_to_file*(`out`: ptr git_buf; 
                                   filters: ptr git_filter_list;
                                   repo: ptr git_repository; path: cstring): cint {.importc.}
## *
##  Apply a filter list to the contents of a blob
## 
##  @param out buffer into which to store the filtered file
##  @param filters the list of filters to apply
##  @param blob the blob to filter
## 

proc git_filter_list_apply_to_blob*(`out`: ptr git_buf; 
                                   filters: ptr git_filter_list; blob: ptr git_blob): cint {.importc.}
## *
##  Apply a filter list to an arbitrary buffer as a stream
## 
##  @param filters the list of filters to apply
##  @param data the buffer to filter
##  @param target the stream into which the data will be written
## 

proc git_filter_list_stream_data*(filters: ptr git_filter_list; data: ptr git_buf; 
                                 target: ptr git_writestream): cint {.importc.}
## *
##  Apply a filter list to a file as a stream
## 
##  @param filters the list of filters to apply
##  @param repo the repository in which to perform the filtering
##  @param path the path of the file to filter, a relative path will be
##  taken as relative to the workdir
##  @param target the stream into which the data will be written
## 

proc git_filter_list_stream_file*(filters: ptr git_filter_list; 
                                 repo: ptr git_repository; path: cstring;
                                 target: ptr git_writestream): cint {.importc.}
## *
##  Apply a filter list to a blob as a stream
## 
##  @param filters the list of filters to apply
##  @param blob the blob to filter
##  @param target the stream into which the data will be written
## 

proc git_filter_list_stream_blob*(filters: ptr git_filter_list; blob: ptr git_blob; 
                                 target: ptr git_writestream): cint {.importc.}
## *
##  Free a git_filter_list
## 
##  @param filters A git_filter_list created by `git_filter_list_load`
## 

proc git_filter_list_free*(filters: ptr git_filter_list)  {.importc.}
## * @}
