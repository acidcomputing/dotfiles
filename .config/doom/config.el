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
;; Scrolling
(setq scroll-preserve-screen-position t)
;; Kill autosave
(setq auto-save-default nil)

;; --- O r g  M o d e ---
(setq org-directory "~/SyncPool/DBs/PKMS/Org")

;; --- F r a m e ---
(add-to-list 'default-frame-alist '(fullscreen . maximized))
