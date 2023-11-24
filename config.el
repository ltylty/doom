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
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
(setq doom-font (font-spec :family "Maple Mono SC NF Bold"))
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

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

(add-hook 'window-setup-hook #'toggle-frame-maximized)
(add-hook 'prog-mode-hook #'symbol-overlay-mode)
(set-selection-coding-system 'utf-16le-dos)
(setq org-log-done 'time)

;; word-wrap
(+global-word-wrap-mode +1)
(setq word-wrap-by-category t)

;; magit
(after! magit
  (setq magit-ediff-dwim-show-on-hunks t))

;; consult
(add-to-list 'process-coding-system-alist '("[rR][gG]" . (utf-8 . gbk-dos)))
(add-to-list 'process-coding-system-alist '("[gG][rR][eE][pP]" . (utf-8 . gbk-dos)))
(after! consult
  (setq consult-async-input-debounce 0.5))

;; doom-modeline
(setq doom-modeline-buffer-encoding t)
(setq doom-modeline-indent-info nil)

;; format sql
(setq sqlformat-command 'sql-formatter)
(setq sqlformat-args '("-l" "bigquery"))
(map! :after sql
      :map sql-mode-map
      "C-c C-f" #'sqlformat)

(setenv "PYTHONIOENCODING" "utf-8")
(set-formatter! 'format-sql-with-sqlformat '("sqlformat" "--encoding" "utf-8" "-a" "-") :modes '(sql-mode))

;; treemacs
(after! treemacs
  (setq treemacs-collapse-dirs 10)
  (treemacs-project-follow-mode t)
  (treemacs-follow-mode t)
  (treemacs-git-mode 'deferred))
(map! :leader
      :desc "Select treemacs"
      "0" #'treemacs-select-window)
(map! :leader
      (:prefix-map ("o" . "open")
      :desc "browse-file-directory" "o" #'(lambda () (interactive) (browse-url default-directory))))

;; evil
(use-package evil
  :custom
  evil-disable-insert-state-bindings t
  )
(defun disable-cua-mode ()
  (cua-mode -1))
(add-hook 'evil-insert-state-entry-hook #'cua-mode)
(add-hook 'evil-insert-state-exit-hook  #'disable-cua-mode)
(setq +evil-want-o/O-to-continue-comments nil)
(require 'evil-textobj-line)

;; completion
(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-prefix 1)
  (corfu-auto-delay 0)
  :init
  (global-corfu-mode))
(add-hook 'evil-insert-state-exit-hook #'corfu-quit)

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword))
