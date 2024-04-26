(doom! :completion
       (corfu +orderless +dabbrev)
       (vertico +icons)

       :ui
       modeline
       nav-flash
       ophints
       (popup +defaults)
       treemacs
       (vc-gutter +pretty)
       vi-tilde-fringe
       workspaces

       :editor
       (evil +everywhere)
       fold
       multiple-cursors

       :term
       eshell

       :checkers
       (syntax +flymake)

       :tools
       lookup
       (lsp +eglot)
       magit

       :lang
       emacs-lisp
       json
       markdown

       :config
       (default +bindings +smartparens))
