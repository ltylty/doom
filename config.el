;; base
(setq doom-font (font-spec :family "Maple Mono SC NF Bold"))
(setq doom-theme 'ef-maris-dark)
(setq display-line-numbers-type t)
(add-hook 'window-setup-hook #'toggle-frame-maximized)
(set-selection-coding-system 'utf-16le-dos)
(setq org-log-done 'time)

;; word-wrap
(setq word-wrap-by-category t)
(global-visual-line-mode)

;; magit
(after! magit
  (setq magit-status-margin '(t "%Y-%m-%d %H:%M " magit-log-margin-width t 18))
  (setq magit-log-margin '(t "%Y-%m-%d %H:%M " magit-log-margin-width t 18))
  (setq magit-ediff-dwim-show-on-hunks t))

;; consult
(add-to-list 'process-coding-system-alist '("[rR][gG]" . (utf-8 . gbk-dos)))
(add-to-list 'process-coding-system-alist '("[gG][rR][eE][pP]" . (utf-8 . gbk-dos)))
(after! consult
  (setq consult-async-input-debounce 0.8))

;; doom-modeline
(setq doom-modeline-buffer-encoding t)
(setq doom-modeline-indent-info nil)

;; sqlformat
(map! :map sql-mode-map
      "C-c C-f" #'sqlformat)

;; treemacs
(use-package! treemacs
  :init
  (setq +treemacs-git-mode 'deferred)
  :config
  (treemacs-project-follow-mode t)
  (treemacs-follow-mode t))
(map! :leader
      :desc "Select treemacs"
      "0" #'treemacs-select-window)
(map! :leader
      :desc "browse-file-directory"
      "o o" #'(lambda () (interactive) (browse-url default-directory)))

;; evil
(use-package! evil
  :custom
  (evil-disable-insert-state-bindings t)
  (+evil-want-o/O-to-continue-comments nil))

(defun exit-insert-state ()
  (cua-mode -1)
  (setq org-support-shift-select nil))
(defun entry-insert-state ()
  (cua-mode 1)
  (setq org-support-shift-select 'always))
(add-hook 'evil-insert-state-entry-hook #'entry-insert-state)
(add-hook 'evil-insert-state-exit-hook  #'exit-insert-state)
(define-key evil-insert-state-map (kbd "<home>") 'doom/backward-to-bol-or-indent)
(define-key evil-insert-state-map (kbd "<end>") 'doom/forward-to-last-non-comment-or-eol)
(map! :nv "gh" #'evil-first-non-blank)
(map! :nv "gl" #'evil-end-of-line)
(after! esh-mode
  (map! :map eshell-mode-map
        :i  "C-w"  #'backward-kill-word))
(require 'evil-textobj-line)

;; prog
(add-hook 'prog-mode-hook 'highlight-thing-mode)
(setq highlight-thing-exclude-thing-under-point t)
(custom-set-faces
   '(highlight-thing ((t (:background "dark slate gray" :foreground "white")))))

(use-package! treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (global-treesit-auto-mode))

(add-hook 'java-ts-mode-hook 'eglot-java-mode)
(add-hook 'python-ts-mode-hook 'eglot-ensure)
