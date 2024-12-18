(setq package-check-signature nil)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)


(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)
(package-install 'use-package)
(setq use-package-always-ensure t)
(require 'use-package)

(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-types '((comp) (bytecomp)))

(setq-default tab-width 4                       ; Smaller tabs
              indent-tabs-mode nil              ; Use spaces instead of tabs
              auto-fill-function 'do-auto-fill) ; Auto-fill-mode everywhere

(package-install 'evil)
(require 'evil)
(evil-mode 1)

(use-package modus-themes)
(use-package wgrep)
(use-package powerline
  :commands powerline-default-theme
  :config
  (powerline-vim-theme))

(add-hook 'after-init-hook (lambda () (recentf-mode 1)))
(setq-default recentf-max-save-items 1000)
(setq-default recentf-exclude '("/tmp/", "/ssh:"))


(use-package yasnippet :ensure t)
(use-package hydra :ensure t)

(use-package helm
  :config (helm-mode))

(use-package company
  :ensure t
  :config (global-company-mode 1))


(global-set-key (kbd "C-x m") 'eshell)
(use-package magit)

(use-package diff-hl
  :config
  (global-diff-hl-mode 1))

(use-package project
  :config
  (add-to-list 'project-switch-commands '(magit-project-status "Magit"
                                                               ?m)))
(use-package org
  :defer t
  :config
  (setq org-adapt-indentation t
        org-hide-leading-stars t
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-src-fontify-natively t
        org-startup-folded t
        org-edit-src-content-indentation 0))

(use-package vterm
  :defer t
  :preface
  (defvar vterms nil)

  (defun toggle-vterm (&optional n)
    (interactive)
    (setq vterms (seq-filter 'buffer-live-p vterms))
    (let ((default-directory (or (vc-root-dir) default-directory)))
     (cond ((numberp n) (push (vterm n) vterms))
           ((null vterms) (push (vterm 1) vterms))
           ((seq-contains-p vterms (current-buffer))
            (switch-to-buffer (car (seq-difference (buffer-list) vterms))))
           (t (switch-to-buffer (car (seq-intersection (buffer-list) vterms)))))))

  :config
  ;; Don't query about killing vterm buffers, just kill it
  (defadvice vterm (after kill-with-no-query nil activate)
    (set-process-query-on-exit-flag (get-buffer-process ad-return-value) nil)))

(use-package which-key
  :config
  (which-key-mode 1))


(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "M-o") 'ace-window)
(global-set-key (kbd "C-x g") 'magit-status)

(use-package eglot
  :bind (("C-c e w r" . #'eglot-reconnect)
         ("C-c e w S" . #'eglot-shutdown)
         ("C-c e g d" . #'eglot-find-declaration)
         ("C-c e g r" . #'eglot-find-implementation)
         ("C-c e g t" . #'eglot-find-typeDefinition)
         ("C-c e o i" . #'eglot-code-action-organize-imports)
         ("C-c e x r" . #'xref-find-references)
         ("C-c e x d" . #'xref-find-definitions)
         ("C-c e x 4 d" . #'xref-find-definitions-other-window)
         ("C-c e x b" . #'xref-go-back)
         ("C-c e x f" . #'xref-go-forward)
         ("C-c e r" . #'eglot-rename)
         ("C-c e F" . #'eglot-format-buffer))
  :config
  (add-to-list 'eglot-server-programs
	       '(java-mode . ("jdtls" "-data" "/home/aziem/.cache/emacs/workspace/"
			      "--jvm-arg=-XX:+UseG1GC"
			      "--jvm-arg=-Xmx10G"
			      "--jvm-arg=-Xms1G"
			      "--jvm-arg=-XX:+UseStringDeduplication")))
  (add-to-list 'eglot-server-programs
               '((c-mode c-ts-mode c++-mode c++-ts-mode) . ("ccls")))


  :hook
  ((java-mode . eglot-ensure)
   (c-mode . eglot-ensure)
   (c-ts-mode . eglot-ensure)
   (c++-mode . eglot-ensure)
   (c++-ts-mode . eglot-ensure))

  :custom
  (eglot-report-progress t)
  (eglot-confirm-server-initiated-edits 'confirm)
  (eglot-autoshutdown t)
  (eglot-extend-to-xref t)
  (eglot-stay-out-of '(flymake)))

(use-package company
  :defer t
  :ensure t
  :custom
  (company-tooltip-align-annotations t)
  (company-minimum-prefix-min-length 1)
  (company-idle-delay 0.2)
  (company-tooltip-maximum-width 50)
    (define-key company-active-map (kbd "C-y")
			  (lambda ()
				(interactive)
				(company-show-doc-buffer)))
  (define-key company-active-map [tab] 'company-complete-selection)
  (define-key company-active-map (kbd "TAB") 'company-complete-selection)
  (define-key company-active-map [ret] 'company-complete-selection)
  (define-key company-active-map (kbd "RET") 'company-complete-selection)
  :hook
  (after-init . global-company-mode))

(use-package diff-hl
  :defer t
  :ensure t
  :hook
  (find-file . (lambda ()
                 (global-diff-hl-mode)           ;; Enable Diff-HL mode for all files.
                 (diff-hl-flydiff-mode)          ;; Automatically refresh diffs.
                 (diff-hl-margin-mode)))         ;; Show diff indicators in the margin.
  :custom
  (diff-hl-side 'left)                           ;; Set the side for diff indicators.
  (diff-hl-margin-symbols-alist '((insert . "│") ;; Customize symbols for each change type.
                                   (delete . "-")
                                   (change . "│")
                                   (unknown . "?")
                                   (ignored . "i"))))


(use-package xclip
  :ensure t
  :defer t
  :hook
  (after-init . xclip-mode))

(use-package indent-guide
  :defer t
  :ensure t
  :hook
  (prog-mode . indent-guide-mode)  ;; Activate indent-guide in programming modes.
  :config
  (setq indent-guide-char "│"))

(use-package rainbow-delimiters
  :defer t
  :ensure t
  :hook
  (prog-mode . rainbow-delimiters-mode))



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("b0cbcb2fa0c69ab36f4505fec9967969b73327f1b8564f9afface8afd216bc93" "1d6b446390c172036395b3b87b75321cc6af7723c7545b28379b46cc1ae0af9e" "9a977ddae55e0e91c09952e96d614ae0be69727ea78ca145beea1aae01ac78d2" "e410458d3e769c33e0865971deb6e8422457fad02bf51f7862fa180ccc42c032" default))
 '(eglot-confirm-server-edits 'confirm nil nil "Customized with use-package eglot")
 '(helm-completion-style 'helm)
 '(package-selected-packages
   '(rainbow-delimiters indent-guide xclip powerline modus-themes company eglot magit helm hydra yasnippet evil use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

