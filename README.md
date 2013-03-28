Generate a histogram for your git repo and hunt down the largest objects.

On a large repository, the "histogram is ready" a while before the large objects
are found. As soon as "histogram is ready", open `histogram.html`.

    $ git clone https://github.com/spraints/gitogram
    ...
    $ ruby crawl.rb /path/to/repo
    Submodule path 'd3': checked out '18105839c59c24cf52caaad58ec304b0a9cc0df0'
    Submodule path 'rugged': checked out 'c8b4c28addb781b42853e8b3c0071b40614a5827'
    Submodule path 'vendor/libgit2': checked out '8cfd54f0d831922c58e62e5f69f364ede0cea89f'
    Fetching gem metadata from http://rubygems.org/.........
    Resolving dependencies...
    Installing rake (0.9.2.2)
    Installing minitest (3.0.1)
    Installing rake-compiler (0.7.9)
    Using rugged (0.17.0.b8) from source at /Users/burke/dev/gitogram/rugged
    Using bundler (1.3.2)
    Your bundle is complete! It was installed into ./.bundle/gems
    git submodule update --init
    mkdir -p tmp/x86_64-darwin12.2.1/rugged/1.9.3
    cd tmp/x86_64-darwin12.2.1/rugged/1.9.3
    /opt/boxen/rbenv/versions/1.9.3-p231-tcs-github-1.0.11/bin/ruby -I. ../../../../ext/rugged/extconf.rb
     -- make -f Makefile.embed
    checking for main() in -lgit2_embed... yes
    checking for git2.h... yes
    creating Makefile
    cd -
    cd tmp/x86_64-darwin12.2.1/rugged/1.9.3
    make
    compiling ../../../../ext/rugged/rugged.c
    compiling ../../../../ext/rugged/rugged_blob.c
    compiling ../../../../ext/rugged/rugged_branch.c
    compiling ../../../../ext/rugged/rugged_commit.c
    compiling ../../../../ext/rugged/rugged_config.c
    compiling ../../../../ext/rugged/rugged_index.c
    compiling ../../../../ext/rugged/rugged_note.c
    compiling ../../../../ext/rugged/rugged_object.c
    compiling ../../../../ext/rugged/rugged_reference.c
    compiling ../../../../ext/rugged/rugged_remote.c
    compiling ../../../../ext/rugged/rugged_repo.c
    compiling ../../../../ext/rugged/rugged_revwalk.c
    compiling ../../../../ext/rugged/rugged_settings.c
    compiling ../../../../ext/rugged/rugged_signature.c
    compiling ../../../../ext/rugged/rugged_tag.c
    compiling ../../../../ext/rugged/rugged_tree.c
    linking shared-object rugged/rugged.bundle
    cd -
    install -c tmp/x86_64-darwin12.2.1/rugged/1.9.3/rugged.bundle lib/rugged/rugged.bundle
    histogram is ready
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
    ...  found another large object
