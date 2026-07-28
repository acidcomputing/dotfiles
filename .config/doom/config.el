;; :: a c i d c o m p u t i n g ::
;; ~/.config/doom/config.el

;; --- F o n t s ---
(setq doom-font                (font-spec :family "JetBrains Mono Slashed" :size 17)
      doom-variable-pitch-font (font-spec :family "Inter" :size 15)
      doom-serif-font          (font-spec :family "FreeSerif" :size 19)
      doom-symbol-font         (font-spec :family "JetBrains Mono Slashed" :size 17)
      doom-big-font            (font-spec :family "JetBrains Mono Slashed" :size 24))

;; --- T h e m e s ---
(setq doom-theme 'doom-outrun-electric)

;; --- L i n e  N u m b e r s ---
(setq display-line-numbers-type t)

;; --- E d i t o r ---
;; 2 space tabs, no tabs.
(setq-default tab-width 2
              indent-tabs-mode nil)
;; --- S c r o l l i n g ---
(setq scroll-preserve-screen-position t)

;; --- A u t o s a v e 
(setq auto-save-default nil)

;; --- V t e r m ---
(setq vterm-shell "/usr/bin/zsh")
(setq vterm-max-scrollback 10000)
(setq vterm-timer-delay 0.01)

;; --- O r g  M o d e ---
(setq org-directory "~/SyncPool/DBs/PKMS/Org")

;; --- F r a m e ---
(add-to-list 'default-frame-alist '(fullscreen . maximized))
