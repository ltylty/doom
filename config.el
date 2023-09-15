;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(+global-word-wrap-mode +1)
(add-hook 'window-setup-hook #'toggle-frame-maximized)
(add-hook 'prog-mode-hook #'symbol-overlay-mode)
(add-to-list 'process-coding-system-alist '("[rR][gG]" . (utf-8 . gbk-dos)))
(set-selection-coding-system 'utf-16le-dos)
(setq-hook! 'sql-mode-hook comment-line-break-function nil)

;; company
(after! company
  (setq company-dabbrev-code-ignore-case t
        company-dabbrev-ignore-case t)
  (set-company-backend! 'text-mode 'company-dabbrev)
  (set-company-backend! 'sql-mode '(company-dabbrev-code company-dabbrev)))

;; sql-formatter
(setq sqlformat-command 'sql-formatter)
(setq sqlformat-args '("-l" "bigquery"))
(map! :after sql
      :map sql-mode-map
      "C-c C-f" #'sqlformat)

(setenv "PYTHONIOENCODING" "utf-8")
(set-formatter! 'my-sqlformat "sqlformat --encoding utf-8 -a -")
(setq-hook! 'sql-mode-hook +format-with 'my-sqlformat)

;; treemacs
(map! :leader
      :desc "Select treemacs"
      "0" #'treemacs-select-window)
(after! treemacs
  (setq treemacs-collapse-dirs 10)
  (treemacs-project-follow-mode t)
  (treemacs-follow-mode t)
  (treemacs-git-mode 'deferred))

;; evil
(require 'evil-textobj-line)
(defun insert-state-create-tab ()
  (interactive)
  (centaur-tabs--create-new-tab)
  (evil-append 1))
(define-key evil-insert-state-map (kbd "C-c") 'kill-ring-save)
(define-key evil-insert-state-map (kbd "C-v") 'yank)
(define-key evil-insert-state-map (kbd "C-x") 'kill-region)
(define-key evil-insert-state-map (kbd "C-z") 'undo-fu-only-undo)
(define-key evil-insert-state-map (kbd "C-y") 'undo-fu-only-redo)
(define-key evil-insert-state-map (kbd "C-a") 'mark-page)
(define-key evil-insert-state-map (kbd "C-d") 'kill-whole-line)
(define-key evil-insert-state-map (kbd "C-s") 'save-buffer)
(define-key evil-insert-state-map (kbd "C-f") '+default/search-buffer)
(define-key evil-insert-state-map (kbd "C-h") '+default/search-project)
(define-key evil-insert-state-map (kbd "C-q") 'goto-last-change)
(define-key evil-insert-state-map (kbd "<home>") 'doom/backward-to-bol-or-indent)
(define-key evil-insert-state-map (kbd "<end>") 'doom/forward-to-last-non-comment-or-eol)
(define-key evil-insert-state-map (kbd "C-<prior>")  'centaur-tabs-backward)
(define-key evil-insert-state-map (kbd "C-<next>") 'centaur-tabs-forward)
(define-key evil-insert-state-map (kbd "C-<up>") 'evil-scroll-line-up)
(define-key evil-insert-state-map (kbd "C-<down>") 'evil-scroll-line-down)
(define-key evil-insert-state-map (kbd "C-/") 'comment-dwim)
(define-key evil-insert-state-map (kbd "C-o") 'find-file)
(define-key evil-insert-state-map (kbd "C-S-f") 'format-all-buffer)
(define-key evil-insert-state-map (kbd "C-<f4>") 'kill-current-buffer)
(define-key evil-insert-state-map (kbd "C-n") 'insert-state-create-tab)
(define-key evil-insert-state-map (kbd "C-S-x") 'upcase-dwim)
(define-key evil-insert-state-map (kbd "C-S-y") 'downcase-dwim)
(define-key evil-insert-state-map (kbd "C-M-<down>") 'duplicate-line)
(define-key evil-insert-state-map (kbd "C-S-l") 'mc/mark-all-like-this)
(define-key evil-insert-state-map (kbd "M-S-i") 'mc/edit-lines)
(define-key evil-insert-state-map (kbd "M-i") 'mc/edit-lines)
(define-key evil-insert-state-map (kbd "S-<down-mouse-1>") 'mouse-save-then-kill)
(define-key evil-insert-state-map (kbd "S-<left>") 'nil)
(define-key evil-insert-state-map (kbd "S-<right>") 'nil)
(define-key evil-insert-state-map (kbd "M-S-<up>") 'er/expand-region)
(define-key evil-insert-state-map (kbd "M-S-<down>") 'er/contract-region)
(setq expand-region-contract-fast-key "<down>"
      expand-region-reset-fast-key "<escape>")
