(setq package-check-signature nil)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)
(package-install 'use-package)
(setq use-package-always-ensure t)
(require 'use-package)

(package-install 'evil)
(require 'evil)
(evil-mode 1)

(use-package yasnippet :ensure t)
(use-package hydra :ensure t)

(use-package helm
  :config (helm-mode))

(use-package company)


(global-set-key (kbd "C-x m") 'eshell)
(use-package magit)

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
  (setcdr (assq 'java-mode eglot-server-programs)
          `("jdtls" "-data" "/home/aziem/.cache/emacs/workspace/"
            "--jvm-arg=-XX:+UseG1GC"
            "--jvm-arg=-Xmx10G"
            "--jvm-arg=-Xms1G"
            "--jvm-arg=-XX:+UseStringDeduplication"))
  :hook
  ((java-mode . eglot-ensure))

  :custom
  (eglot-report-progress t)
  (eglot-confirm-server-initiated-edits 'confirm)
  (eglot-autoshutdown t)
  (eglot-extend-to-xref t)
  (eglot-stay-out-of '(flymake)))

;; (defun kb/java-mode ()
;;   "Configure java mode settings."
;;   (subword-mode)
;;   (setq-local tab-width 4)
;;   (setq-local c-basic-offset 4)
;;   (eglot-ensure))

;; (use-package eglot-java
;;   :after eglot
;;   :config
;;   (setq eglot-java-eclipse-jdt-args (list "-noverify"
;;                                           "-Xms1G"
;;                                           "-Xmx10G"
;;                                           "-XX:+UnlockExperimentalVMOptions"
;;                                           "-XX:+UseZGC"
;;                                           "-XX:+UseStringDeduplication"
;;                                           "-XX:AdaptiveSizePolicyWeight=90"
;;                                           "-Dsun.zip.disableMemoryMapping=true"))
;;   :hook ((java-mode . eglot-java-mode)
;;          (java-ts-mode . eglot-java-mode)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(eglot-confirm-server-edits 'confirm nil nil "Customized with use-package eglot")
 '(package-selected-packages
   '(company eglot magit helm hydra yasnippet evil use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
